CREATE TABLE [dbo].[Custom_Dashboard]
(
[DashID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[ReportPath] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportParameters] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefreshInterval] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Dashboard] ADD CONSTRAINT [PK_Custom_Dashboard] PRIMARY KEY CLUSTERED ([DashID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
