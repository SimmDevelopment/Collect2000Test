CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Deceased]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[RecordId] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agency] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Batch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentId] [int] NULL,
[MatchCode] [int] NULL,
[GivenNameAlert] [int] NULL,
[SurnameAlert] [int] NULL,
[Gender Alert] [int] NULL,
[SubUnitAlert] [int] NULL,
[Reserved1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[DOD] [datetime] NULL,
[DOBCode] [int] NULL,
[Reserved2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateLastKnown] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountyFlag] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientId] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_SkipTrace_Deceased] ADD CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Deceased] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
