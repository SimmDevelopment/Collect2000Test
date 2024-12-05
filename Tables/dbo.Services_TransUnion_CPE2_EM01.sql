CREATE TABLE [dbo].[Services_TransUnion_CPE2_EM01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployerName] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Occupation] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateHired] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateSeparated] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateVerified-Reported] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateVerified-ReportedCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Income] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayBasis] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_EM01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_EM01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
