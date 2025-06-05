/*
 Navicat Premium Data Transfer

 Source Server         : Tritan N8N
 Source Server Type    : PostgreSQL
 Source Server Version : 160009 (160009)
 Source Host           : localhost:5435
 Source Catalog        : openwebui
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 160009 (160009)
 File Encoding         : 65001

 Date: 04/06/2025 23:35:34
*/


-- ----------------------------
-- Sequence structure for config_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."config_id_seq";
CREATE SEQUENCE "public"."config_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for document_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."document_id_seq";
CREATE SEQUENCE "public"."document_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for migratehistory_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."migratehistory_id_seq";
CREATE SEQUENCE "public"."migratehistory_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for prompt_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."prompt_id_seq";
CREATE SEQUENCE "public"."prompt_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS "public"."alembic_version";
CREATE TABLE "public"."alembic_version" (
  "version_num" varchar(32) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO "public"."alembic_version" VALUES ('9f0c9cd09105');

-- ----------------------------
-- Table structure for auth
-- ----------------------------
DROP TABLE IF EXISTS "public"."auth";
CREATE TABLE "public"."auth" (
  "id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password" text COLLATE "pg_catalog"."default" NOT NULL,
  "active" bool NOT NULL
)
;

-- ----------------------------
-- Records of auth
-- ----------------------------
INSERT INTO "public"."auth" VALUES ('e3f60ff8-ef85-4ae8-a972-eab7bd2f7620', 'admin@admin.com', '$2b$12$Y6IHX7GGQprd4osMJ0PuY.47ftWCl0m2ALStMohH5eJV48jdLGGh.', 't');

-- ----------------------------
-- Table structure for channel
-- ----------------------------
DROP TABLE IF EXISTS "public"."channel";
CREATE TABLE "public"."channel" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default",
  "name" text COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "data" json,
  "meta" json,
  "access_control" json,
  "created_at" int8,
  "updated_at" int8,
  "type" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of channel
-- ----------------------------

-- ----------------------------
-- Table structure for channel_member
-- ----------------------------
DROP TABLE IF EXISTS "public"."channel_member";
CREATE TABLE "public"."channel_member" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "channel_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" int8
)
;

-- ----------------------------
-- Records of channel_member
-- ----------------------------

-- ----------------------------
-- Table structure for chat
-- ----------------------------
DROP TABLE IF EXISTS "public"."chat";
CREATE TABLE "public"."chat" (
  "id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "title" text COLLATE "pg_catalog"."default" NOT NULL,
  "share_id" varchar(255) COLLATE "pg_catalog"."default",
  "archived" bool NOT NULL,
  "created_at" int8 NOT NULL,
  "updated_at" int8 NOT NULL,
  "chat" json,
  "pinned" bool,
  "meta" json NOT NULL DEFAULT '{}'::json,
  "folder_id" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of chat
-- ----------------------------

-- ----------------------------
-- Table structure for chatidtag
-- ----------------------------
DROP TABLE IF EXISTS "public"."chatidtag";
CREATE TABLE "public"."chatidtag" (
  "id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "tag_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "chat_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "timestamp" int8 NOT NULL
)
;

-- ----------------------------
-- Records of chatidtag
-- ----------------------------

-- ----------------------------
-- Table structure for config
-- ----------------------------
DROP TABLE IF EXISTS "public"."config";
CREATE TABLE "public"."config" (
  "id" int4 NOT NULL DEFAULT nextval('config_id_seq'::regclass),
  "data" json NOT NULL,
  "version" int4 NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT now(),
  "updated_at" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of config
-- ----------------------------
INSERT INTO "public"."config" VALUES (1, '{"version": 0, "ui": {"enable_signup": false}}', 0, '2025-06-05 02:34:57.622769', NULL);

-- ----------------------------
-- Table structure for document
-- ----------------------------
DROP TABLE IF EXISTS "public"."document";
CREATE TABLE "public"."document" (
  "id" int4 NOT NULL DEFAULT nextval('document_id_seq'::regclass),
  "collection_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "title" text COLLATE "pg_catalog"."default" NOT NULL,
  "filename" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default",
  "user_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "timestamp" int8 NOT NULL
)
;

-- ----------------------------
-- Records of document
-- ----------------------------

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS "public"."feedback";
CREATE TABLE "public"."feedback" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default",
  "version" int8,
  "type" text COLLATE "pg_catalog"."default",
  "data" json,
  "meta" json,
  "snapshot" json,
  "created_at" int8 NOT NULL,
  "updated_at" int8 NOT NULL
)
;

-- ----------------------------
-- Records of feedback
-- ----------------------------

-- ----------------------------
-- Table structure for file
-- ----------------------------
DROP TABLE IF EXISTS "public"."file";
CREATE TABLE "public"."file" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "filename" text COLLATE "pg_catalog"."default" NOT NULL,
  "meta" json,
  "created_at" int8 NOT NULL,
  "hash" text COLLATE "pg_catalog"."default",
  "data" json,
  "updated_at" int8,
  "path" text COLLATE "pg_catalog"."default",
  "access_control" json
)
;

-- ----------------------------
-- Records of file
-- ----------------------------

-- ----------------------------
-- Table structure for folder
-- ----------------------------
DROP TABLE IF EXISTS "public"."folder";
CREATE TABLE "public"."folder" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "parent_id" text COLLATE "pg_catalog"."default",
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "items" json,
  "meta" json,
  "is_expanded" bool NOT NULL,
  "created_at" int8 NOT NULL,
  "updated_at" int8 NOT NULL
)
;

-- ----------------------------
-- Records of folder
-- ----------------------------

-- ----------------------------
-- Table structure for function
-- ----------------------------
DROP TABLE IF EXISTS "public"."function";
CREATE TABLE "public"."function" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "type" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "meta" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" int8 NOT NULL,
  "updated_at" int8 NOT NULL,
  "valves" text COLLATE "pg_catalog"."default",
  "is_active" bool NOT NULL,
  "is_global" bool NOT NULL
)
;

-- ----------------------------
-- Records of function
-- ----------------------------

-- ----------------------------
-- Table structure for group
-- ----------------------------
DROP TABLE IF EXISTS "public"."group";
CREATE TABLE "public"."group" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default",
  "name" text COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "data" json,
  "meta" json,
  "permissions" json,
  "user_ids" json,
  "created_at" int8,
  "updated_at" int8
)
;

-- ----------------------------
-- Records of group
-- ----------------------------

-- ----------------------------
-- Table structure for knowledge
-- ----------------------------
DROP TABLE IF EXISTS "public"."knowledge";
CREATE TABLE "public"."knowledge" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "data" json,
  "meta" json,
  "created_at" int8 NOT NULL,
  "updated_at" int8,
  "access_control" json
)
;

-- ----------------------------
-- Records of knowledge
-- ----------------------------

-- ----------------------------
-- Table structure for memory
-- ----------------------------
DROP TABLE IF EXISTS "public"."memory";
CREATE TABLE "public"."memory" (
  "id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "updated_at" int8 NOT NULL,
  "created_at" int8 NOT NULL
)
;

-- ----------------------------
-- Records of memory
-- ----------------------------

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS "public"."message";
CREATE TABLE "public"."message" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default",
  "channel_id" text COLLATE "pg_catalog"."default",
  "content" text COLLATE "pg_catalog"."default",
  "data" json,
  "meta" json,
  "created_at" int8,
  "updated_at" int8,
  "parent_id" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of message
-- ----------------------------

-- ----------------------------
-- Table structure for message_reaction
-- ----------------------------
DROP TABLE IF EXISTS "public"."message_reaction";
CREATE TABLE "public"."message_reaction" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "message_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" int8
)
;

-- ----------------------------
-- Records of message_reaction
-- ----------------------------

-- ----------------------------
-- Table structure for migratehistory
-- ----------------------------
DROP TABLE IF EXISTS "public"."migratehistory";
CREATE TABLE "public"."migratehistory" (
  "id" int4 NOT NULL DEFAULT nextval('migratehistory_id_seq'::regclass),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "migrated_at" timestamp(6) NOT NULL
)
;

-- ----------------------------
-- Records of migratehistory
-- ----------------------------
INSERT INTO "public"."migratehistory" VALUES (1, '001_initial_schema', '2025-06-05 02:34:33.572983');
INSERT INTO "public"."migratehistory" VALUES (2, '002_add_local_sharing', '2025-06-05 02:34:33.588489');
INSERT INTO "public"."migratehistory" VALUES (3, '003_add_auth_api_key', '2025-06-05 02:34:33.601059');
INSERT INTO "public"."migratehistory" VALUES (4, '004_add_archived', '2025-06-05 02:34:33.60777');
INSERT INTO "public"."migratehistory" VALUES (5, '005_add_updated_at', '2025-06-05 02:34:33.625588');
INSERT INTO "public"."migratehistory" VALUES (6, '006_migrate_timestamps_and_charfields', '2025-06-05 02:34:33.635077');
INSERT INTO "public"."migratehistory" VALUES (7, '007_add_user_last_active_at', '2025-06-05 02:34:33.645471');
INSERT INTO "public"."migratehistory" VALUES (8, '008_add_memory', '2025-06-05 02:34:33.666349');
INSERT INTO "public"."migratehistory" VALUES (9, '009_add_models', '2025-06-05 02:34:33.68721');
INSERT INTO "public"."migratehistory" VALUES (10, '010_migrate_modelfiles_to_models', '2025-06-05 02:34:33.696388');
INSERT INTO "public"."migratehistory" VALUES (11, '011_add_user_settings', '2025-06-05 02:34:33.702222');
INSERT INTO "public"."migratehistory" VALUES (12, '012_add_tools', '2025-06-05 02:34:33.72271');
INSERT INTO "public"."migratehistory" VALUES (13, '013_add_user_info', '2025-06-05 02:34:33.727975');
INSERT INTO "public"."migratehistory" VALUES (14, '014_add_files', '2025-06-05 02:34:33.748523');
INSERT INTO "public"."migratehistory" VALUES (15, '015_add_functions', '2025-06-05 02:34:33.771168');
INSERT INTO "public"."migratehistory" VALUES (16, '016_add_valves_and_is_active', '2025-06-05 02:34:33.777403');
INSERT INTO "public"."migratehistory" VALUES (17, '017_add_user_oauth_sub', '2025-06-05 02:34:33.789824');
INSERT INTO "public"."migratehistory" VALUES (18, '018_add_function_is_global', '2025-06-05 02:34:33.795807');

-- ----------------------------
-- Table structure for model
-- ----------------------------
DROP TABLE IF EXISTS "public"."model";
CREATE TABLE "public"."model" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "base_model_id" text COLLATE "pg_catalog"."default",
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "meta" text COLLATE "pg_catalog"."default" NOT NULL,
  "params" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" int8 NOT NULL,
  "updated_at" int8 NOT NULL,
  "access_control" json,
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of model
-- ----------------------------

-- ----------------------------
-- Table structure for note
-- ----------------------------
DROP TABLE IF EXISTS "public"."note";
CREATE TABLE "public"."note" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default",
  "title" text COLLATE "pg_catalog"."default",
  "data" json,
  "meta" json,
  "access_control" json,
  "created_at" int8,
  "updated_at" int8
)
;

-- ----------------------------
-- Records of note
-- ----------------------------

-- ----------------------------
-- Table structure for prompt
-- ----------------------------
DROP TABLE IF EXISTS "public"."prompt";
CREATE TABLE "public"."prompt" (
  "id" int4 NOT NULL DEFAULT nextval('prompt_id_seq'::regclass),
  "command" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "title" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "timestamp" int8 NOT NULL,
  "access_control" json
)
;

-- ----------------------------
-- Records of prompt
-- ----------------------------

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS "public"."tag";
CREATE TABLE "public"."tag" (
  "id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "meta" json
)
;

-- ----------------------------
-- Records of tag
-- ----------------------------

-- ----------------------------
-- Table structure for tool
-- ----------------------------
DROP TABLE IF EXISTS "public"."tool";
CREATE TABLE "public"."tool" (
  "id" text COLLATE "pg_catalog"."default" NOT NULL,
  "user_id" text COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default" NOT NULL,
  "specs" text COLLATE "pg_catalog"."default" NOT NULL,
  "meta" text COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" int8 NOT NULL,
  "updated_at" int8 NOT NULL,
  "valves" text COLLATE "pg_catalog"."default",
  "access_control" json
)
;

-- ----------------------------
-- Records of tool
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS "public"."user";
CREATE TABLE "public"."user" (
  "id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "profile_image_url" text COLLATE "pg_catalog"."default" NOT NULL,
  "api_key" varchar(255) COLLATE "pg_catalog"."default",
  "created_at" int8 NOT NULL,
  "updated_at" int8 NOT NULL,
  "last_active_at" int8 NOT NULL,
  "settings" text COLLATE "pg_catalog"."default",
  "info" text COLLATE "pg_catalog"."default",
  "oauth_sub" text COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO "public"."user" VALUES ('e3f60ff8-ef85-4ae8-a972-eab7bd2f7620', 'Admin User', 'admin@admin.com', 'admin', 'data:image/png;base64,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', NULL, 1749090897, 1749090897, 1749090909, '{"ui": {"version": "0.6.13"}}', 'null', NULL);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."config_id_seq"
OWNED BY "public"."config"."id";
SELECT setval('"public"."config_id_seq"', 1, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."document_id_seq"
OWNED BY "public"."document"."id";
SELECT setval('"public"."document_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."migratehistory_id_seq"
OWNED BY "public"."migratehistory"."id";
SELECT setval('"public"."migratehistory_id_seq"', 18, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."prompt_id_seq"
OWNED BY "public"."prompt"."id";
SELECT setval('"public"."prompt_id_seq"', 1, false);

-- ----------------------------
-- Primary Key structure for table alembic_version
-- ----------------------------
ALTER TABLE "public"."alembic_version" ADD CONSTRAINT "alembic_version_pkc" PRIMARY KEY ("version_num");

-- ----------------------------
-- Indexes structure for table auth
-- ----------------------------
CREATE UNIQUE INDEX "auth_id" ON "public"."auth" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table channel
-- ----------------------------
ALTER TABLE "public"."channel" ADD CONSTRAINT "channel_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table channel_member
-- ----------------------------
ALTER TABLE "public"."channel_member" ADD CONSTRAINT "channel_member_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table chat
-- ----------------------------
CREATE UNIQUE INDEX "chat_id" ON "public"."chat" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "chat_share_id" ON "public"."chat" USING btree (
  "share_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Indexes structure for table chatidtag
-- ----------------------------
CREATE UNIQUE INDEX "chatidtag_id" ON "public"."chatidtag" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table config
-- ----------------------------
ALTER TABLE "public"."config" ADD CONSTRAINT "config_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table document
-- ----------------------------
CREATE UNIQUE INDEX "document_collection_name" ON "public"."document" USING btree (
  "collection_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "document_name" ON "public"."document" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table document
-- ----------------------------
ALTER TABLE "public"."document" ADD CONSTRAINT "document_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table feedback
-- ----------------------------
ALTER TABLE "public"."feedback" ADD CONSTRAINT "feedback_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table file
-- ----------------------------
CREATE UNIQUE INDEX "file_id" ON "public"."file" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table folder
-- ----------------------------
ALTER TABLE "public"."folder" ADD CONSTRAINT "folder_pkey" PRIMARY KEY ("id", "user_id");

-- ----------------------------
-- Indexes structure for table function
-- ----------------------------
CREATE UNIQUE INDEX "function_id" ON "public"."function" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table group
-- ----------------------------
ALTER TABLE "public"."group" ADD CONSTRAINT "group_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table knowledge
-- ----------------------------
ALTER TABLE "public"."knowledge" ADD CONSTRAINT "knowledge_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table memory
-- ----------------------------
CREATE UNIQUE INDEX "memory_id" ON "public"."memory" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table message
-- ----------------------------
ALTER TABLE "public"."message" ADD CONSTRAINT "message_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table message_reaction
-- ----------------------------
ALTER TABLE "public"."message_reaction" ADD CONSTRAINT "message_reaction_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table migratehistory
-- ----------------------------
ALTER TABLE "public"."migratehistory" ADD CONSTRAINT "migratehistory_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table model
-- ----------------------------
CREATE UNIQUE INDEX "model_id" ON "public"."model" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table note
-- ----------------------------
ALTER TABLE "public"."note" ADD CONSTRAINT "note_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table prompt
-- ----------------------------
CREATE UNIQUE INDEX "prompt_command" ON "public"."prompt" USING btree (
  "command" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table prompt
-- ----------------------------
ALTER TABLE "public"."prompt" ADD CONSTRAINT "prompt_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table tag
-- ----------------------------
ALTER TABLE "public"."tag" ADD CONSTRAINT "pk_id_user_id" PRIMARY KEY ("id", "user_id");

-- ----------------------------
-- Indexes structure for table tool
-- ----------------------------
CREATE UNIQUE INDEX "tool_id" ON "public"."tool" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Indexes structure for table user
-- ----------------------------
CREATE UNIQUE INDEX "user_api_key" ON "public"."user" USING btree (
  "api_key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "user_id" ON "public"."user" USING btree (
  "id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "user_oauth_sub" ON "public"."user" USING btree (
  "oauth_sub" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
