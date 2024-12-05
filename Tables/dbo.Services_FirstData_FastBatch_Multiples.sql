CREATE TABLE [dbo].[Services_FirstData_FastBatch_Multiples]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[seq] [int] NULL,
[NumberofMultiplesReturned] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleAddress] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleCity] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleZipCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultiplePhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleLastReportDateCCYYMM] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleFirstReportDateCCYYMM] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleDateofBirthCCYYMM] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MultipleDeceasedFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_Multiples] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_Multiples] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
