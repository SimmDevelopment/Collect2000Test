CREATE TABLE [dbo].[Auto_RepoAgency]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contactname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contactphone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contactemail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
