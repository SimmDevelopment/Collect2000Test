CREATE TABLE [dbo].[Services_LexisNexis_Deceased]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[FirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdFirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DecdLastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofBirth] [datetime] NULL,
[DateofDeath] [datetime] NULL,
[MatchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Deceased] ADD CONSTRAINT [PK_Services_LexisNexis_Deceased] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
