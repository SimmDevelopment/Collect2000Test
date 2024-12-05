CREATE TABLE [dbo].[Services_FirstData_FastBatch_Relatives]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[seq] [int] NULL,
[NumberofRelativesReturned] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Relative] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativeAddress] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativeCity] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativeState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativeZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativePhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativeLastReportedDateCCYYMM] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativeFirstReportedDateCCYYMM] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RelativeDateofBirthMMCCYY] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DegreeofRelative] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_Relatives] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_Relatives] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
