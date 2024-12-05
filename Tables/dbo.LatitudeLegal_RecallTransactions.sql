CREATE TABLE [dbo].[LatitudeLegal_RecallTransactions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[AttyID] [int] NULL,
[AttyLawList] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecalledDateTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_RecallTransactions] ADD CONSTRAINT [PK_LatitudeLegal_RecallTransactions] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LatitudeLegal_RecallTransactions_Number] ON [dbo].[LatitudeLegal_RecallTransactions] ([number]) ON [PRIMARY]
GO
