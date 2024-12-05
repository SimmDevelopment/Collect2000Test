CREATE TABLE [dbo].[Custom_H&RBlock_Offices]
(
[Div] [int] NULL,
[Reg] [int] NULL,
[Type] [int] NULL,
[AdminID] [int] NULL,
[Location Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficeID] [int] NOT NULL,
[OFMAIN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Office Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Office Type Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tax Prep] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Open Year Round] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OFADDR] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OFADD2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OFCITY] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OFSTA] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OFZIPC] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OFPH25] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OFFX25] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OMGRNM] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_H&RBlock_Offices] ADD CONSTRAINT [PK_Custom_H&RBlock_Offices] PRIMARY KEY CLUSTERED ([OfficeID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
