CREATE TABLE [dbo].[LatitudeLegal_HistoryRecordDetail]
(
[LLHRD] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL,
[TransactionDate] [datetime] NULL,
[TransactionType] [int] NULL,
[TransactionStatus] [int] NULL,
[AttorneyID] [int] NULL,
[AttorneyLawList] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Balance] [money] NULL,
[LLHistoryID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_HistoryRecordDetail] ADD CONSTRAINT [PK_LatitudeLegal_HistoryRecordDetail] PRIMARY KEY CLUSTERED ([LLHRD]) ON [PRIMARY]
GO
