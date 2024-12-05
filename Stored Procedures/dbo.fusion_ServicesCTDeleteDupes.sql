SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_ServicesCTDeleteDupes]
AS
BEGIN
	SET NOCOUNT ON;

	Declare @errorId int
	Declare @tranzName varchar(32)
	
	set @errorId = 0
	set @tranzName = 'DeleteServicesCTDupes'
	
	Declare @err int

	BEGIN TRANSACTION @tranzName

	--if not exists(Select * from INFORMATION_SCHEMA.TABLES Where TABLE_NAME ='Services_CT_Deleted')
	--BEGIN
		Exec @err = fusion_ServicesCTCreateDeletedDupesTable
		SELECT @err = coalesce(nullif(@err, 0), @@error)
		IF @err <> 0 GOTO ERRORHANDLER
	--END

	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	
	-------------------------------------------------------------------------------------------------------------
	Insert into Services_CT_Deleted
		Select * From Services_CT with (nolock) where id not in (
			Select Max(id)
			From Services_CT with (nolock)
			Group by
			[RequestId],[CustTriggerDisplayCode],[Reserve_FCRA],[Filler03],[Filler04],
			[CustomerTextData],[Filler05],[KindOfBusiness],[Date],[Amount],[ConsumerStatementIndicator],
			[AccountNumber],[CollectionGroupID],[Filler01],[NoticeDate],[Filler02],[BankruptcyChapter],
			[PublicRecordType],[PublicRecordStatus],[DateOpened],[TradeCurrentBalance],[TradeCreditLimit],[BankruptcyChapter7],
			[BankruptcyChapter11],[BankruptcyChapter12],[BankruptcyWithdrawy],[AccountClosed_BU],[AccountClosed_CB],
			[BankruptcyChapter7_CC],[BankruptcyChapter11_CD],[BankruptcyChapter12_CE]
		)
	
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	
	Delete from Services_CT where id not in (
		Select Max(id)
		From Services_CT with (nolock)
		Group by 
		[RequestId],[CustTriggerDisplayCode],[Reserve_FCRA],[Filler03],[Filler04],
		[CustomerTextData],[Filler05],[KindOfBusiness],[Date],[Amount],[ConsumerStatementIndicator],
		[AccountNumber],[CollectionGroupID],[Filler01],[NoticeDate],[Filler02],[BankruptcyChapter],
		[PublicRecordType],[PublicRecordStatus],[DateOpened],[TradeCurrentBalance],[TradeCreditLimit],[BankruptcyChapter7],
		[BankruptcyChapter11],[BankruptcyChapter12],[BankruptcyWithdrawy],[AccountClosed_BU],[AccountClosed_CB],
		[BankruptcyChapter7_CC],[BankruptcyChapter11_CD],[BankruptcyChapter12_CE]
	)
	
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	-------------------------------------------------------------------------------------------------------------
	Insert into Services_CT_Address_Deleted
		Select * From Services_CT_Address with (nolock) where id not in (
			Select Max(id)
			From Services_CT_Address with (nolock)
			Group by
			[RequestID],[RecordType],[AddrSegIndicator],[PrimaryStreetID],[PreDirection],
			[StreetName],[PostDirection],[StreetSuffix],[UnitType],[UnitID],[City],
			[State],[Zipcode],[NonStandardAddress],[Filler01],[CensusGeoCode],[GeoStateCode],
			[GeoCountryCode],[FirstReportedDate],[LastUpdatedDate],[OriginationCode],
			[NumberTimesReported],[Filler02],[PersonName],[PersonPhone]
		)

	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER

	Delete from Services_CT_Address where id not in (
			Select Max(id)
			From Services_CT_Address with (nolock)
			Group by
			[RequestID],[RecordType],[AddrSegIndicator],[PrimaryStreetID],[PreDirection],
			[StreetName],[PostDirection],[StreetSuffix],[UnitType],[UnitID],[City],
			[State],[Zipcode],[NonStandardAddress],[Filler01],[CensusGeoCode],[GeoStateCode],
			[GeoCountryCode],[FirstReportedDate],[LastUpdatedDate],[OriginationCode],
			[NumberTimesReported],[Filler02],[PersonName],[PersonPhone]
	)

	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	-------------------------------------------------------------------------------------------------------------
	
	Insert into Services_CT_Address_Deleted
		Select * From Services_CT_Address with (nolock) where id not in (
		Select Max(id)
		From Services_CT_Address with (nolock)
		Group by
			[RequestID],[RecordType],[AddrSegIndicator],[PrimaryStreetID],[PreDirection],
			[StreetName],[PostDirection],[StreetSuffix],[UnitType],[UnitID],[City],[State],
			[Zipcode],[NonStandardAddress],[Filler01],[CensusGeoCode],[GeoStateCode],[GeoCountryCode],
			[FirstReportedDate],[LastUpdatedDate],[OriginationCode],[NumberTimesReported],[Filler02],[PersonName],[PersonPhone]
		)
	
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER

	Delete from Services_CT_Address where id not in (
		Select Max(id)
		From Services_CT_Address with (nolock)
		Group by
			[RequestID],[RecordType],[AddrSegIndicator],[PrimaryStreetID],[PreDirection],
			[StreetName],[PostDirection],[StreetSuffix],[UnitType],[UnitID],[City],[State],
			[Zipcode],[NonStandardAddress],[Filler01],[CensusGeoCode],[GeoStateCode],[GeoCountryCode],
			[FirstReportedDate],[LastUpdatedDate],[OriginationCode],[NumberTimesReported],[Filler02],[PersonName],[PersonPhone]
		)
	
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	
	-------------------------------------------------------------------------------------------------------------

	Insert into Services_CT_Person_Deleted
		Select * From Services_CT_Person with (nolock) where id not in (
			Select Max(id)
			From Services_CT_Person with (nolock)
			Group by
				[RequestID],[RecordType],[Surname],[FirstName],[MiddleName],[SecondSurname],[GenerationCode],
				[HouseNumber],[StreetDir],[Street1],[Street2],[City],[State],[Zipcode],[SSN],[DOB]
		)

	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER

	Delete from Services_CT_Person where id not in (
		Select Max(id)
		From Services_CT_Person with (nolock)
		Group by
			[RequestID],[RecordType],[Surname],[FirstName],[MiddleName],[SecondSurname],[GenerationCode],
			[HouseNumber],[StreetDir],[Street1],[Street2],[City],[State],[Zipcode],[SSN],[DOB]
	)
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	-------------------------------------------------------------------------------------------------------------

	Insert into Services_CT_Phone_Deleted
		Select * From Services_CT_Phone with (nolock) where id not in (
			Select Max(id)
			From Services_CT_Phone with (nolock)
			Group by
				[RequestID],[SegmentIndicator],[Telephone],[Source],[Type],[ToFileDate],[UpdateDate],[Filler01]
		)
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER

	Delete from Services_CT_Phone where id not in (
		Select Max(id)
		From Services_CT_Phone with (nolock)
		Group by
			[RequestID],[SegmentIndicator],[Telephone],[Source],[Type],[ToFileDate],[UpdateDate],[Filler01]
	)

	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER	
	-------------------------------------------------------------------------------------------------------------

	COMMIT TRANSACTION @tranzName

	return
	ERRORHANDLER:
	if( @errorId != 0 )
	BEGIN	
		ROLLBACK TRANSACTION @tranzName
		RAISERROR (N'Unable to delete duplicate Services_CT entries. Error id %d',15,1, @errorId);
	END
END
GO
