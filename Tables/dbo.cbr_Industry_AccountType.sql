CREATE TABLE [dbo].[cbr_Industry_AccountType]
(
[industryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accountType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_Industry_AccountType] ADD CONSTRAINT [PK_cbr_Industry_AccountType] PRIMARY KEY CLUSTERED ([industryCode], [accountType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'cbr_Industry_AccountType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'cbr_Industry_AccountType', 'COLUMN', N'accountType'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'cbr_Industry_AccountType', 'COLUMN', N'industryCode'
GO
