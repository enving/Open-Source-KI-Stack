/*
 Navicat Premium Data Transfer

 Source Server         : Tristan N8N
 Source Server Type    : PostgreSQL
 Source Server Version : 160009 (160009)
 Source Host           : localhost:5434
 Source Catalog        : n8n
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 160009 (160009)
 File Encoding         : 65001

 Date: 04/06/2025 16:22:40
*/


-- ----------------------------
-- Sequence structure for auth_provider_sync_history_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."auth_provider_sync_history_id_seq";
CREATE SEQUENCE "public"."auth_provider_sync_history_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for execution_annotations_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."execution_annotations_id_seq";
CREATE SEQUENCE "public"."execution_annotations_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for execution_entity_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."execution_entity_id_seq";
CREATE SEQUENCE "public"."execution_entity_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for execution_metadata_temp_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."execution_metadata_temp_id_seq";
CREATE SEQUENCE "public"."execution_metadata_temp_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for insights_by_period_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."insights_by_period_id_seq";
CREATE SEQUENCE "public"."insights_by_period_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for insights_metadata_metaId_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."insights_metadata_metaId_seq";
CREATE SEQUENCE "public"."insights_metadata_metaId_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for insights_raw_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."insights_raw_id_seq";
CREATE SEQUENCE "public"."insights_raw_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for migrations_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."migrations_id_seq";
CREATE SEQUENCE "public"."migrations_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for annotation_tag_entity
-- ----------------------------
DROP TABLE IF EXISTS "public"."annotation_tag_entity";
CREATE TABLE "public"."annotation_tag_entity" (
  "id" varchar(16) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(24) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of annotation_tag_entity
-- ----------------------------

-- ----------------------------
-- Table structure for auth_identity
-- ----------------------------
DROP TABLE IF EXISTS "public"."auth_identity";
CREATE TABLE "public"."auth_identity" (
  "userId" uuid,
  "providerId" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "providerType" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of auth_identity
-- ----------------------------

-- ----------------------------
-- Table structure for auth_provider_sync_history
-- ----------------------------
DROP TABLE IF EXISTS "public"."auth_provider_sync_history";
CREATE TABLE "public"."auth_provider_sync_history" (
  "id" int4 NOT NULL DEFAULT nextval('auth_provider_sync_history_id_seq'::regclass),
  "providerType" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "runMode" text COLLATE "pg_catalog"."default" NOT NULL,
  "status" text COLLATE "pg_catalog"."default" NOT NULL,
  "startedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "endedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "scanned" int4 NOT NULL,
  "created" int4 NOT NULL,
  "updated" int4 NOT NULL,
  "disabled" int4 NOT NULL,
  "error" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of auth_provider_sync_history
-- ----------------------------

-- ----------------------------
-- Table structure for credentials_entity
-- ----------------------------
DROP TABLE IF EXISTS "public"."credentials_entity";
CREATE TABLE "public"."credentials_entity" (
  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "data" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "isManaged" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Records of credentials_entity
-- ----------------------------

-- ----------------------------
-- Table structure for event_destinations
-- ----------------------------
DROP TABLE IF EXISTS "public"."event_destinations";
CREATE TABLE "public"."event_destinations" (
  "id" uuid NOT NULL,
  "destination" jsonb NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of event_destinations
-- ----------------------------

-- ----------------------------
-- Table structure for execution_annotation_tags
-- ----------------------------
DROP TABLE IF EXISTS "public"."execution_annotation_tags";
CREATE TABLE "public"."execution_annotation_tags" (
  "annotationId" int4 NOT NULL,
  "tagId" varchar(24) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of execution_annotation_tags
-- ----------------------------

-- ----------------------------
-- Table structure for execution_annotations
-- ----------------------------
DROP TABLE IF EXISTS "public"."execution_annotations";
CREATE TABLE "public"."execution_annotations" (
  "id" int4 NOT NULL DEFAULT nextval('execution_annotations_id_seq'::regclass),
  "executionId" int4 NOT NULL,
  "vote" varchar(6) COLLATE "pg_catalog"."default",
  "note" text COLLATE "pg_catalog"."default",
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of execution_annotations
-- ----------------------------

-- ----------------------------
-- Table structure for execution_data
-- ----------------------------
DROP TABLE IF EXISTS "public"."execution_data";
CREATE TABLE "public"."execution_data" (
  "executionId" int4 NOT NULL,
  "workflowData" json NOT NULL,
  "data" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of execution_data
-- ----------------------------

-- ----------------------------
-- Table structure for execution_entity
-- ----------------------------
DROP TABLE IF EXISTS "public"."execution_entity";
CREATE TABLE "public"."execution_entity" (
  "id" int4 NOT NULL DEFAULT nextval('execution_entity_id_seq'::regclass),
  "finished" bool NOT NULL,
  "mode" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "retryOf" varchar COLLATE "pg_catalog"."default",
  "retrySuccessId" varchar COLLATE "pg_catalog"."default",
  "startedAt" timestamptz(3),
  "stoppedAt" timestamptz(3),
  "waitTill" timestamptz(3),
  "status" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "deletedAt" timestamptz(3),
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of execution_entity
-- ----------------------------

-- ----------------------------
-- Table structure for execution_metadata
-- ----------------------------
DROP TABLE IF EXISTS "public"."execution_metadata";
CREATE TABLE "public"."execution_metadata" (
  "id" int4 NOT NULL DEFAULT nextval('execution_metadata_temp_id_seq'::regclass),
  "executionId" int4 NOT NULL,
  "key" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "value" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of execution_metadata
-- ----------------------------

-- ----------------------------
-- Table structure for folder
-- ----------------------------
DROP TABLE IF EXISTS "public"."folder";
CREATE TABLE "public"."folder" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "parentFolderId" varchar(36) COLLATE "pg_catalog"."default",
  "projectId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of folder
-- ----------------------------

-- ----------------------------
-- Table structure for folder_tag
-- ----------------------------
DROP TABLE IF EXISTS "public"."folder_tag";
CREATE TABLE "public"."folder_tag" (
  "folderId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "tagId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of folder_tag
-- ----------------------------

-- ----------------------------
-- Table structure for insights_by_period
-- ----------------------------
DROP TABLE IF EXISTS "public"."insights_by_period";
CREATE TABLE "public"."insights_by_period" (
  "id" int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "metaId" int4 NOT NULL,
  "type" int4 NOT NULL,
  "value" int4 NOT NULL,
  "periodUnit" int4 NOT NULL,
  "periodStart" timestamptz(0) DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "public"."insights_by_period"."type" IS '0: time_saved_minutes, 1: runtime_milliseconds, 2: success, 3: failure';
COMMENT ON COLUMN "public"."insights_by_period"."periodUnit" IS '0: hour, 1: day, 2: week';

-- ----------------------------
-- Records of insights_by_period
-- ----------------------------

-- ----------------------------
-- Table structure for insights_metadata
-- ----------------------------
DROP TABLE IF EXISTS "public"."insights_metadata";
CREATE TABLE "public"."insights_metadata" (
  "metaId" int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "workflowId" varchar(16) COLLATE "pg_catalog"."default",
  "projectId" varchar(36) COLLATE "pg_catalog"."default",
  "workflowName" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "projectName" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of insights_metadata
-- ----------------------------

-- ----------------------------
-- Table structure for insights_raw
-- ----------------------------
DROP TABLE IF EXISTS "public"."insights_raw";
CREATE TABLE "public"."insights_raw" (
  "id" int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "metaId" int4 NOT NULL,
  "type" int4 NOT NULL,
  "value" int4 NOT NULL,
  "timestamp" timestamptz(0) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "public"."insights_raw"."type" IS '0: time_saved_minutes, 1: runtime_milliseconds, 2: success, 3: failure';

-- ----------------------------
-- Records of insights_raw
-- ----------------------------

-- ----------------------------
-- Table structure for installed_nodes
-- ----------------------------
DROP TABLE IF EXISTS "public"."installed_nodes";
CREATE TABLE "public"."installed_nodes" (
  "name" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "latestVersion" int4 NOT NULL DEFAULT 1,
  "package" varchar(241) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of installed_nodes
-- ----------------------------

-- ----------------------------
-- Table structure for installed_packages
-- ----------------------------
DROP TABLE IF EXISTS "public"."installed_packages";
CREATE TABLE "public"."installed_packages" (
  "packageName" varchar(214) COLLATE "pg_catalog"."default" NOT NULL,
  "installedVersion" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "authorName" varchar(70) COLLATE "pg_catalog"."default",
  "authorEmail" varchar(70) COLLATE "pg_catalog"."default",
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of installed_packages
-- ----------------------------

-- ----------------------------
-- Table structure for invalid_auth_token
-- ----------------------------
DROP TABLE IF EXISTS "public"."invalid_auth_token";
CREATE TABLE "public"."invalid_auth_token" (
  "token" varchar(512) COLLATE "pg_catalog"."default" NOT NULL,
  "expiresAt" timestamptz(3) NOT NULL
)
;

-- ----------------------------
-- Records of invalid_auth_token
-- ----------------------------

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS "public"."migrations";
CREATE TABLE "public"."migrations" (
  "id" int4 NOT NULL DEFAULT nextval('migrations_id_seq'::regclass),
  "timestamp" int8 NOT NULL,
  "name" varchar COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of migrations
-- ----------------------------
INSERT INTO "public"."migrations" VALUES (1, 1587669153312, 'InitialMigration1587669153312');
INSERT INTO "public"."migrations" VALUES (2, 1589476000887, 'WebhookModel1589476000887');
INSERT INTO "public"."migrations" VALUES (3, 1594828256133, 'CreateIndexStoppedAt1594828256133');
INSERT INTO "public"."migrations" VALUES (4, 1607431743768, 'MakeStoppedAtNullable1607431743768');
INSERT INTO "public"."migrations" VALUES (5, 1611144599516, 'AddWebhookId1611144599516');
INSERT INTO "public"."migrations" VALUES (6, 1617270242566, 'CreateTagEntity1617270242566');
INSERT INTO "public"."migrations" VALUES (7, 1620824779533, 'UniqueWorkflowNames1620824779533');
INSERT INTO "public"."migrations" VALUES (8, 1626176912946, 'AddwaitTill1626176912946');
INSERT INTO "public"."migrations" VALUES (9, 1630419189837, 'UpdateWorkflowCredentials1630419189837');
INSERT INTO "public"."migrations" VALUES (10, 1644422880309, 'AddExecutionEntityIndexes1644422880309');
INSERT INTO "public"."migrations" VALUES (11, 1646834195327, 'IncreaseTypeVarcharLimit1646834195327');
INSERT INTO "public"."migrations" VALUES (12, 1646992772331, 'CreateUserManagement1646992772331');
INSERT INTO "public"."migrations" VALUES (13, 1648740597343, 'LowerCaseUserEmail1648740597343');
INSERT INTO "public"."migrations" VALUES (14, 1652254514002, 'CommunityNodes1652254514002');
INSERT INTO "public"."migrations" VALUES (15, 1652367743993, 'AddUserSettings1652367743993');
INSERT INTO "public"."migrations" VALUES (16, 1652905585850, 'AddAPIKeyColumn1652905585850');
INSERT INTO "public"."migrations" VALUES (17, 1654090467022, 'IntroducePinData1654090467022');
INSERT INTO "public"."migrations" VALUES (18, 1658932090381, 'AddNodeIds1658932090381');
INSERT INTO "public"."migrations" VALUES (19, 1659902242948, 'AddJsonKeyPinData1659902242948');
INSERT INTO "public"."migrations" VALUES (20, 1660062385367, 'CreateCredentialsUserRole1660062385367');
INSERT INTO "public"."migrations" VALUES (21, 1663755770893, 'CreateWorkflowsEditorRole1663755770893');
INSERT INTO "public"."migrations" VALUES (22, 1664196174001, 'WorkflowStatistics1664196174001');
INSERT INTO "public"."migrations" VALUES (23, 1665484192212, 'CreateCredentialUsageTable1665484192212');
INSERT INTO "public"."migrations" VALUES (24, 1665754637025, 'RemoveCredentialUsageTable1665754637025');
INSERT INTO "public"."migrations" VALUES (25, 1669739707126, 'AddWorkflowVersionIdColumn1669739707126');
INSERT INTO "public"."migrations" VALUES (26, 1669823906995, 'AddTriggerCountColumn1669823906995');
INSERT INTO "public"."migrations" VALUES (27, 1671535397530, 'MessageEventBusDestinations1671535397530');
INSERT INTO "public"."migrations" VALUES (28, 1671726148421, 'RemoveWorkflowDataLoadedFlag1671726148421');
INSERT INTO "public"."migrations" VALUES (29, 1673268682475, 'DeleteExecutionsWithWorkflows1673268682475');
INSERT INTO "public"."migrations" VALUES (30, 1674138566000, 'AddStatusToExecutions1674138566000');
INSERT INTO "public"."migrations" VALUES (31, 1674509946020, 'CreateLdapEntities1674509946020');
INSERT INTO "public"."migrations" VALUES (32, 1675940580449, 'PurgeInvalidWorkflowConnections1675940580449');
INSERT INTO "public"."migrations" VALUES (33, 1676996103000, 'MigrateExecutionStatus1676996103000');
INSERT INTO "public"."migrations" VALUES (34, 1677236854063, 'UpdateRunningExecutionStatus1677236854063');
INSERT INTO "public"."migrations" VALUES (35, 1677501636754, 'CreateVariables1677501636754');
INSERT INTO "public"."migrations" VALUES (36, 1679416281778, 'CreateExecutionMetadataTable1679416281778');
INSERT INTO "public"."migrations" VALUES (37, 1681134145996, 'AddUserActivatedProperty1681134145996');
INSERT INTO "public"."migrations" VALUES (38, 1681134145997, 'RemoveSkipOwnerSetup1681134145997');
INSERT INTO "public"."migrations" VALUES (39, 1690000000000, 'MigrateIntegerKeysToString1690000000000');
INSERT INTO "public"."migrations" VALUES (40, 1690000000020, 'SeparateExecutionData1690000000020');
INSERT INTO "public"."migrations" VALUES (41, 1690000000030, 'RemoveResetPasswordColumns1690000000030');
INSERT INTO "public"."migrations" VALUES (42, 1690000000030, 'AddMfaColumns1690000000030');
INSERT INTO "public"."migrations" VALUES (43, 1690787606731, 'AddMissingPrimaryKeyOnExecutionData1690787606731');
INSERT INTO "public"."migrations" VALUES (44, 1691088862123, 'CreateWorkflowNameIndex1691088862123');
INSERT INTO "public"."migrations" VALUES (45, 1692967111175, 'CreateWorkflowHistoryTable1692967111175');
INSERT INTO "public"."migrations" VALUES (46, 1693491613982, 'ExecutionSoftDelete1693491613982');
INSERT INTO "public"."migrations" VALUES (47, 1693554410387, 'DisallowOrphanExecutions1693554410387');
INSERT INTO "public"."migrations" VALUES (48, 1694091729095, 'MigrateToTimestampTz1694091729095');
INSERT INTO "public"."migrations" VALUES (49, 1695128658538, 'AddWorkflowMetadata1695128658538');
INSERT INTO "public"."migrations" VALUES (50, 1695829275184, 'ModifyWorkflowHistoryNodesAndConnections1695829275184');
INSERT INTO "public"."migrations" VALUES (51, 1700571993961, 'AddGlobalAdminRole1700571993961');
INSERT INTO "public"."migrations" VALUES (52, 1705429061930, 'DropRoleMapping1705429061930');
INSERT INTO "public"."migrations" VALUES (53, 1711018413374, 'RemoveFailedExecutionStatus1711018413374');
INSERT INTO "public"."migrations" VALUES (54, 1711390882123, 'MoveSshKeysToDatabase1711390882123');
INSERT INTO "public"."migrations" VALUES (55, 1712044305787, 'RemoveNodesAccess1712044305787');
INSERT INTO "public"."migrations" VALUES (56, 1714133768519, 'CreateProject1714133768519');
INSERT INTO "public"."migrations" VALUES (57, 1714133768521, 'MakeExecutionStatusNonNullable1714133768521');
INSERT INTO "public"."migrations" VALUES (58, 1717498465931, 'AddActivatedAtUserSetting1717498465931');
INSERT INTO "public"."migrations" VALUES (59, 1720101653148, 'AddConstraintToExecutionMetadata1720101653148');
INSERT INTO "public"."migrations" VALUES (60, 1721377157740, 'FixExecutionMetadataSequence1721377157740');
INSERT INTO "public"."migrations" VALUES (61, 1723627610222, 'CreateInvalidAuthTokenTable1723627610222');
INSERT INTO "public"."migrations" VALUES (62, 1723796243146, 'RefactorExecutionIndices1723796243146');
INSERT INTO "public"."migrations" VALUES (63, 1724753530828, 'CreateAnnotationTables1724753530828');
INSERT INTO "public"."migrations" VALUES (64, 1724951148974, 'AddApiKeysTable1724951148974');
INSERT INTO "public"."migrations" VALUES (65, 1726606152711, 'CreateProcessedDataTable1726606152711');
INSERT INTO "public"."migrations" VALUES (66, 1727427440136, 'SeparateExecutionCreationFromStart1727427440136');
INSERT INTO "public"."migrations" VALUES (67, 1728659839644, 'AddMissingPrimaryKeyOnAnnotationTagMapping1728659839644');
INSERT INTO "public"."migrations" VALUES (68, 1729607673464, 'UpdateProcessedDataValueColumnToText1729607673464');
INSERT INTO "public"."migrations" VALUES (69, 1729607673469, 'AddProjectIcons1729607673469');
INSERT INTO "public"."migrations" VALUES (70, 1730386903556, 'CreateTestDefinitionTable1730386903556');
INSERT INTO "public"."migrations" VALUES (71, 1731404028106, 'AddDescriptionToTestDefinition1731404028106');
INSERT INTO "public"."migrations" VALUES (72, 1731582748663, 'MigrateTestDefinitionKeyToString1731582748663');
INSERT INTO "public"."migrations" VALUES (73, 1732271325258, 'CreateTestMetricTable1732271325258');
INSERT INTO "public"."migrations" VALUES (74, 1732549866705, 'CreateTestRun1732549866705');
INSERT INTO "public"."migrations" VALUES (75, 1733133775640, 'AddMockedNodesColumnToTestDefinition1733133775640');
INSERT INTO "public"."migrations" VALUES (76, 1734479635324, 'AddManagedColumnToCredentialsTable1734479635324');
INSERT INTO "public"."migrations" VALUES (77, 1736172058779, 'AddStatsColumnsToTestRun1736172058779');
INSERT INTO "public"."migrations" VALUES (78, 1736947513045, 'CreateTestCaseExecutionTable1736947513045');
INSERT INTO "public"."migrations" VALUES (79, 1737715421462, 'AddErrorColumnsToTestRuns1737715421462');
INSERT INTO "public"."migrations" VALUES (80, 1738709609940, 'CreateFolderTable1738709609940');
INSERT INTO "public"."migrations" VALUES (81, 1739549398681, 'CreateAnalyticsTables1739549398681');
INSERT INTO "public"."migrations" VALUES (82, 1740445074052, 'UpdateParentFolderIdColumn1740445074052');
INSERT INTO "public"."migrations" VALUES (83, 1741167584277, 'RenameAnalyticsToInsights1741167584277');
INSERT INTO "public"."migrations" VALUES (84, 1742918400000, 'AddScopesColumnToApiKeys1742918400000');
INSERT INTO "public"."migrations" VALUES (85, 1745587087521, 'AddWorkflowStatisticsRootCount1745587087521');
INSERT INTO "public"."migrations" VALUES (86, 1745934666076, 'AddWorkflowArchivedColumn1745934666076');
INSERT INTO "public"."migrations" VALUES (87, 1745934666077, 'DropRoleTable1745934666077');

-- ----------------------------
-- Table structure for processed_data
-- ----------------------------
DROP TABLE IF EXISTS "public"."processed_data";
CREATE TABLE "public"."processed_data" (
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "context" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "value" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of processed_data
-- ----------------------------

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS "public"."project";
CREATE TABLE "public"."project" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "icon" json
)
;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO "public"."project" VALUES ('default-project-id', 'Admin User <admin@admin.com>', 'personal', '2025-06-04 14:41:01.34+00', '2025-06-04 14:43:24.06+00', NULL);

-- ----------------------------
-- Table structure for project_relation
-- ----------------------------
DROP TABLE IF EXISTS "public"."project_relation";
CREATE TABLE "public"."project_relation" (
  "projectId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "userId" uuid NOT NULL,
  "role" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of project_relation
-- ----------------------------
INSERT INTO "public"."project_relation" VALUES ('default-project-id', '7646a017-9598-4259-8690-b38bd26f9491', 'project:personalOwner', '2025-06-04 14:41:01.34+00', '2025-06-04 14:41:01.34+00');

-- ----------------------------
-- Table structure for settings
-- ----------------------------
DROP TABLE IF EXISTS "public"."settings";
CREATE TABLE "public"."settings" (
  "key" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "value" text COLLATE "pg_catalog"."default" NOT NULL,
  "loadOnStartup" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Records of settings
-- ----------------------------
INSERT INTO "public"."settings" VALUES ('ui.banners.dismissed', '["V1"]', 't');
INSERT INTO "public"."settings" VALUES ('features.ldap', '{"loginEnabled":false,"loginLabel":"","connectionUrl":"","allowUnauthorizedCerts":false,"connectionSecurity":"none","connectionPort":389,"baseDn":"","bindingAdminDn":"","bindingAdminPassword":"","firstNameAttribute":"","lastNameAttribute":"","emailAttribute":"","loginIdAttribute":"","ldapIdAttribute":"","userFilter":"","synchronizationEnabled":false,"synchronizationInterval":60,"searchPageSize":0,"searchTimeout":60}', 't');
INSERT INTO "public"."settings" VALUES ('features.sourceControl.sshKeys', '{"encryptedPrivateKey":"U2FsdGVkX1+bJgvWHSyoaRBFohKA+uz8BtrVwQwzBJotvz9Q5/IdP/+Lw/Sg+70t7wLAIqNQYOFiSjbvn3x38hND1I8QgSe6dM3inOR+uNPC8Ep8/xtX+TK5buiipIhPIGqOmjbotFUo8txMM89c4Bf735dvFM7ii1GX+Rb2syTZxep91LBTgn/fncIbfUVcQD0AqDOd02yugt9eooBmWZ8ZJbmZdOAYsi9ZPgFLast9Oku9eUyLqpud8BGfE1devMJ0q9Zzv7p/x2KxnR2WdcrXrVwgX4G1UDjty033GA0c9daWv9CA4Q3K4/MNbLivnT78BpgN/TQ9We/+NyJwDkaXukbPSNtYH8SP2W5/MCoEgsS3eTPiUFOrXXcu5K+oYyWpXZ6LIILFZQuetuDoY5YDOMe3cWHc9rPo4vW4tg/oDI9tNBBhvaZgccnswR1DkZbk46hViTLqXfdcUfKhJcrmBQzbINNqqIKKAQs5QJbN0oaJxPtk46/Fhne4B0m6Y/S+IOGgMSdGR1a6S8MzPGLI+jhVE1diL5KceUxdk+ExCu4ExyEdX1mRsMKPGV5d","publicKey":"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDpm2MkE/prjy+gKWBaVUmuxq4VsdzUw4ciB+IHKsAUH n8n deploy key"}', 't');
INSERT INTO "public"."settings" VALUES ('features.sourceControl', '{"branchName":"main","keyGeneratorType":"ed25519"}', 't');
INSERT INTO "public"."settings" VALUES ('userManagement.isInstanceOwnerSetUp', 'true', 't');

-- ----------------------------
-- Table structure for shared_credentials
-- ----------------------------
DROP TABLE IF EXISTS "public"."shared_credentials";
CREATE TABLE "public"."shared_credentials" (
  "credentialsId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "projectId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "role" text COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of shared_credentials
-- ----------------------------

-- ----------------------------
-- Table structure for shared_workflow
-- ----------------------------
DROP TABLE IF EXISTS "public"."shared_workflow";
CREATE TABLE "public"."shared_workflow" (
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "projectId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "role" text COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of shared_workflow
-- ----------------------------

-- ----------------------------
-- Table structure for tag_entity
-- ----------------------------
DROP TABLE IF EXISTS "public"."tag_entity";
CREATE TABLE "public"."tag_entity" (
  "name" varchar(24) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of tag_entity
-- ----------------------------

-- ----------------------------
-- Table structure for test_case_execution
-- ----------------------------
DROP TABLE IF EXISTS "public"."test_case_execution";
CREATE TABLE "public"."test_case_execution" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "testRunId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "pastExecutionId" int4,
  "executionId" int4,
  "evaluationExecutionId" int4,
  "status" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "runAt" timestamptz(3),
  "completedAt" timestamptz(3),
  "errorCode" varchar COLLATE "pg_catalog"."default",
  "errorDetails" json,
  "metrics" json,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of test_case_execution
-- ----------------------------

-- ----------------------------
-- Table structure for test_definition
-- ----------------------------
DROP TABLE IF EXISTS "public"."test_definition";
CREATE TABLE "public"."test_definition" (
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "evaluationWorkflowId" varchar(36) COLLATE "pg_catalog"."default",
  "annotationTagId" varchar(16) COLLATE "pg_catalog"."default",
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "description" text COLLATE "pg_catalog"."default",
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "mockedNodes" json NOT NULL DEFAULT '[]'::json
)
;

-- ----------------------------
-- Records of test_definition
-- ----------------------------

-- ----------------------------
-- Table structure for test_metric
-- ----------------------------
DROP TABLE IF EXISTS "public"."test_metric";
CREATE TABLE "public"."test_metric" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "testDefinitionId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
)
;

-- ----------------------------
-- Records of test_metric
-- ----------------------------

-- ----------------------------
-- Table structure for test_run
-- ----------------------------
DROP TABLE IF EXISTS "public"."test_run";
CREATE TABLE "public"."test_run" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "testDefinitionId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "runAt" timestamptz(3),
  "completedAt" timestamptz(3),
  "metrics" json,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "totalCases" int4,
  "passedCases" int4,
  "failedCases" int4,
  "errorCode" varchar(255) COLLATE "pg_catalog"."default",
  "errorDetails" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of test_run
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS "public"."user";
CREATE TABLE "public"."user" (
  "id" uuid NOT NULL DEFAULT uuid_in((OVERLAY(OVERLAY(md5((((random())::text || ':'::text) || (clock_timestamp())::text)) PLACING '4'::text FROM 13) PLACING to_hex((floor(((random() * (((11 - 8) + 1))::double precision) + (8)::double precision)))::integer) FROM 17))::cstring),
  "email" varchar(255) COLLATE "pg_catalog"."default",
  "firstName" varchar(32) COLLATE "pg_catalog"."default",
  "lastName" varchar(32) COLLATE "pg_catalog"."default",
  "password" varchar(255) COLLATE "pg_catalog"."default",
  "personalizationAnswers" json,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "settings" json,
  "disabled" bool NOT NULL DEFAULT false,
  "mfaEnabled" bool NOT NULL DEFAULT false,
  "mfaSecret" text COLLATE "pg_catalog"."default",
  "mfaRecoveryCodes" text COLLATE "pg_catalog"."default",
  "role" text COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO "public"."user" VALUES ('7646a017-9598-4259-8690-b38bd26f9491', 'admin@admin.com', 'Admin', 'User', '$2a$10$NYl.Acl3b0fdjHtHw4sz3OUpaAQTgDQhz/WP0SZ.4qsWV0Gmt/EF.', '{"version":"v4","personalization_survey_submitted_at":"2025-06-04T14:43:38.271Z","personalization_survey_n8n_version":"1.93.0","companyType":"personal","reportedSource":"friend"}', '2025-06-04 14:40:59.854+00', '2025-06-04 14:43:38.286+00', '{"userActivated": true}', 'f', 'f', NULL, NULL, 'global:owner');

-- ----------------------------
-- Table structure for user_api_keys
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_api_keys";
CREATE TABLE "public"."user_api_keys" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "userId" uuid NOT NULL,
  "label" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "apiKey" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "scopes" json
)
;

-- ----------------------------
-- Records of user_api_keys
-- ----------------------------

-- ----------------------------
-- Table structure for variables
-- ----------------------------
DROP TABLE IF EXISTS "public"."variables";
CREATE TABLE "public"."variables" (
  "key" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'string'::character varying,
  "value" varchar(255) COLLATE "pg_catalog"."default",
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of variables
-- ----------------------------

-- ----------------------------
-- Table structure for webhook_entity
-- ----------------------------
DROP TABLE IF EXISTS "public"."webhook_entity";
CREATE TABLE "public"."webhook_entity" (
  "webhookPath" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "method" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "node" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "webhookId" varchar COLLATE "pg_catalog"."default",
  "pathLength" int4,
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of webhook_entity
-- ----------------------------

-- ----------------------------
-- Table structure for workflow_entity
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_entity";
CREATE TABLE "public"."workflow_entity" (
  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "active" bool NOT NULL,
  "nodes" json NOT NULL,
  "connections" json NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "settings" json,
  "staticData" json,
  "pinData" json,
  "versionId" char(36) COLLATE "pg_catalog"."default",
  "triggerCount" int4 NOT NULL DEFAULT 0,
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "meta" json,
  "parentFolderId" varchar(36) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "isArchived" bool NOT NULL DEFAULT false
)
;

-- ----------------------------
-- Records of workflow_entity
-- ----------------------------

-- ----------------------------
-- Table structure for workflow_history
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_history";
CREATE TABLE "public"."workflow_history" (
  "versionId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "authors" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createdAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "updatedAt" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  "nodes" json NOT NULL,
  "connections" json NOT NULL
)
;

-- ----------------------------
-- Records of workflow_history
-- ----------------------------

-- ----------------------------
-- Table structure for workflow_statistics
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflow_statistics";
CREATE TABLE "public"."workflow_statistics" (
  "count" int4 DEFAULT 0,
  "latestEvent" timestamptz(3),
  "name" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "rootCount" int4 DEFAULT 0
)
;

-- ----------------------------
-- Records of workflow_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for workflows_tags
-- ----------------------------
DROP TABLE IF EXISTS "public"."workflows_tags";
CREATE TABLE "public"."workflows_tags" (
  "workflowId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "tagId" varchar(36) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of workflows_tags
-- ----------------------------

-- ----------------------------
-- Function structure for uuid_generate_v1
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v1mc
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1mc"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v3
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v3"("namespace" uuid, "name" text);
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v4"();
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_generate_v5
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v5"("namespace" uuid, "name" text);
CREATE OR REPLACE FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_nil
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_nil"();
CREATE OR REPLACE FUNCTION "public"."uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_dns
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_dns"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_oid"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_url
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_url"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for uuid_ns_x500
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_x500"();
CREATE OR REPLACE FUNCTION "public"."uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."auth_provider_sync_history_id_seq"
OWNED BY "public"."auth_provider_sync_history"."id";
SELECT setval('"public"."auth_provider_sync_history_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."execution_annotations_id_seq"
OWNED BY "public"."execution_annotations"."id";
SELECT setval('"public"."execution_annotations_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."execution_entity_id_seq"
OWNED BY "public"."execution_entity"."id";
SELECT setval('"public"."execution_entity_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."execution_metadata_temp_id_seq"
OWNED BY "public"."execution_metadata"."id";
SELECT setval('"public"."execution_metadata_temp_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."insights_by_period_id_seq"
OWNED BY "public"."insights_by_period"."id";
SELECT setval('"public"."insights_by_period_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."insights_metadata_metaId_seq"
OWNED BY "public"."insights_metadata"."metaId";
SELECT setval('"public"."insights_metadata_metaId_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."insights_raw_id_seq"
OWNED BY "public"."insights_raw"."id";
SELECT setval('"public"."insights_raw_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."migrations_id_seq"
OWNED BY "public"."migrations"."id";
SELECT setval('"public"."migrations_id_seq"', 87, true);

-- ----------------------------
-- Indexes structure for table annotation_tag_entity
-- ----------------------------
CREATE UNIQUE INDEX "IDX_ae51b54c4bb430cf92f48b623f" ON "public"."annotation_tag_entity" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table annotation_tag_entity
-- ----------------------------
ALTER TABLE "public"."annotation_tag_entity" ADD CONSTRAINT "PK_69dfa041592c30bbc0d4b84aa00" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table auth_identity
-- ----------------------------
ALTER TABLE "public"."auth_identity" ADD CONSTRAINT "auth_identity_pkey" PRIMARY KEY ("providerId", "providerType");

-- ----------------------------
-- Primary Key structure for table auth_provider_sync_history
-- ----------------------------
ALTER TABLE "public"."auth_provider_sync_history" ADD CONSTRAINT "auth_provider_sync_history_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table credentials_entity
-- ----------------------------
CREATE INDEX "idx_07fde106c0b471d8cc80a64fc8" ON "public"."credentials_entity" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "pk_credentials_entity_id" ON "public"."credentials_entity" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table credentials_entity
-- ----------------------------
ALTER TABLE "public"."credentials_entity" ADD CONSTRAINT "credentials_entity_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table event_destinations
-- ----------------------------
ALTER TABLE "public"."event_destinations" ADD CONSTRAINT "event_destinations_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table execution_annotation_tags
-- ----------------------------
CREATE INDEX "IDX_a3697779b366e131b2bbdae297" ON "public"."execution_annotation_tags" USING btree (
  "tagId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_c1519757391996eb06064f0e7c" ON "public"."execution_annotation_tags" USING btree (
  "annotationId" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table execution_annotation_tags
-- ----------------------------
ALTER TABLE "public"."execution_annotation_tags" ADD CONSTRAINT "PK_979ec03d31294cca484be65d11f" PRIMARY KEY ("annotationId", "tagId");

-- ----------------------------
-- Indexes structure for table execution_annotations
-- ----------------------------
CREATE UNIQUE INDEX "IDX_97f863fa83c4786f1956508496" ON "public"."execution_annotations" USING btree (
  "executionId" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table execution_annotations
-- ----------------------------
ALTER TABLE "public"."execution_annotations" ADD CONSTRAINT "PK_7afcf93ffa20c4252869a7c6a23" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table execution_data
-- ----------------------------
ALTER TABLE "public"."execution_data" ADD CONSTRAINT "execution_data_pkey" PRIMARY KEY ("executionId");

-- ----------------------------
-- Indexes structure for table execution_entity
-- ----------------------------
CREATE INDEX "IDX_execution_entity_deletedAt" ON "public"."execution_entity" USING btree (
  "deletedAt" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);
CREATE INDEX "idx_execution_entity_stopped_at_status_deleted_at" ON "public"."execution_entity" USING btree (
  "stoppedAt" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "deletedAt" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
) WHERE "stoppedAt" IS NOT NULL AND "deletedAt" IS NULL;
CREATE INDEX "idx_execution_entity_wait_till_status_deleted_at" ON "public"."execution_entity" USING btree (
  "waitTill" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "deletedAt" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
) WHERE "waitTill" IS NOT NULL AND "deletedAt" IS NULL;
CREATE INDEX "idx_execution_entity_workflow_id_started_at" ON "public"."execution_entity" USING btree (
  "workflowId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "startedAt" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
) WHERE "startedAt" IS NOT NULL AND "deletedAt" IS NULL;

-- ----------------------------
-- Primary Key structure for table execution_entity
-- ----------------------------
ALTER TABLE "public"."execution_entity" ADD CONSTRAINT "pk_e3e63bbf986767844bbe1166d4e" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table execution_metadata
-- ----------------------------
CREATE UNIQUE INDEX "IDX_cec8eea3bf49551482ccb4933e" ON "public"."execution_metadata" USING btree (
  "executionId" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table execution_metadata
-- ----------------------------
ALTER TABLE "public"."execution_metadata" ADD CONSTRAINT "PK_17a0b6284f8d626aae88e1c16e4" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table folder
-- ----------------------------
CREATE UNIQUE INDEX "IDX_14f68deffaf858465715995508" ON "public"."folder" USING btree (
  "projectId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table folder
-- ----------------------------
ALTER TABLE "public"."folder" ADD CONSTRAINT "PK_6278a41a706740c94c02e288df8" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table folder_tag
-- ----------------------------
ALTER TABLE "public"."folder_tag" ADD CONSTRAINT "PK_27e4e00852f6b06a925a4d83a3e" PRIMARY KEY ("folderId", "tagId");

-- ----------------------------
-- Auto increment value for insights_by_period
-- ----------------------------
SELECT setval('"public"."insights_by_period_id_seq"', 1, false);

-- ----------------------------
-- Indexes structure for table insights_by_period
-- ----------------------------
CREATE UNIQUE INDEX "IDX_60b6a84299eeb3f671dfec7693" ON "public"."insights_by_period" USING btree (
  "periodStart" "pg_catalog"."timestamptz_ops" ASC NULLS LAST,
  "type" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "periodUnit" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "metaId" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table insights_by_period
-- ----------------------------
ALTER TABLE "public"."insights_by_period" ADD CONSTRAINT "PK_b606942249b90cc39b0265f0575" PRIMARY KEY ("id");

-- ----------------------------
-- Auto increment value for insights_metadata
-- ----------------------------
SELECT setval('"public"."insights_metadata_metaId_seq"', 1, false);

-- ----------------------------
-- Indexes structure for table insights_metadata
-- ----------------------------
CREATE UNIQUE INDEX "IDX_1d8ab99d5861c9388d2dc1cf73" ON "public"."insights_metadata" USING btree (
  "workflowId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table insights_metadata
-- ----------------------------
ALTER TABLE "public"."insights_metadata" ADD CONSTRAINT "PK_f448a94c35218b6208ce20cf5a1" PRIMARY KEY ("metaId");

-- ----------------------------
-- Auto increment value for insights_raw
-- ----------------------------
SELECT setval('"public"."insights_raw_id_seq"', 1, false);

-- ----------------------------
-- Primary Key structure for table insights_raw
-- ----------------------------
ALTER TABLE "public"."insights_raw" ADD CONSTRAINT "PK_ec15125755151e3a7e00e00014f" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table installed_nodes
-- ----------------------------
ALTER TABLE "public"."installed_nodes" ADD CONSTRAINT "PK_8ebd28194e4f792f96b5933423fc439df97d9689" PRIMARY KEY ("name");

-- ----------------------------
-- Primary Key structure for table installed_packages
-- ----------------------------
ALTER TABLE "public"."installed_packages" ADD CONSTRAINT "PK_08cc9197c39b028c1e9beca225940576fd1a5804" PRIMARY KEY ("packageName");

-- ----------------------------
-- Primary Key structure for table invalid_auth_token
-- ----------------------------
ALTER TABLE "public"."invalid_auth_token" ADD CONSTRAINT "PK_5779069b7235b256d91f7af1a15" PRIMARY KEY ("token");

-- ----------------------------
-- Primary Key structure for table migrations
-- ----------------------------
ALTER TABLE "public"."migrations" ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table processed_data
-- ----------------------------
ALTER TABLE "public"."processed_data" ADD CONSTRAINT "PK_ca04b9d8dc72de268fe07a65773" PRIMARY KEY ("workflowId", "context");

-- ----------------------------
-- Primary Key structure for table project
-- ----------------------------
ALTER TABLE "public"."project" ADD CONSTRAINT "PK_4d68b1358bb5b766d3e78f32f57" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table project_relation
-- ----------------------------
CREATE INDEX "IDX_5f0643f6717905a05164090dde" ON "public"."project_relation" USING btree (
  "userId" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_61448d56d61802b5dfde5cdb00" ON "public"."project_relation" USING btree (
  "projectId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table project_relation
-- ----------------------------
ALTER TABLE "public"."project_relation" ADD CONSTRAINT "PK_1caaa312a5d7184a003be0f0cb6" PRIMARY KEY ("projectId", "userId");

-- ----------------------------
-- Primary Key structure for table settings
-- ----------------------------
ALTER TABLE "public"."settings" ADD CONSTRAINT "PK_dc0fe14e6d9943f268e7b119f69ab8bd" PRIMARY KEY ("key");

-- ----------------------------
-- Primary Key structure for table shared_credentials
-- ----------------------------
ALTER TABLE "public"."shared_credentials" ADD CONSTRAINT "PK_8ef3a59796a228913f251779cff" PRIMARY KEY ("credentialsId", "projectId");

-- ----------------------------
-- Primary Key structure for table shared_workflow
-- ----------------------------
ALTER TABLE "public"."shared_workflow" ADD CONSTRAINT "PK_5ba87620386b847201c9531c58f" PRIMARY KEY ("workflowId", "projectId");

-- ----------------------------
-- Indexes structure for table tag_entity
-- ----------------------------
CREATE UNIQUE INDEX "idx_812eb05f7451ca757fb98444ce" ON "public"."tag_entity" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "pk_tag_entity_id" ON "public"."tag_entity" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table tag_entity
-- ----------------------------
ALTER TABLE "public"."tag_entity" ADD CONSTRAINT "tag_entity_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table test_case_execution
-- ----------------------------
CREATE INDEX "IDX_8e4b4774db42f1e6dda3452b2a" ON "public"."test_case_execution" USING btree (
  "testRunId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table test_case_execution
-- ----------------------------
ALTER TABLE "public"."test_case_execution" ADD CONSTRAINT "PK_90c121f77a78a6580e94b794bce" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table test_definition
-- ----------------------------
CREATE INDEX "IDX_9ec1ce6fbf82305f489adb971d" ON "public"."test_definition" USING btree (
  "evaluationWorkflowId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_b0dd0087fe3da02b0ffa4b9c5b" ON "public"."test_definition" USING btree (
  "workflowId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "pk_test_definition_id" ON "public"."test_definition" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table test_definition
-- ----------------------------
ALTER TABLE "public"."test_definition" ADD CONSTRAINT "test_definition_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table test_metric
-- ----------------------------
CREATE INDEX "IDX_3a4e9cf37111ac3270e2469b47" ON "public"."test_metric" USING btree (
  "testDefinitionId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table test_metric
-- ----------------------------
ALTER TABLE "public"."test_metric" ADD CONSTRAINT "PK_3e98b8e20acc19c5030a8644142" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table test_run
-- ----------------------------
CREATE INDEX "IDX_3a81713a76f2295b12b46cdfca" ON "public"."test_run" USING btree (
  "testDefinitionId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table test_run
-- ----------------------------
ALTER TABLE "public"."test_run" ADD CONSTRAINT "test_run_check" CHECK (
CASE
    WHEN status::text = 'new'::text THEN "totalCases" IS NULL
    WHEN status::text = ANY (ARRAY['cancelled'::character varying, 'error'::character varying]::text[]) THEN "totalCases" IS NULL OR "totalCases" >= 0
    ELSE "totalCases" >= 0
END);
ALTER TABLE "public"."test_run" ADD CONSTRAINT "test_run_check1" CHECK (
CASE
    WHEN status::text = 'new'::text THEN "passedCases" IS NULL
    WHEN status::text = ANY (ARRAY['cancelled'::character varying, 'error'::character varying]::text[]) THEN "passedCases" IS NULL OR "passedCases" >= 0
    ELSE "passedCases" >= 0
END);
ALTER TABLE "public"."test_run" ADD CONSTRAINT "test_run_check2" CHECK (
CASE
    WHEN status::text = 'new'::text THEN "failedCases" IS NULL
    WHEN status::text = ANY (ARRAY['cancelled'::character varying, 'error'::character varying]::text[]) THEN "failedCases" IS NULL OR "failedCases" >= 0
    ELSE "failedCases" >= 0
END);

-- ----------------------------
-- Primary Key structure for table test_run
-- ----------------------------
ALTER TABLE "public"."test_run" ADD CONSTRAINT "PK_011c050f566e9db509a0fadb9b9" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table user
-- ----------------------------
ALTER TABLE "public"."user" ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e2" UNIQUE ("email");

-- ----------------------------
-- Primary Key structure for table user
-- ----------------------------
ALTER TABLE "public"."user" ADD CONSTRAINT "PK_ea8f538c94b6e352418254ed6474a81f" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table user_api_keys
-- ----------------------------
CREATE UNIQUE INDEX "IDX_1ef35bac35d20bdae979d917a3" ON "public"."user_api_keys" USING btree (
  "apiKey" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "IDX_63d7bbae72c767cf162d459fcc" ON "public"."user_api_keys" USING btree (
  "userId" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "label" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table user_api_keys
-- ----------------------------
ALTER TABLE "public"."user_api_keys" ADD CONSTRAINT "PK_978fa5caa3468f463dac9d92e69" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table variables
-- ----------------------------
CREATE UNIQUE INDEX "pk_variables_id" ON "public"."variables" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table variables
-- ----------------------------
ALTER TABLE "public"."variables" ADD CONSTRAINT "variables_key_key" UNIQUE ("key");

-- ----------------------------
-- Primary Key structure for table variables
-- ----------------------------
ALTER TABLE "public"."variables" ADD CONSTRAINT "variables_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table webhook_entity
-- ----------------------------
CREATE INDEX "idx_16f4436789e804e3e1c9eeb240" ON "public"."webhook_entity" USING btree (
  "webhookId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "method" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "pathLength" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table webhook_entity
-- ----------------------------
ALTER TABLE "public"."webhook_entity" ADD CONSTRAINT "PK_b21ace2e13596ccd87dc9bf4ea6" PRIMARY KEY ("webhookPath", "method");

-- ----------------------------
-- Indexes structure for table workflow_entity
-- ----------------------------
CREATE INDEX "IDX_workflow_entity_name" ON "public"."workflow_entity" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "pk_workflow_entity_id" ON "public"."workflow_entity" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table workflow_entity
-- ----------------------------
ALTER TABLE "public"."workflow_entity" ADD CONSTRAINT "workflow_entity_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table workflow_history
-- ----------------------------
CREATE INDEX "IDX_1e31657f5fe46816c34be7c1b4" ON "public"."workflow_history" USING btree (
  "workflowId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table workflow_history
-- ----------------------------
ALTER TABLE "public"."workflow_history" ADD CONSTRAINT "PK_b6572dd6173e4cd06fe79937b58" PRIMARY KEY ("versionId");

-- ----------------------------
-- Primary Key structure for table workflow_statistics
-- ----------------------------
ALTER TABLE "public"."workflow_statistics" ADD CONSTRAINT "pk_workflow_statistics" PRIMARY KEY ("workflowId", "name");

-- ----------------------------
-- Indexes structure for table workflows_tags
-- ----------------------------
CREATE INDEX "idx_workflows_tags_workflow_id" ON "public"."workflows_tags" USING btree (
  "workflowId" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table workflows_tags
-- ----------------------------
ALTER TABLE "public"."workflows_tags" ADD CONSTRAINT "pk_workflows_tags" PRIMARY KEY ("workflowId", "tagId");

-- ----------------------------
-- Foreign Keys structure for table auth_identity
-- ----------------------------
ALTER TABLE "public"."auth_identity" ADD CONSTRAINT "auth_identity_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table execution_annotation_tags
-- ----------------------------
ALTER TABLE "public"."execution_annotation_tags" ADD CONSTRAINT "FK_a3697779b366e131b2bbdae2976" FOREIGN KEY ("tagId") REFERENCES "public"."annotation_tag_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."execution_annotation_tags" ADD CONSTRAINT "FK_c1519757391996eb06064f0e7c8" FOREIGN KEY ("annotationId") REFERENCES "public"."execution_annotations" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table execution_annotations
-- ----------------------------
ALTER TABLE "public"."execution_annotations" ADD CONSTRAINT "FK_97f863fa83c4786f19565084960" FOREIGN KEY ("executionId") REFERENCES "public"."execution_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table execution_data
-- ----------------------------
ALTER TABLE "public"."execution_data" ADD CONSTRAINT "execution_data_fk" FOREIGN KEY ("executionId") REFERENCES "public"."execution_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table execution_entity
-- ----------------------------
ALTER TABLE "public"."execution_entity" ADD CONSTRAINT "fk_execution_entity_workflow_id" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table execution_metadata
-- ----------------------------
ALTER TABLE "public"."execution_metadata" ADD CONSTRAINT "FK_31d0b4c93fb85ced26f6005cda3" FOREIGN KEY ("executionId") REFERENCES "public"."execution_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table folder
-- ----------------------------
ALTER TABLE "public"."folder" ADD CONSTRAINT "FK_804ea52f6729e3940498bd54d78" FOREIGN KEY ("parentFolderId") REFERENCES "public"."folder" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."folder" ADD CONSTRAINT "FK_a8260b0b36939c6247f385b8221" FOREIGN KEY ("projectId") REFERENCES "public"."project" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table folder_tag
-- ----------------------------
ALTER TABLE "public"."folder_tag" ADD CONSTRAINT "FK_94a60854e06f2897b2e0d39edba" FOREIGN KEY ("folderId") REFERENCES "public"."folder" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."folder_tag" ADD CONSTRAINT "FK_dc88164176283de80af47621746" FOREIGN KEY ("tagId") REFERENCES "public"."tag_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table insights_by_period
-- ----------------------------
ALTER TABLE "public"."insights_by_period" ADD CONSTRAINT "FK_6414cfed98daabbfdd61a1cfbc0" FOREIGN KEY ("metaId") REFERENCES "public"."insights_metadata" ("metaId") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table insights_metadata
-- ----------------------------
ALTER TABLE "public"."insights_metadata" ADD CONSTRAINT "FK_1d8ab99d5861c9388d2dc1cf733" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."insights_metadata" ADD CONSTRAINT "FK_2375a1eda085adb16b24615b69c" FOREIGN KEY ("projectId") REFERENCES "public"."project" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table insights_raw
-- ----------------------------
ALTER TABLE "public"."insights_raw" ADD CONSTRAINT "FK_6e2e33741adef2a7c5d66befa4e" FOREIGN KEY ("metaId") REFERENCES "public"."insights_metadata" ("metaId") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table installed_nodes
-- ----------------------------
ALTER TABLE "public"."installed_nodes" ADD CONSTRAINT "FK_73f857fc5dce682cef8a99c11dbddbc969618951" FOREIGN KEY ("package") REFERENCES "public"."installed_packages" ("packageName") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table processed_data
-- ----------------------------
ALTER TABLE "public"."processed_data" ADD CONSTRAINT "FK_06a69a7032c97a763c2c7599464" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table project_relation
-- ----------------------------
ALTER TABLE "public"."project_relation" ADD CONSTRAINT "FK_5f0643f6717905a05164090dde7" FOREIGN KEY ("userId") REFERENCES "public"."user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."project_relation" ADD CONSTRAINT "FK_61448d56d61802b5dfde5cdb002" FOREIGN KEY ("projectId") REFERENCES "public"."project" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table shared_credentials
-- ----------------------------
ALTER TABLE "public"."shared_credentials" ADD CONSTRAINT "FK_416f66fc846c7c442970c094ccf" FOREIGN KEY ("credentialsId") REFERENCES "public"."credentials_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."shared_credentials" ADD CONSTRAINT "FK_812c2852270da1247756e77f5a4" FOREIGN KEY ("projectId") REFERENCES "public"."project" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table shared_workflow
-- ----------------------------
ALTER TABLE "public"."shared_workflow" ADD CONSTRAINT "FK_a45ea5f27bcfdc21af9b4188560" FOREIGN KEY ("projectId") REFERENCES "public"."project" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."shared_workflow" ADD CONSTRAINT "FK_daa206a04983d47d0a9c34649ce" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table test_case_execution
-- ----------------------------
ALTER TABLE "public"."test_case_execution" ADD CONSTRAINT "FK_258d954733841d51edd826a562b" FOREIGN KEY ("pastExecutionId") REFERENCES "public"."execution_entity" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."test_case_execution" ADD CONSTRAINT "FK_8e4b4774db42f1e6dda3452b2af" FOREIGN KEY ("testRunId") REFERENCES "public"."test_run" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."test_case_execution" ADD CONSTRAINT "FK_dfbe194e3ebdfe49a87bc4692ca" FOREIGN KEY ("evaluationExecutionId") REFERENCES "public"."execution_entity" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."test_case_execution" ADD CONSTRAINT "FK_e48965fac35d0f5b9e7f51d8c44" FOREIGN KEY ("executionId") REFERENCES "public"."execution_entity" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table test_definition
-- ----------------------------
ALTER TABLE "public"."test_definition" ADD CONSTRAINT "FK_9ec1ce6fbf82305f489adb971d3" FOREIGN KEY ("evaluationWorkflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."test_definition" ADD CONSTRAINT "FK_b0dd0087fe3da02b0ffa4b9c5bb" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."test_definition" ADD CONSTRAINT "FK_d5d7ea64662dbc62f5e266fbeb0" FOREIGN KEY ("annotationTagId") REFERENCES "public"."annotation_tag_entity" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table test_metric
-- ----------------------------
ALTER TABLE "public"."test_metric" ADD CONSTRAINT "FK_3a4e9cf37111ac3270e2469b475" FOREIGN KEY ("testDefinitionId") REFERENCES "public"."test_definition" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table test_run
-- ----------------------------
ALTER TABLE "public"."test_run" ADD CONSTRAINT "FK_3a81713a76f2295b12b46cdfcab" FOREIGN KEY ("testDefinitionId") REFERENCES "public"."test_definition" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table user_api_keys
-- ----------------------------
ALTER TABLE "public"."user_api_keys" ADD CONSTRAINT "FK_e131705cbbc8fb589889b02d457" FOREIGN KEY ("userId") REFERENCES "public"."user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table webhook_entity
-- ----------------------------
ALTER TABLE "public"."webhook_entity" ADD CONSTRAINT "fk_webhook_entity_workflow_id" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table workflow_entity
-- ----------------------------
ALTER TABLE "public"."workflow_entity" ADD CONSTRAINT "fk_workflow_parent_folder" FOREIGN KEY ("parentFolderId") REFERENCES "public"."folder" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table workflow_history
-- ----------------------------
ALTER TABLE "public"."workflow_history" ADD CONSTRAINT "FK_1e31657f5fe46816c34be7c1b4b" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table workflow_statistics
-- ----------------------------
ALTER TABLE "public"."workflow_statistics" ADD CONSTRAINT "fk_workflow_statistics_workflow_id" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table workflows_tags
-- ----------------------------
ALTER TABLE "public"."workflows_tags" ADD CONSTRAINT "fk_workflows_tags_tag_id" FOREIGN KEY ("tagId") REFERENCES "public"."tag_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."workflows_tags" ADD CONSTRAINT "fk_workflows_tags_workflow_id" FOREIGN KEY ("workflowId") REFERENCES "public"."workflow_entity" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
