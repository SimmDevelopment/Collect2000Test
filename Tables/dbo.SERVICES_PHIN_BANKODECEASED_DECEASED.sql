CREATE TABLE [dbo].[SERVICES_PHIN_BANKODECEASED_DECEASED]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[Client_Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_SSN] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_FNAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_MNAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_LNAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_SUFFIX] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_DEATHDATE] [datetime] NULL,
[SSA_BIRTHDATE] [datetime] NULL,
[SSA_STATE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_ZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_LSPZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSA_VERIFYCODE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appended_street_address1] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appended_city1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appended_state1] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appended_zipcode1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appended_County1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Matchstring] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Matchcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SERVICES_PHIN_BANKODECEASED_DECEASED] ADD CONSTRAINT [PK_SERVICES_PHIN_BANKODECEASED_DECEASED] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
