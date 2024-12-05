CREATE TABLE [dbo].[Receiver_HistoryDetail]
(
[HistoryDetailId] [int] NOT NULL IDENTITY(1, 1),
[HistoryId] [int] NULL,
[ResultId] [int] NULL,
[Number] [int] NULL,
[RawData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_HistoryDetail] ADD CONSTRAINT [PK_Receiver_HistoryDetail] PRIMARY KEY CLUSTERED ([HistoryDetailId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_HistoryDetail] ADD CONSTRAINT [FK_Receiver_HistoryDetail_Receiver_History] FOREIGN KEY ([HistoryId]) REFERENCES [dbo].[Receiver_History] ([HistoryId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Receiver_HistoryDetail] ADD CONSTRAINT [FK_Receiver_HistoryDetail_Receiver_Result] FOREIGN KEY ([ResultId]) REFERENCES [dbo].[Receiver_Result] ([ResultId])
GO
