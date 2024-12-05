CREATE TABLE [dbo].[PropensioSiteEvent]
(
[ID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PropensioSiteEvent] ADD CONSTRAINT [PK_PropensioSiteEvent] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
