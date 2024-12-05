CREATE TABLE [dbo].[AIM_MiscExtra]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MiscExtraTypeID] [int] NOT NULL,
[ReferenceID] [int] NOT NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entered] [datetime] NOT NULL CONSTRAINT [DF__AIM_MiscE__Enter__7A18830F] DEFAULT (getdate()),
[EnteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_MiscExtra] ADD CONSTRAINT [PK_AIM_MiscExtra] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
