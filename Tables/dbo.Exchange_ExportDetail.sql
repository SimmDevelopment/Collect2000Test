CREATE TABLE [dbo].[Exchange_ExportDetail]
(
[ExportDetailID] [int] NOT NULL IDENTITY(1, 1),
[ExportHistoryID] [int] NOT NULL,
[ExportDetailRecordID] [uniqueidentifier] NOT NULL,
[ExportDetailRecordName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [int] NULL,
[DebtorID] [int] NULL,
[MappedXmlInfo] [xml] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exchange_ExportDetail] ADD CONSTRAINT [PK_Exchange_ExportDetail] PRIMARY KEY NONCLUSTERED ([ExportDetailID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Exchange_ExportDetail_AccountID] ON [dbo].[Exchange_ExportDetail] ([AccountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Exchange_ExportDetail_ExportDetailRecordID] ON [dbo].[Exchange_ExportDetail] ([ExportDetailRecordID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Exchange_ExportDetail_ExportHistoryID] ON [dbo].[Exchange_ExportDetail] ([ExportHistoryID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exchange_ExportDetail] WITH NOCHECK ADD CONSTRAINT [FK_Exchange_ExportDetail_Exchange_ExportHistory] FOREIGN KEY ([ExportHistoryID]) REFERENCES [dbo].[Exchange_ExportHistory] ([ExportHistoryID])
GO
