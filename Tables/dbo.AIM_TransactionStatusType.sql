CREATE TABLE [dbo].[AIM_TransactionStatusType]
(
[TransactionStatusTypeId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_TransactionStatusType] ADD CONSTRAINT [PK_TransactionStatusType] PRIMARY KEY CLUSTERED ([TransactionStatusTypeId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_TransactionStatusType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_TransactionStatusType', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'AIM_TransactionStatusType', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_TransactionStatusType', 'COLUMN', N'TransactionStatusTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_TransactionStatusType', 'COLUMN', N'TransactionStatusTypeId'
GO
