CREATE TABLE [dbo].[LionMenus]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[URL] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportDefinition] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Target] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionMenus] ADD CONSTRAINT [PK_LionMenus] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
