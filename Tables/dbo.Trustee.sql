CREATE TABLE [dbo].[Trustee]
(
[Code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESCRIPTION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HoldFunds] [int] NULL
) ON [PRIMARY]
GO
