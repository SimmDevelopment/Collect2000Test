CREATE TABLE [dbo].[Services_FirstData_FastBatch_AddressHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[seq] [int] NULL,
[NumberofPreviousAddressesReturned] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousAddressName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousAddress] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousAddressCity] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousAddressLastReportedDateCCYYMM] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousAddressFirstReportedDateCCYYMM] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousAddressSSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_AddressHistory] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_AddressHistory] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
