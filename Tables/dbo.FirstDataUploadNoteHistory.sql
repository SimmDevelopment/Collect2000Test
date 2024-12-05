CREATE TABLE [dbo].[FirstDataUploadNoteHistory]
(
[Number] [int] NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[NoteCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Narrative1] [varchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankID] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstDataUploadNoteHistory] ADD CONSTRAINT [PK_FirstDataUploadNoteHistory] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndNumber] ON [dbo].[FirstDataUploadNoteHistory] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
