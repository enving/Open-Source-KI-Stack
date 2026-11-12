# Läuft IM OpenWebUI-Container (wird von composio-mcp-einrichten.sh per stdin übergeben).
# Trägt Composio als MCP-Werkzeugserver in tool_server.connections ein, idempotent:
#   composio        OAuth 2.1, jede Person meldet sich mit ihrem eigenen Composio-Konto an (alle Nutzer)
#   composio-admin  API-Schlüssel im Header x-consumer-api-key, nur für Admins (leere access_grants)
# Andere Werkzeugserver bleiben unverändert. Eine bestehende OAuth-Registrierung wird wiederverwendet.
import asyncio
import os
import sys

from open_webui.models.config import Config
from open_webui.utils.oauth import encrypt_data, get_oauth_client_info_with_dynamic_client_registration

MCP_URL = 'https://connect.composio.dev/mcp'
OAUTH_ID = 'composio'
ADMIN_ID = 'composio-admin'


class _Anfrage:
    """Ersatz für den HTTP-Request: die Registrierung braucht nur die öffentliche Basisadresse."""

    def __init__(self, base_url):
        self.base_url = base_url


def _verbindung(server_id, name, auth_type, beschreibung, headers=None, grants=None, info_extra=None):
    return {
        'url': MCP_URL,
        'path': '',
        'type': 'mcp',
        'auth_type': auth_type,
        'forward_cookies': False,
        'headers': headers,
        'key': '',
        'config': {'enable': True, 'access_grants': grants or []},
        'info': {'id': server_id, 'name': name, 'description': beschreibung, **(info_extra or {})},
    }


async def main():
    oeffentliche_url = os.environ['OPENWEBUI_OEFFENTLICHE_URL'].rstrip('/')
    api_key = os.environ.get('COMPOSIO_API_KEY', '')

    bestehend = await Config.get('tool_server.connections', []) or []
    alt = {(c.get('info') or {}).get('id'): c for c in bestehend}
    andere = [c for c in bestehend if (c.get('info') or {}).get('id') not in (OAUTH_ID, ADMIN_ID)]

    client_info = ((alt.get(OAUTH_ID) or {}).get('info') or {}).get('oauth_client_info')
    if client_info:
        print('composio: vorhandene OAuth-Registrierung wird weiterverwendet')
    else:
        registriert = await get_oauth_client_info_with_dynamic_client_registration(
            _Anfrage(oeffentliche_url), f'mcp:{OAUTH_ID}', MCP_URL
        )
        client_info = encrypt_data(registriert.model_dump(mode='json'))
        print(f'composio: OAuth-Client registriert, Rückruf {oeffentliche_url}/oauth/clients/mcp:{OAUTH_ID}/callback')

    neu = [
        _verbindung(
            OAUTH_ID,
            'Composio (eigenes Konto)',
            'oauth_2.1',
            'Jede Person verbindet ihr eigenes Composio-Konto.',
            grants=[{'principal_type': 'user', 'principal_id': '*', 'permission': 'read'}],
            info_extra={'oauth_client_info': client_info},
        )
    ]
    if api_key:
        neu.append(
            _verbindung(
                ADMIN_ID,
                'Composio (Admin-Test)',
                'none',
                'Testzugang mit dem API-Schlüssel des Admin-Kontos. Nur Admins.',
                headers={'x-consumer-api-key': api_key},
            )
        )
        print('composio-admin: eingetragen (nur Admins)')
    else:
        print('composio-admin: COMPOSIO_API_KEY fehlt, Admin-Testzugang ausgelassen')

    await Config.upsert({'tool_server.connections': andere + neu})
    print(f'tool_server.connections: {len(andere)} andere + {len(neu)} Composio')


if __name__ == '__main__':
    try:
        asyncio.run(main())
    except Exception as fehler:
        print(f'Fehler: {type(fehler).__name__}: {fehler}', file=sys.stderr)
        sys.exit(1)
