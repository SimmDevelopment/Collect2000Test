CREATE TABLE [dbo].[Custom_Middletown_Preload]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Utm Id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to Street1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to Street2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to City, St] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to Cell] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bill to Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Water Pay Amount] [float] NULL,
[Last Water Pay Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Water Pay Method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Sewer Pay Amount] [float] NULL,
[Last Sewer Pay Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Sewer Pay Method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Electric Pay Amount] [float] NULL,
[Last Electric Pay Date] [datetime] NULL,
[Last Electric Pay Method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Trash Pay Amount] [float] NULL,
[Last Trash Pay Date] [datetime] NULL,
[Last Trash Pay Method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Water Active Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sewer Active Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Electric Active Date] [datetime] NULL,
[Trash Active Date] [datetime] NULL,
[Bankruptcy Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bankruptcy Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Drivers License] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wtr Swr Ele Tra Prin 30 Days Past Due] [float] NULL,
[Wtr Swr Ele Tra (Prin +Penalty) Due] [float] NULL,
[Column1] [bit] NOT NULL,
[Column2] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Middletown_Preload] ADD CONSTRAINT [PK_Custom_Middletown_Preload] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
