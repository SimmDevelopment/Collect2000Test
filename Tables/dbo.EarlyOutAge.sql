CREATE TABLE [dbo].[EarlyOutAge]
(
[Number] [int] NOT NULL,
[Bucket0_29] [money] NOT NULL CONSTRAINT [DF_EarlyOutAge_Bucket0_29] DEFAULT (0),
[Bucket30_59] [money] NOT NULL CONSTRAINT [DF_EarlyOutAge_Bucket30_59] DEFAULT (0),
[Bucket60_89] [money] NOT NULL CONSTRAINT [DF_EarlyOutAge_Bucket60_89] DEFAULT (0),
[Bucket90_119] [money] NOT NULL CONSTRAINT [DF_EarlyOutAge_Bucket90_119] DEFAULT (0),
[Bucket120_149] [money] NOT NULL CONSTRAINT [DF_EarlyOutAge_Bucket120_149] DEFAULT (0),
[Bucket150_179] [money] NOT NULL CONSTRAINT [DF_EarlyOutAge_Bucket150_179] DEFAULT (0),
[Bucket180Plus] [money] NOT NULL CONSTRAINT [DF_EarlyOutAge_Bucket180Plus] DEFAULT (0),
[Cycle_Date] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_EarlyOutAge_Cycle_Date] DEFAULT (''),
[Credit_Limit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_EarlyOutAge_Credit_Limit] DEFAULT (''),
[Contract_Date] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_EarlyOutAge_Contract_Date] DEFAULT (''),
[Loan_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_EarlyOutAge_Loan_Type] DEFAULT (''),
[Current_Due] [money] NOT NULL,
[Last_Updated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EarlyOutAge] ADD CONSTRAINT [PK_EarlyOutAge] PRIMARY KEY CLUSTERED ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
