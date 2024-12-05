CREATE TABLE [dbo].[FirstDataDownloadMaint]
(
[RunDate] [datetime] NOT NULL,
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WholeRecord] [varchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Message] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Disposition] [tinyint] NOT NULL,
[LoadedOK] [tinyint] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstDataDownloadMaint] ADD CONSTRAINT [PK_FirstDataDownloadMaint] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndAccount] ON [dbo].[FirstDataDownloadMaint] ([Account]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndRunDate] ON [dbo].[FirstDataDownloadMaint] ([RunDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
