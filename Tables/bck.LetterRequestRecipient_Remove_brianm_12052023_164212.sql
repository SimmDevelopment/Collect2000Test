CREATE TABLE [bck].[LetterRequestRecipient_Remove_brianm_12052023_164212]
(
[historyid] [int] NOT NULL,
[LetterRequestRecipientID] [int] NOT NULL,
[LetterRequestID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[Seq] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[CustomerCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorAttorney] [bit] NOT NULL,
[DateCreated] [datetime] NOT NULL,
[DateUpdated] [datetime] NOT NULL,
[AttorneyID] [int] NULL,
[AltRecipient] [bit] NOT NULL,
[AltName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltBusinessName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltState] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltZipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltFax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecureRecipientID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
