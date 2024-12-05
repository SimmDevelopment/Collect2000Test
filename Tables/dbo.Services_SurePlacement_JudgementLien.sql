CREATE TABLE [dbo].[Services_SurePlacement_JudgementLien]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[TotalCount] [int] NULL,
[DebtorName] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilingType] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[FilingDate] [datetime] NULL,
[ReleaseDate] [datetime] NULL,
[Creditor] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JLSeqNum] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_JudgementLien] ADD CONSTRAINT [PK_Services_SurePlacement_JudgementLien] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
