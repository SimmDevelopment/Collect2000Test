CREATE TABLE [dbo].[AIM_PaperType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_PaperType] ADD CONSTRAINT [PK_AIM_PaperType] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
