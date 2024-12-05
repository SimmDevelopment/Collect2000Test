CREATE TABLE [dbo].[AIM_NoteResult]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ResultCode] [char] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_NoteResult] ADD CONSTRAINT [PK_AIM_NoteResult] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
