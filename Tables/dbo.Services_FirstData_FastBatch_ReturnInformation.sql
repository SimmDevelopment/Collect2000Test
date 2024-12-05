CREATE TABLE [dbo].[Services_FirstData_FastBatch_ReturnInformation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[Seq] [int] NULL,
[OutputName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutputAddress] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutputCity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutputState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Output5DigitZIPCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Output4DigitAddOnCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReturnedPhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastReportDate] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstReportDate] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofBirth] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeceasedFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_ReturnInformation] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_ReturnInformation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
