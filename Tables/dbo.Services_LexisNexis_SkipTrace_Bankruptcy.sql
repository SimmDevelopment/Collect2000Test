CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Bankruptcy]
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
[Subunit Alert] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Disposition Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chapter Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AliasFlag] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilingDate] [datetime] NULL,
[CaseNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ECOACode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityFiled] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateFiled] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountyFiled] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountyCodeFiled] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientId] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_SkipTrace_Bankruptcy] ADD CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Bankruptcy] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
