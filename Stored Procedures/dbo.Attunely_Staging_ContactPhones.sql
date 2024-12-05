SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_Staging_ContactPhones]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @Updated BIT = 0

	UPDATE Attunely_ContactPhones SET 
		[PhoneNumber] = m.PhoneNumber           
		,[Party_Id] = COALESCE(tv.ValidParty, 'ContactParty|debtor')
        ,[OtherPartyDescription] = tv.OtherPartyDescription
        ,[EndpointType_Id] = COALESCE(tv.ValidEndpointType, 'PhoneEndpointType|unknown')
        ,[Status_Id] = COALESCE(sv.ValidStatus, 'ContactStatus|unknown_status')
        ,[Source_Id] = COALESCE(tv.ValidSource, 'ContactSource|unknown_source')
        ,[RecordTime] = GETUTCDATE()
	FROM Attunely_ContactPhones p
		INNER JOIN Phones_Master m
			ON p.PhoneKey = m.MasterPhoneID
		LEFT OUTER JOIN Attunely_Helper_PhoneTypeToValidValue tv
			ON m.PhoneTypeID = tv.PhoneTypeId
		LEFT OUTER JOIN Attunely_Helper_PhoneStatusToValidValue sv
			ON m.PhoneStatusID = sv.PhoneStatusId
	WHERE
		p.[PhoneNumber] NOT LIKE m.PhoneNumber           
		OR [Party_Id] NOT LIKE COALESCE(tv.ValidParty, 'ContactParty|debtor')
        OR p.[OtherPartyDescription] NOT LIKE tv.OtherPartyDescription
        OR [EndpointType_Id] NOT LIKE COALESCE(tv.ValidEndpointType, 'PhoneEndpointType|unknown')
        OR [Status_Id] NOT LIKE COALESCE(sv.ValidStatus, 'ContactStatus|unknown_status')
        OR [Source_Id] NOT LIKE COALESCE(tv.ValidSource, 'ContactSource|unknown_source')
		
	IF @@ROWCOUNT > 0 SET @Updated = 1

	INSERT INTO [dbo].[Attunely_ContactPhones]
           ([AccountKey]
           ,[PhoneKey]
           ,[PhoneNumber]
           ,[Party_Id]
           ,[OtherPartyDescription]
           ,[EndpointType_Id]
           ,[Status_Id]
           ,[Source_Id]
           ,[RecordTime]
           ,[Deleted])
	SELECT DISTINCT 
		Number,
		MasterPhoneID,
		m.PhoneNumber,
		COALESCE(tv.ValidParty, 'ContactParty|debtor'),
		tv.OtherPartyDescription,
		COALESCE(tv.ValidEndpointType, 'PhoneEndpointType|unknown'),
		COALESCE(sv.ValidStatus, 'ContactStatus|unknown_status'),
		COALESCE(tv.ValidSource, 'ContactSource|unknown_source'),
		GETUTCDATE(),
		null
	FROM Attunely_AccountStubs a
		INNER JOIN Phones_Master m
			On a.AccountKey = m.Number
		LEFT OUTER JOIN Attunely_ContactPhones p
			ON m.MasterPhoneID = p.PhoneKey
		LEFT OUTER JOIN Attunely_Helper_PhoneTypeToValidValue tv
			ON m.PhoneTypeID = tv.PhoneTypeId
		LEFT OUTER JOIN Attunely_Helper_PhoneStatusToValidValue sv
			ON m.PhoneStatusID = sv.PhoneStatusId
	WHERE p.AccountKey IS NULL
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	SELECT @Updated
END
GO
