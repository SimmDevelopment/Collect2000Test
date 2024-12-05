CREATE TABLE [dbo].[Custom_GoldenTree_Address]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Dateadded] [datetime] NULL,
[SOC NBR] [float] NULL,
[PKT NBR] [float] NULL,
[NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR EFF DT] [datetime] NULL,
[ADDR STAT DT] [datetime] NULL,
[ADDR SRC CD] [float] NULL,
[ADDR COND CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STREET ADDR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CO NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FOR CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIM PHN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SECN PHN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIM PHN CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SECN PHN CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BAN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIM CONS FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SECN CONS FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_GoldenTree_Address] ADD CONSTRAINT [PK_Custom_GoldenTree_Address] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
