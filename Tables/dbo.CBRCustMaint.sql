CREATE TABLE [dbo].[CBRCustMaint]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accttype] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[minbalance] [money] NOT NULL,
[waitdays] [int] NOT NULL,
[RptEquifax] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RptExperian] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RptTransUnion] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RptInnovis] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
