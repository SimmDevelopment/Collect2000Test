CREATE TABLE [dbo].[StateRestrictions]
(
[abbreviation] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Restricted] [bit] NOT NULL,
[LicenseStatus] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Advisory] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Warning] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PermitSurcharge] [bit] NOT NULL CONSTRAINT [def_StateRestrictions_PermitSurcharge] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StateRestrictions] ADD CONSTRAINT [PK_StateRestrictions] PRIMARY KEY CLUSTERED ([abbreviation]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
