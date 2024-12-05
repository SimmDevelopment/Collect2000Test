CREATE TABLE [dbo].[A_snap_4]
(
[servername] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[databasename] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[schemaname] [sys].[sysname] NULL,
[tablename] [sys].[sysname] NOT NULL,
[rowcounts] [bigint] NULL,
[totalspaceKB] [bigint] NULL,
[usedspaceKB] [bigint] NULL,
[unusedspaceKB] [bigint] NULL,
[captureddatetime] [datetime] NOT NULL
) ON [PRIMARY]
GO
