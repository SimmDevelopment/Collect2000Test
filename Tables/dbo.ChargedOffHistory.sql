CREATE TABLE [dbo].[ChargedOffHistory]
(
[ChargedOffHistoryID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[Date] [datetime] NOT NULL,
[ChargedOff] [bit] NOT NULL CONSTRAINT [DF_ChargedOffHistory_ChargedOff] DEFAULT ((1)),
[Amount] [money] NOT NULL CONSTRAINT [DF_ChargedOffHistory_Amount] DEFAULT ((0)),
[Entered] [datetime] NOT NULL CONSTRAINT [DF_ChargedOffHistory_Entered] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChargedOffHistory] ADD CONSTRAINT [PK_ChargedOffHistory] PRIMARY KEY CLUSTERED ([ChargedOffHistoryID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChargedOffHistory] ADD CONSTRAINT [FK_ChargedOffHistory_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'master.number', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffHistory', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount charged off or reinstated', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffHistory', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to determine direction, 1 = ChargedOff, 0 = Reinstated', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffHistory', 'COLUMN', N'ChargedOff'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique id of the table', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffHistory', 'COLUMN', N'ChargedOffHistoryID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date the account was chargedoff or reinstated', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffHistory', 'COLUMN', N'Date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date record created', 'SCHEMA', N'dbo', 'TABLE', N'ChargedOffHistory', 'COLUMN', N'Entered'
GO
