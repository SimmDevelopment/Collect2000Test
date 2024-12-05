CREATE TABLE [dbo].[Services_LexisNexis_Bankruptcy]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[Screen] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseNumber] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chapter] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileDate] [datetime] NULL,
[StatusDate] [datetime] NULL,
[DispositionCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityFiled] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateFiled] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business1] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business2] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business3] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorsCity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorsState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ECOA] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LawFirm] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyName] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyAddress] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyCity] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyZip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[341Date] [datetime] NULL,
[341Time] [datetime] NULL,
[341Location] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteeAddress] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteeCity] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteeState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteeZip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteePhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JudgesInitials] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Funds] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BarDate] [datetime] NULL,
[MatchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDistrict] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtAddress1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtAddress2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtMailingCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtZip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VoluntaryInvoluntaryDismissal] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProofofClaimDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Bankruptcy] ADD CONSTRAINT [PK_Services_LexNexBKY] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
