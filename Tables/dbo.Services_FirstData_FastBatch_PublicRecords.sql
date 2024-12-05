CREATE TABLE [dbo].[Services_FirstData_FastBatch_PublicRecords]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[PublicInformationResultCodes] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeceasedMatchResultCodes] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CorrectionalMatchResultCodes] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyCount] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxLienCount] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JudgmentCount] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchedSSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_PublicRecords] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_PublicRecords] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
