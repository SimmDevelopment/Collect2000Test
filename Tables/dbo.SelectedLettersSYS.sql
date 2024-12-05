CREATE TABLE [dbo].[SelectedLettersSYS]
(
[number] [int] NULL,
[Name] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSZ] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received] [smalldatetime] NULL,
[lastpaid] [smalldatetime] NULL,
[userdate1] [smalldatetime] NULL,
[userdate2] [smalldatetime] NULL,
[userdate3] [smalldatetime] NULL,
[customer] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customername] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customercombo] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromiseAmount] [money] NULL,
[PromiseDue] [smalldatetime] NULL,
[Company] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyAddr1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyAddr2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyCity] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyState] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyZip] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyCombo] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyPhone] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyFax] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company800Phone] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custstreet1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custstreet2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustCity] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustZipcode] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustCSZ] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustContact] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custphone] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custstate] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current0] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current1] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current2] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current3] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current4] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current5] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current6] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current7] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current8] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current9] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current10] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid1] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid2] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid3] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid4] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid5] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid6] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid7] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid8] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid9] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid10] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original1] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original2] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original3] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original4] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original5] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original6] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original7] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original8] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original9] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original10] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[desk] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LNF] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payhist1] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payhist2] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
