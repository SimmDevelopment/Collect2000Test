CREATE TABLE [dbo].[Services_OlbAffr]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[SH01FileHitIndicator] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SH04FileMatchIndicator] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prefix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaternalName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Predirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetName] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postdirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApartmentNumber] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIPCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressDateReported] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SocialSecurityNumber] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofBirth] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneAreaCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneExtension] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deceasedflag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FrozenFlagIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FactAct_AddressType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FactAct_AddressCondition] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Consumerstatementflag01] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Consumerstatementflag02] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Blanks] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_OlbAffr] ADD CONSTRAINT [PK_Services_OlbAffr] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
