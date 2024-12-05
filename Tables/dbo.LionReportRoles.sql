CREATE TABLE [dbo].[LionReportRoles]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RoleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionReportRoles] ADD CONSTRAINT [PK_LionReportRoles] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
