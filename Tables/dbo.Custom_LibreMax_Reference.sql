CREATE TABLE [dbo].[Custom_LibreMax_Reference]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DateAdded] [datetime] NULL,
[SOC NBR] [float] NULL,
[PKT NBR] [float] NULL,
[COSIGN CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REF NBR] [float] NULL,
[NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CO NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STREET ADDR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FOR STREET ADDR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FOR CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FOR STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FOR ZIP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT DT] [datetime] NULL,
[EFF DT] [datetime] NULL,
[SRC CD] [float] NULL,
[PRIM PHN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SECN PHN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIM PHN CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SECN PHN CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REF SOC NBR] [float] NULL,
[REF SUSP CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REF SUSP CD DT] [datetime] NULL,
[BAN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIM CONS FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SECN CONS FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_LibreMax_Reference] ADD CONSTRAINT [PK_Custom_LibreMax_Reference] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
