CREATE TABLE [dbo].[FirstDataDownloadRecalls]
(
[RunDate] [datetime] NOT NULL,
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reason] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ALCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankID] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line] [int] NOT NULL,
[Position] [tinyint] NOT NULL,
[Message] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Disposition] [tinyint] NOT NULL,
[LoadedOK] [tinyint] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstDataDownloadRecalls] ADD CONSTRAINT [PK_FirstDataDownloadRecalls] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndAccount] ON [dbo].[FirstDataDownloadRecalls] ([Account]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndRunDate] ON [dbo].[FirstDataDownloadRecalls] ([RunDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
