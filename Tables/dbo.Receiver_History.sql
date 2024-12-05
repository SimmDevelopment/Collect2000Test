CREATE TABLE [dbo].[Receiver_History]
(
[HistoryId] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [int] NULL,
[FileTypeId] [int] NULL,
[TransactionDate] [datetime] NULL,
[FileUrl] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResultId] [int] NULL,
[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumRecords] [int] NULL,
[NumErrors] [int] NULL,
[SumOfTransaction] [money] NULL,
[RawFile] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_History] ADD CONSTRAINT [PK_Receiver_History] PRIMARY KEY CLUSTERED ([HistoryId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_History] ADD CONSTRAINT [FK_Receiver_History_Receiver_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Receiver_Client] ([ClientId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Receiver_History] ADD CONSTRAINT [FK_Receiver_History_Receiver_FileType] FOREIGN KEY ([FileTypeId]) REFERENCES [dbo].[Receiver_FileType] ([FileTypeId])
GO
ALTER TABLE [dbo].[Receiver_History] ADD CONSTRAINT [FK_Receiver_History_Receiver_Result] FOREIGN KEY ([ResultId]) REFERENCES [dbo].[Receiver_Result] ([ResultId])
GO
