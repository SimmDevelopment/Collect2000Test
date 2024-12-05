CREATE TABLE [dbo].[LatitudeLegal_Transactions]
(
[ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__LatitudeLega__ID__6D289C45] DEFAULT (newid()),
[FKID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[YGCID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordType] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateTimeEntered] [datetime] NOT NULL CONSTRAINT [DF__LatitudeL__DateT__6E1CC07E] DEFAULT (getdate()),
[Balance] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_Transactions] ADD CONSTRAINT [PK_LatitudeLegal_Transactions] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_Transactions_AccountID] ON [dbo].[LatitudeLegal_Transactions] ([AccountID], [RecordType]) ON [PRIMARY]
GO
