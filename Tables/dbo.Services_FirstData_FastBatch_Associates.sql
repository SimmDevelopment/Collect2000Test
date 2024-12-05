CREATE TABLE [dbo].[Services_FirstData_FastBatch_Associates]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[seq] [int] NULL,
[NumberofAssociatesReturned] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Associate] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociateAddress] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociateCity] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociateState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociateZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociatePhoneNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociateLastReportedDateCCYYMM] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociateFirstReportedDateCCYYMM] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssociateDateofBirthMMCCYY] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler1] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler2] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_FirstData_FastBatch_Associates] ADD CONSTRAINT [PK_Services_FirstData_FastBatch_Associates] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
