CREATE TABLE [dbo].[Custom_Equabli_Dec_Scrub_Seed_Data]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PriFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriSSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriDOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoFirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoLastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoSSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoDOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creditor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrBalance] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Dec_Scrub_Seed_Data] ADD CONSTRAINT [PK_Custom_Equabli_Dec_Scrub_Seed_Data] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
