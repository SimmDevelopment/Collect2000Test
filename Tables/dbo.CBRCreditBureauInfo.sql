CREATE TABLE [dbo].[CBRCreditBureauInfo]
(
[CreditBureau] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SubscriberNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactFax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactAddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPsite] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPusername] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FTPpassword] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
