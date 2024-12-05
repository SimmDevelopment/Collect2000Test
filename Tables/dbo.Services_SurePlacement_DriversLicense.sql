CREATE TABLE [dbo].[Services_SurePlacement_DriversLicense]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[FirstName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateIssueed] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[Sex] [int] NULL,
[Height] [int] NULL,
[Weight] [int] NULL,
[LicenseType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttnFlag] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Expires] [datetime] NULL,
[Issued] [datetime] NULL,
[HairColor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EyeColor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Endorsements] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_DriversLicense] ADD CONSTRAINT [PK_Services_SurePlacement_DriversLicense] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
