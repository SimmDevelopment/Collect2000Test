CREATE TABLE [dbo].[DolanBankoDeceased]
(
[Number] [int] NULL,
[Seq] [int] NULL,
[Serviceid] [int] NULL,
[SavedDate] [datetime] NULL,
[Screen] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseNumber] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chapter] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DispositionCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityFiled] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateFiled] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Middlename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lastname] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business1] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bussines2] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bussines3] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorsCity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorsState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ecoa] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lawFirm] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyName] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyAddress] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorneycity] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorneystate] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorneyzipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[The341Date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[The341Time] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[The341Locaton] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trustee] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteeAddress] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteeCity] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteeZipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrusteePhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JudgesInt] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Funds] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BarDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[matchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtDistrict] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtAddress1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtAddress2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtZip] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CourtPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VID] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProofofClaimdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Address'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'AttorneyAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Attorneycity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'AttorneyName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'AttorneyPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Attorneystate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Attorneyzipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'BarDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Business'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Business1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Bussines2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Bussines3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CaseNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Chapter'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CityFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'ClientCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'County'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CourtAddress1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CourtAddress2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CourtCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CourtDistrict'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CourtPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'CourtZip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'DebtorPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'DebtorsCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'DebtorsState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'DispositionCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Ecoa'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'FileDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Funds'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'JudgesInt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Lastname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'lawFirm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'matchCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Middlename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'ProofofClaimdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'SavedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Screen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Serviceid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'StateFiled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'StatusDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'The341Date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'The341Locaton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'The341Time'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Trustee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'TrusteeAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'TrusteeCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'TrusteePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'TrusteeZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'VID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'DolanBankoDeceased', 'COLUMN', N'Zipcode'
GO
