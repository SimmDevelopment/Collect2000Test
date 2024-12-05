CREATE TABLE [dbo].[LionAuditActions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Uid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_LionAuditActions_Uid] DEFAULT (newid()),
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionAuditActions] ADD CONSTRAINT [PK_LionAuditActions] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
