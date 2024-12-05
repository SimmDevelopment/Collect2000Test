CREATE TABLE [dbo].[SellerBuyerContacts]
(
[SellerBuyerId] [int] NOT NULL,
[ContactId] [int] NOT NULL IDENTITY(1, 1),
[ContactType] [int] NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Website] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Misc1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Misc2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Misc3] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Misc4] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
