CREATE TABLE [dbo].[latitudeinstance_backup]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataSource] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InitialCatalog] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSPI] [bit] NOT NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL,
[RFU] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
