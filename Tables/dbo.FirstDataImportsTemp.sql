CREATE TABLE [dbo].[FirstDataImportsTemp]
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
ALTER TABLE [dbo].[FirstDataImportsTemp] ADD CONSTRAINT [PK_FirstDataImportsTemp] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndAccount] ON [dbo].[FirstDataImportsTemp] ([Account]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndRunDate] ON [dbo].[FirstDataImportsTemp] ([RunDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
