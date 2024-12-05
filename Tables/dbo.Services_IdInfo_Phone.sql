CREATE TABLE [dbo].[Services_IdInfo_Phone]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[AddressType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListingName1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State1] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip1] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber1] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListingName2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State2] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip2] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber2] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListingName3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State3] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip3] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber3] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_IdInfo_Phone] ADD CONSTRAINT [PK_Services_IdInfo_Phone] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
