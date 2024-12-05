CREATE TABLE [dbo].[DFBHistory_Detail]
(
[DFBHistory_DetailId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_DFBHistory_Detail_DetailId] DEFAULT (newsequentialid()),
[AccountId] [bigint] NOT NULL,
[DebtorId] [bigint] NOT NULL,
[DFBHistoryId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DFBHistory_Detail] ADD CONSTRAINT [PK_DFBHistory_Detail] PRIMARY KEY CLUSTERED ([DFBHistory_DetailId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DFBHistory_Detail] ADD CONSTRAINT [FK_DFBHistory_Detail__DFBHistoryId] FOREIGN KEY ([DFBHistoryId]) REFERENCES [dbo].[DFBHistory] ([UID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'A table to hold information about each record sent in a list to the dialer. Can be used to lookup the debtorid or accountid for screen pop or reporting. Meant to supply the DFBHistory_DetailId as the key when exporting data to the dialer.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory_Detail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude FileNumber.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory_Detail', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The PK for the debtor record for this contact attempt.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory_Detail', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A unique key to be sent to the dialer in place of the accountid. The screen pop can then use this table to pop a particular debtor.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory_Detail', 'COLUMN', N'DFBHistory_DetailId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to DFBHistory table.', 'SCHEMA', N'dbo', 'TABLE', N'DFBHistory_Detail', 'COLUMN', N'DFBHistoryId'
GO
