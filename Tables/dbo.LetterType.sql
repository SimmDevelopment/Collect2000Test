CREATE TABLE [dbo].[LetterType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [smalldatetime] NOT NULL CONSTRAINT [DF_LetterType_Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LetterType_CreatedBy] DEFAULT (suser_sname()),
[Updated] [smalldatetime] NOT NULL CONSTRAINT [DF_LetterType_Updated] DEFAULT (getdate()),
[UpdateBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LetterType_UpdateBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterType] ADD CONSTRAINT [PK_LetterType] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterType] ADD CONSTRAINT [UQ__LetterTy__A25C5AA72A363CC5] UNIQUE NONCLUSTERED ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'LetterType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter type code', 'SCHEMA', N'dbo', 'TABLE', N'LetterType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'LetterType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'LetterType', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Provides amplifying information about letter type', 'SCHEMA', N'dbo', 'TABLE', N'LetterType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter type primary key', 'SCHEMA', N'dbo', 'TABLE', N'LetterType', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'LetterType', 'COLUMN', N'UpdateBy'
GO
