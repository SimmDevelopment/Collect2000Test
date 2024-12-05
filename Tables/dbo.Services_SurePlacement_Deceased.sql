CREATE TABLE [dbo].[Services_SurePlacement_Deceased]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[MatchCode] [int] NULL,
[NameFirst] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameLast] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[DOD] [datetime] NULL,
[ZipGvtBenefit] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipDeathBenefit] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Deceased] ADD CONSTRAINT [PK_Services_SurePlacement_Deceased] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
