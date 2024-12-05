CREATE TABLE [dbo].[Custom_FormReference]
(
[FormId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Configuration] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Library] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FormName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_FormReference] ADD CONSTRAINT [PK_Custom_FormReference] PRIMARY KEY CLUSTERED ([FormId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
