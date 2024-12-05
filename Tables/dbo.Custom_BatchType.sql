CREATE TABLE [dbo].[Custom_BatchType]
(
[BatchTypeId] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_BatchType] ADD CONSTRAINT [PK_Custom_BatchType] PRIMARY KEY CLUSTERED ([BatchTypeId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Custom_BatchType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Custom_BatchType', 'COLUMN', N'BatchTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Custom_BatchType', 'COLUMN', N'Name'
GO
