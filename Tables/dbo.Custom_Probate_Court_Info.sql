CREATE TABLE [dbo].[Custom_Probate_Court_Info]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMTY PROP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COURT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TELEPHONE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTION] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WEBSITE] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLAIM FEE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEARCH FEE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COVERED AREAS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zipcode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addresssave] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
