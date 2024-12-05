CREATE TABLE [dbo].[NewBusiness]
(
[ID] [int] NOT NULL,
[Batch] [int] NULL,
[Seq] [int] NULL,
[processed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Anumber] [int] NULL,
[Enumber] [int] NULL,
[Adollars] [money] NULL,
[Edollars] [money] NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customername] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BALANCE] [money] NULL,
[oTHER] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NewBusiness1] ON [dbo].[NewBusiness] ([Zipcode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
