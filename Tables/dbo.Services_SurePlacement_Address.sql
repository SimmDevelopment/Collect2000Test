CREATE TABLE [dbo].[Services_SurePlacement_Address]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[Firstname] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameSuffix] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Confidence] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Address] ADD CONSTRAINT [PK_Services_SurePlacement_Address] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
