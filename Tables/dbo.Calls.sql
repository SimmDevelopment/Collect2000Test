CREATE TABLE [dbo].[Calls]
(
[CallID] [tinyint] NOT NULL,
[AccountID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Calls] ADD CONSTRAINT [PK_Calls] PRIMARY KEY CLUSTERED ([CallID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used by the Latitude Work Form to pass accounts between users by "call number"', 'SCHEMA', N'dbo', 'TABLE', N'Calls', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The file number of the account being passed (master.number)', 'SCHEMA', N'dbo', 'TABLE', N'Calls', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The call number, a value between 1 and 32', 'SCHEMA', N'dbo', 'TABLE', N'Calls', 'COLUMN', N'CallID'
GO
