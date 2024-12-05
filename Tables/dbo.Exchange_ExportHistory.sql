CREATE TABLE [dbo].[Exchange_ExportHistory]
(
[ExportHistoryID] [int] NOT NULL IDENTITY(1, 1),
[ExchangeClientID] [int] NOT NULL,
[ExchangeExportID] [uniqueidentifier] NOT NULL,
[UserID] [int] NULL,
[DateTimeStamp] [datetime] NULL CONSTRAINT [DF__Exchange___DateT__281457E9] DEFAULT (getdate()),
[ExchangeExportName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exchange_ExportHistory] ADD CONSTRAINT [PK_Exchange_ExportHistory] PRIMARY KEY NONCLUSTERED ([ExportHistoryID]) ON [PRIMARY]
GO
