CREATE TABLE [dbo].[AIM_Note]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Entered] [datetime] NOT NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionID] [int] NOT NULL,
[ResultID] [int] NOT NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoteTypeID] [int] NOT NULL,
[ReferenceID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Note] ADD CONSTRAINT [PK_AIM_Note] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
