CREATE TABLE [dbo].[Services_IdInfo_Death]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[Deceased] [bit] NULL,
[Ssn] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameSuffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeathVerified] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfDeath] [datetime] NULL,
[DateOfBirth] [datetime] NULL,
[ResidenceCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResidenceZipcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPaymentZipcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_IdInfo_Death] ADD CONSTRAINT [PK_Services_IdInfo_Death] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
