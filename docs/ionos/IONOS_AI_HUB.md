https://docs.ionos.com/cloud/ai/ai-model-hub/tutorials

Ionos Embedding models
Supported embedding models
The following models are currently available for embedding generation in the IONOS AI Model Hub, each suited for different use cases:

Model Source
Model Name
Description
Hugging Face (Publication)

Paraphrase Multilingual MPNet base v2

Transformer model supporting several different languages with high performance and short input length (128 tokens).

Hugging Face (License)

BAAI Large EN V1.5

Embedding model specific for english, medium sized inputs (512 tokens).

Hugging Face (License)

BAAI M3

Multipurpose embedding model for multilingual text(100 working languages) and large documents (8192 tokens).


Ionos Beispiel:
Generate Embeddings with Your Prompt
To generate an embedding, send the text to the /embeddings endpoint.

Python
Bash
Copy
# Python example for embedding generation
import requests

IONOS_API_TOKEN = "[YOUR API TOKEN HERE]"
MODEL_NAME = "[MODEL NAME HERE]"
INPUT = ["Michael Jackson", "Metallica"]

endpoint = "https://openai.inference.de-txl.ionos.com/v1/embeddings"

header = {
    "Authorization": f"Bearer {IONOS_API_TOKEN}", 
    "Content-Type": "application/json"
}
body = {
    "model": MODEL_NAME,
    "input": INPUT
}
result = requests.post(endpoint, json=body, headers=header)


Generate Text with Your Prompt
To generate text, send a prompt to the chat/completions endpoint.

Python
Bash
Copy
# Python example for text generation
import requests

IONOS_API_TOKEN = "[YOUR API TOKEN HERE]"
MODEL_NAME = "[MODEL NAME HERE]"
PROMPT = [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Hello!"}
  ]

endpoint = "https://openai.inference.de-txl.ionos.com/v1/chat/completions"

header = {
    "Authorization": f"Bearer {IONOS_API_TOKEN}", 
    "Content-Type": "application/json"
}
body = {
    "model": MODEL_NAME,
    "messages": PROMPT,
}
requests.post(endpoint, json=body, headers=header).json()




Select a Language Model
The IONOS AI Model Hub offers a variety of Large Language Models to suit different needs. Choose the model that best fits your use case from the table below:

Foundation Model
Model Name
Purpose
Teuken v0.4 Instruct, 7B

openGPT-X/Teuken-7B-instruct-commercial

Ideal for conversational agents and virtual assistants in any of the 24 EU languages.

Llama 3.3 Instruct, 70B

meta-llama/Llama-3.3-70B-Instruct

Ideal for more complex conversational agents and virtual assistants.

Llama 3.1 Instruct, 8B

meta-llama/Meta-Llama-3.1-8B-Instruct

Suitable for general-purpose dialogue and language tasks.

Llama 3.1 Instruct, 70B

meta-llama/Meta-Llama-3.1-70B-Instruct

Ideal for more complex conversational agents and virtual assistants.

Llama 3.1 Instruct, 405B

meta-llama/Meta-Llama-3.1-405B-Instruct-FP8

Optimized for extensive dialogue tasks, supporting large context windows.

Mistral Instruct v0.3, 7B

mistralai/Mistral-7B-Instruct-v0.3

Designed for conversational agents, with enhanced European language support.

Mixtral, 8x7B

mistralai/Mixtral-8x7B-Instruct-v0.1

Supports multilingual interactions and is optimized for diverse contexts.

During setup, you’ll enter the model’s "Model Name" value into AnythingLLM’s configuration.

Step 3: Obtain the Base URL
For connecting to the IONOS AI Model Hub, use the following Base URL for the OpenAI-compatible API:

Base URL
Copy
    https://openai.inference.de-txl.ionos.com/v1


    key


    eyJ0eXAiOiJKV1QiLCJraWQiOiJhZGNjYmI3YS1jNmFiLTQyYTMtYTAwYi00ZjQ3MTcwZTIwODgiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJpb25vc2Nsb3VkIiwiaWF0IjoxNzQ0MjkyOTg0LCJjbGllbnQiOiJVU0VSIiwiaWRlbnRpdHkiOnsidXVpZCI6IjZiYjdjNDZmLTA0YjUtNGU2Ni05NjY2LTAxNGE0OTVlMmU4MyIsInJlc2VsbGVySWQiOjEsInJlZ0RvbWFpbiI6Imlvbm9zLmRlIiwicm9sZSI6Im93bmVyIiwiY29udHJhY3ROdW1iZXIiOjM0OTAxOTAyLCJpc1BhcmVudCI6ZmFsc2UsInByaXZpbGVnZXMiOlsiREFUQV9DRU5URVJfQ1JFQVRFIiwiU05BUFNIT1RfQ1JFQVRFIiwiSVBfQkxPQ0tfUkVTRVJWRSIsIk1BTkFHRV9EQVRBUExBVEZPUk0iLCJBQ0NFU1NfQUNUSVZJVFlfTE9HIiwiUENDX0NSRUFURSIsIkFDQ0VTU19TM19PQkpFQ1RfU1RPUkFHRSIsIkJBQ0tVUF9VTklUX0NSRUFURSIsIkNSRUFURV9JTlRFUk5FVF9BQ0NFU1MiLCJLOFNfQ0xVU1RFUl9DUkVBVEUiLCJGTE9XX0xPR19DUkVBVEUiLCJBQ0NFU1NfQU5EX01BTkFHRV9NT05JVE9SSU5HIiwiQUNDRVNTX0FORF9NQU5BR0VfQ0VSVElGSUNBVEVTIiwiQUNDRVNTX0FORF9NQU5BR0VfTE9HR0lORyIsIk1BTkFHRV9EQkFBUyIsIkFDQ0VTU19BTkRfTUFOQUdFX0ROUyIsIk1BTkFHRV9SRUdJU1RSWSIsIkFDQ0VTU19BTkRfTUFOQUdFX0NETiIsIkFDQ0VTU19BTkRfTUFOQUdFX1ZQTiIsIkFDQ0VTU19BTkRfTUFOQUdFX0FQSV9HQVRFV0FZIiwiQUNDRVNTX0FORF9NQU5BR0VfTkdTIiwiQUNDRVNTX0FORF9NQU5BR0VfS0FBUyIsIkFDQ0VTU19BTkRfTUFOQUdFX05FVFdPUktfRklMRV9TVE9SQUdFIiwiQUNDRVNTX0FORF9NQU5BR0VfQUlfTU9ERUxfSFVCIiwiQ1JFQVRFX05FVFdPUktfU0VDVVJJVFlfR1JPVVBTIiwiQUNDRVNTX0FORF9NQU5BR0VfSUFNX1JFU09VUkNFUyJdfSwiZXhwIjoxNzc1ODI4OTg0fQ.xSfzJPsxzzSwqS7Ahs9o5JzoSbOUSAXXpZpRFluCu7UNtYKow9Re2lpYiePVz_Zhn1qXt2349USHd-9VfvZxVrBuScnYvgcd-IzDz6kXZyUvwkTNE11CWV-pIIv7C8S_8_MZbkHdxqf9A_bchdDb-FeUuE1qczp0K9kK7nFNxHCH0WCa84KTEOtbqLKYDEQCab_YTAsvSCHVdMWrj1y6FpYrtyctk_5c13Ik7FjLATXzH_bAKJYuBInvePfPV4RkDdlyTFVMwvRPeFyHQbFeR6e-zQFHOLqAJV4-TMfvSw5JAGw7JX8NVlntoUUXhdgT8bDnYsA_535QSL-987Jtag