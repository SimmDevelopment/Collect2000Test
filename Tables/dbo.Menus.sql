CREATE TABLE [dbo].[Menus]
(
[MenuGUID] [uniqueidentifier] NOT NULL,
[Menu] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentMenuGUID] [uniqueidentifier] NULL,
[PreGUID] [uniqueidentifier] NULL,
[OrphanPreGUID] [uniqueidentifier] NULL,
[MenuTypeID] [int] NOT NULL,
[Data] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpandInitially] [bit] NOT NULL CONSTRAINT [DF_Menus_Expanded] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Menus] ADD CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED ([MenuGUID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
