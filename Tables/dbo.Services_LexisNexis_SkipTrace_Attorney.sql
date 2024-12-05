CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Attorney]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[RecordId] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agency] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Batch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentId] [int] NULL,
[LawFirm] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney Street Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyState] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientId] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyZip] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_SkipTrace_Attorney] ADD CONSTRAINT [PK_Services_SurePlacement_Attorney] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
