CREATE TABLE [dbo].[PromiseNotes]
(
[number] [int] NULL,
[note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_PromiseNotes_number] ON [dbo].[PromiseNotes] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
