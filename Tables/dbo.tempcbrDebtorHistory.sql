CREATE TABLE [dbo].[tempcbrDebtorHistory]
(
[id] [int] NOT NULL,
[recordID] [int] NOT NULL,
[dateReported] [datetime] NOT NULL,
[debtorID] [int] NOT NULL,
[debtorSeq] [int] NOT NULL,
[accountID] [int] NOT NULL,
[transactionType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[surname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[generationCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dob] [datetime] NULL,
[phone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ecoaCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[informationIndicator] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[countryCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressIndicator] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[residenceCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
