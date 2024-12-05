CREATE TABLE [dbo].[ztemppresidioBANKInfo]
(
[AcctID] [int] NOT NULL,
[DebtorID] [tinyint] NOT NULL,
[ABANumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountAddress1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountAddress2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountState] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountZipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountVerified] [bit] NULL,
[LastCheckNumber] [int] NULL,
[BankName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankState] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
