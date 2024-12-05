CREATE TABLE [dbo].[Services_SurePlacement]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[CustomerAccount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone1] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone2] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone3] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[AcctOpenDate] [datetime] NULL,
[DriversLicense] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MVRPlateNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtType] [int] NULL,
[OriginalChargeOffDate] [datetime] NULL,
[LastPaymentDate] [datetime] NULL,
[ChargeOffAmount] [money] NULL,
[CurrentBalance] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement] ADD CONSTRAINT [PK_Services_SurePlacement] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
