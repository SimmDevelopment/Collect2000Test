CREATE TABLE [dbo].[AIM_NoteAction]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ActionCode] [char] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_NoteAction] ADD CONSTRAINT [PK_AIM_NoteAction] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
