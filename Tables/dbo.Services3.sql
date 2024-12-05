CREATE TABLE [dbo].[Services3]
(
[Number] [int] NULL,
[uid] [int] NOT NULL,
[Serviceid] [int] NULL,
[ServiceDate] [datetime] NULL,
[ServiceMsg] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdFirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdLastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdDOB] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdDOD] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Decdcode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
