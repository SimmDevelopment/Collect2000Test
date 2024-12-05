SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- ALTER  date: 11/03/2006
-- Description:	Deletes dupes from Services_CT table
-- =============================================
CREATE PROCEDURE [dbo].[fusion_ServicesCTCreateDeletedDupesTable]
AS
BEGIN
	SET NOCOUNT ON;
	if not exists(Select * from INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Services_CT_Deleted')
	BEGIN
		CREATE TABLE [dbo].[Services_CT_Deleted](
			[ID] [int] NOT NULL,
			[RequestId] [int] NULL,
			[CustTriggerDisplayCode] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[KindOfBusiness] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Date] [datetime] NULL,
			[Amount] [decimal](18, 0) NULL,
			[ConsumerStatementIndicator] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[AccountNumber] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[CollectionGroupID] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Filler01] [varchar](62) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[NoticeDate] [datetime] NULL,
			[Filler02] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyChapter] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[PublicRecordType] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[PublicRecordStatus] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[DateOpened] [datetime] NULL,
			[TradeCurrentBalance] [decimal](18, 0) NULL,
			[TradeCreditLimit] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyChapter7] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyChapter11] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyChapter12] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyWithdrawy] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[AccountClosed_BU] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[AccountClosed_CB] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyChapter7_CC] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyChapter11_CD] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[BankruptcyChapter12_CE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Reserve_FCRA] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Filler03] [varchar](22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Filler04] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[CustomerTextData] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Filler05] [varchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		) ON [PRIMARY]
	END
	if not exists(Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Services_CT_Address_Deleted')
	BEGIN
		CREATE TABLE [Services_CT_Address_Deleted] (
			[ID] [int],
			[RequestID] [int] NULL ,
			[RecordType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[AddrSegIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[PrimaryStreetID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[PreDirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[StreetName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[PostDirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[StreetSuffix] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[UnitType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[UnitID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[City] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Zipcode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[NonStandardAddress] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Filler01] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[CensusGeoCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[GeoStateCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[GeoCountryCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[FirstReportedDate] [datetime] NULL ,
			[LastUpdatedDate] [datetime] NULL ,
			[OriginationCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[NumberTimesReported] [int] NULL ,
			[Filler02] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[PersonName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[PersonPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
		) ON [PRIMARY]
	END
	if not exists(Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Services_CT_EmployerAddress')
	BEGIN
		CREATE TABLE [Services_CT_EmployerAddress_Deleted] (
			[ID] [int],
			[RequestID] [int] NOT NULL ,
			[SegmentIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Name] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Street1] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Street2] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Street3] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Zipcode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[FirstReportedDate] [datetime] NULL ,
			[LastReportedDate] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[OriginationCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Filler] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		) ON [PRIMARY]
	END
	
	if not exists(Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Services_CT_Person')
	BEGIN
		CREATE TABLE [Services_CT_Person_Deleted] (
			[ID] [int],
			[RequestID] [int] NULL ,
			[RecordType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Surname] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[FirstName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[MiddleName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[SecondSurname] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[GenerationCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[HouseNumber] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[StreetDir] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Street1] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Street2] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[City] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Zipcode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[DOB] [datetime] NULL ,
		) ON [PRIMARY]
	END
	if not exists(Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Services_CT_Phone')
	BEGIN
		CREATE TABLE [Services_CT_Phone_Deleted] (
			[ID] [int],
			[RequestID] [int] NULL ,
			[SegmentIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Telephone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Source] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
			[ToFileDate] [datetime] NULL ,
			[UpdateDate] [datetime] NULL ,
			[Filler01] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		) ON [PRIMARY]
	END

END
GO
