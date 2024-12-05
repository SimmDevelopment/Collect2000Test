CREATE TABLE [dbo].[Services_LexisNexis_SkipTrace_SSN]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[RecordId] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agency] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Batch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentId] [int] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IncomeCode] [int] NULL,
[Reserved2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LengthResidence] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutputPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientId] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordDate] [datetime] NULL,
[Reserved7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_SkipTrace_SSN] ADD CONSTRAINT [PK_Services_LexisNexis_SkipTrace_SSN] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
