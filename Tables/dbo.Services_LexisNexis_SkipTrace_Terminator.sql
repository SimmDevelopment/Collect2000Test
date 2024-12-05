CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_Terminator]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[RecordId] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agency] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Batch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentId] [int] NULL,
[Custom] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessDate] [datetime] NULL,
[C] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[D] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[V] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[W] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankoSkipHit] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientId] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_SkipTrace_Terminator] ADD CONSTRAINT [PK_Services_LexisNexis_SkipTrace_Terminator] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
