CREATE TABLE [dbo].[Native_OOS_States]
(
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OOSTypeId] [tinyint] NOT NULL,
[Years] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Native_OOS_States] ADD CONSTRAINT [PK_OOSTypeId_State] PRIMARY KEY CLUSTERED ([State], [OOSTypeId]) ON [PRIMARY]
GO
