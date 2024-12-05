CREATE TABLE [dbo].[HistoricalTransactions]
(
[HistoricalID] [int] NOT NULL IDENTITY(1, 1),
[FileNumber] [int] NOT NULL,
[TransactionDate] [date] NULL,
[AmountOfTransaction] [money] NULL,
[TransactionType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionReference] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionComment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HistoricalTransactions] ADD CONSTRAINT [PK_HistoricalTransactions] PRIMARY KEY CLUSTERED ([HistoricalID]) ON [PRIMARY]
GO
