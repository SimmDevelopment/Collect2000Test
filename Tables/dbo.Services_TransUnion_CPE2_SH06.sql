CREATE TABLE [dbo].[Services_TransUnion_CPE2_SH06]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubjectIdentifier] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileNumber] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileHitStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SuppressionIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSNDeceasedIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_SH06] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_SH06] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
