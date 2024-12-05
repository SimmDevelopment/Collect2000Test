SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Receiver_SelectDemographicUpdatesReadyForFile]
@clientid int
as
begin

	DECLARE @lastFileSentDT datetime
	select @lastFileSentDT = dbo.Receiver_GetLastFileDate(8,@clientid)

	DECLARE @AIMClientVersion varchar(10)
	DECLARE @ClientOnOlderVersion bit

	SELECT @AIMClientVersion = [AIMClientVersion]
	FROM Receiver_Client WHERE ClientID = @clientid
	
	--Changing the Condition to accomodate the Version value. In all the Cider Versions(SU07,08,09) and Malt the AIMClientVersion will not be 8.
	IF(LEFT(RTRIM(LTRIM(@AIMClientVersion)),1) = '8')
	BEGIN
		SET @ClientOnOlderVersion = 1
	END
	ELSE
	BEGIN
		SET @ClientOnOlderVersion = 0
	END

--Removing AUPH from the process, will only use AUPP going forward

	SELECT TOP 0
		'AUPH' as record_type,
		senderdebtorid as debtor_number,
		rr.sendernumber as file_number,
		phonetype as phone_type,
		oldnumber as old_number,
		CASE WHEN newnumber = oldnumber THEN '' ELSE newnumber END as new_number,
		datechanged as date_updated
	FROM
		phonehistory p  with (nolock)join receiver_debtorreference r
		on p.debtorid = r.receiverdebtorid join master m  with (nolock) on
		m.number = p.accountid join receiver_reference rr  with (nolock) on m.number = rr.receivernumber
	WHERE
		r.clientid = @clientid and
		p.datechanged > @lastFileSentDT and
		p.userchanged <> 'AIM'
		--and not (newnumber = '' or newnumber is null)  REMOVED SO WE CAN ATTEMPT AN UPDATE TO THE OLD NUMBER AS BAD
		and m.qlevel < '999'
		and replace(p.newnumber,'0','') != ''



	SELECT 
		'AUAD' as record_type,
		senderdebtorid as debtor_number,
		rr.sendernumber as file_number,
		oldstreet1 as old_street1,
		oldstreet2 as old_street2,
		oldcity as old_city,
		oldstate as old_state,
		oldzipcode as old_zipcode,
		newstreet1 as new_street1,
		newstreet2 as new_street2,
		newcity as new_city,
		newstate as new_state,
		newzipcode as new_zipcode,
		a.datechanged as date_updated
	FROM
		addresshistory a  with (nolock) join receiver_debtorreference r
		on a.debtorid = r.receiverdebtorid join master m  with (nolock)
		on m.number = a.accountid join receiver_reference rr  with (nolock) on
		rr.receivernumber = m.number
	WHERE
		r.clientid = @clientid and
		a.datechanged > @lastFileSentDT and
		a.userchanged <> 'AIM'
		and not ((newstreet1 = '' or newstreet1 is null) and (newstreet2 = '' or newstreet2 is null) and (newcity = '' or newcity is null) and (newstate = '' or newstate is null) and (newzipcode = '' or newzipcode is null))
		and m.qlevel < '999'

	IF(@ClientOnOlderVersion = 1)
	BEGIN
		-- Added by KAR on 02/25/2010
		SELECT TOP 0
				'AUPP' as record_type,
				senderdebtorid as debtor_number,
				rr.sendernumber as file_number,
				Relationship as relationship,
				PhoneTypeID as phone_type_id,
				PhoneStatusID as phone_status_id,
				OnHold as on_hold,
				PhoneNumber as phone_number,
				PhoneExt as phone_ext,
				PhoneName as phone_name,
				CASE WHEN s.ManifestID IS NOT NULL THEN s.Description WHEN u.LoginName IS NOT NULL THEN 'User' ELSE pm.LoginName
				END as source	
				
			FROM Phones_Master pm WITH (NOLOCK) JOIN Receiver_DebtorReference dr WITH (NOLOCK) ON
			pm.DebtorID = dr.ReceiverDebtorID JOIN [Master] m WITH (NOLOCK) ON m.Number = pm.Number
			JOIN Receiver_Reference rr WITH (NOLOCK) ON m.Number = rr.ReceiverNumber
			LEFT OUTER JOIN ServiceHistory sh WITH (NOLOCK) ON sh.RequestID = pm.RequestID
			LEFT OUTER JOIN Services s WITH (NOLOCK) ON sh.serviceid = s.serviceid
			LEFT OUTER JOIN Users u WITH (NOLOCK) ON pm.LoginName = u.LoginName
			WHERE
			rr.ClientID = @clientid AND
			pm.DateAdded > @lastFileSentDT AND
			pm.LoginName <> 'AIM' AND pm.LoginName <> 'SYNC' AND pm.LoginName <> 'CONVERSION' AND
			NOT (pm.PhoneNumber IS NULL OR pm.PhoneNumber = '' OR replace(pm.phonenumber,'0','') = '')
			AND m.qlevel < '999' AND pm.DateAdded > m.Received
			AND pm.NearbyContactID IS NULL AND pm.PhoneTypeId <=6
		-- Otherwise we don't have Phones_Master so adjust accordingly KAR on 02/25/2010
	END
	ELSE IF @AIMClientVersion = '10.7'
	BEGIN
		SELECT
				'AUPP' as record_type,
				senderdebtorid as debtor_number,
				rr.sendernumber as file_number,
				Relationship as relationship,
				PhoneTypeID as phone_type_id,
				PhoneStatusID as phone_status_id,
				OnHold as on_hold,
				PhoneNumber as phone_number,
				PhoneExt as phone_ext,
				PhoneName as phone_name,
				CASE WHEN s.ManifestID IS NOT NULL THEN s.Description WHEN u.LoginName IS NOT NULL THEN 'User' ELSE pm.LoginName
				END as source	
				
			FROM Phones_Master pm WITH (NOLOCK) JOIN Receiver_DebtorReference dr WITH (NOLOCK) ON
			pm.DebtorID = dr.ReceiverDebtorID JOIN [Master] m WITH (NOLOCK) ON m.Number = pm.Number
			JOIN Receiver_Reference rr WITH (NOLOCK) ON m.Number = rr.ReceiverNumber
			LEFT OUTER JOIN ServiceHistory sh WITH (NOLOCK) ON sh.RequestID = pm.RequestID
			LEFT OUTER JOIN Services s WITH (NOLOCK) ON sh.serviceid = s.serviceid
			LEFT OUTER JOIN Users u WITH (NOLOCK) ON pm.LoginName = u.LoginName
			WHERE
			rr.ClientID = @clientid AND
			(pm.DateAdded > @lastFileSentDT OR pm.LastUpdated > @lastFileSentDT) AND 
			(pm.LoginName <> 'AIM' OR pm.UpdatedBy <> 'AIM') AND (pm.LoginName <> 'SYNC' OR pm.UpdatedBy <> 'SYNC') AND (pm.LoginName <> 'CONVERSION' OR pm.UpdatedBy <> 'CONVERSION') AND
			NOT (pm.PhoneNumber IS NULL OR pm.PhoneNumber = '' OR replace(pm.phonenumber,'0','') = '')
			AND m.qlevel < '999' AND pm.DateAdded > m.Received
			AND pm.NearbyContactID IS NULL AND pm.PhoneTypeId <=6
	END
	ELSE
	BEGIN
		-- Modified KAR on 02/25/2010
		SELECT
				'AUPP' as record_type,
				senderdebtorid as debtor_number,
				rr.sendernumber as file_number,
				Relationship as relationship,
				PhoneTypeID as phone_type_id,
				PhoneStatusID as phone_status_id,
				OnHold as on_hold,
				PhoneNumber as phone_number,
				PhoneExt as phone_ext,
				PhoneName as phone_name,
				CASE WHEN s.ManifestID IS NOT NULL THEN s.Description WHEN u.LoginName IS NOT NULL THEN 'User' ELSE pm.LoginName
				END as source,
				CASE WHEN pc.AllowManualCall = 1 THEN 'Y' ELSE 'N' END AS AllowManualCalling, 
				CASE WHEN pc.AllowAutoDialer = 1 THEN 'Y' ELSE 'N' END AS AllowAutoDialer,
				CASE WHEN pc.AllowFax = 1 THEN 'Y' ELSE 'N' END AS AllowFax,
				CASE WHEN pc.AllowText = 1 THEN 'Y' ELSE 'N' END AS AllowText,
				CAST(pc.WrittenConsent AS VARCHAR(1)) AS WrittenConsent,
				CAST(pc.ObtainedFrom AS nvarchar(100)) AS ObtainedFrom, 
				pc.EffectiveDate AS EffectiveDate, 
				CAST(pc.comment AS nvarchar(120)) AS Comment,
						[MondayDoNotCall] as [MondayNeverCall],
						[MondayCallWindowStart],
						[MondayCallWindowEnd],
						[MondayNoCallWindowStart],
						[MondayNoCallWindowEnd],
						[TuesdayDoNotCall] as [TuesdayNeverCall],
						[TuesdayCallWindowStart],
						[TuesdayCallWindowEnd],
						[TuesdayNoCallWindowStart],
						[TuesdayNoCallWindowEnd],
						[WednesdayDoNotCall] as [WednesdayNeverCall],
						[WednesdayCallWindowStart],
						[WednesdayCallWindowEnd],
						[WednesdayNoCallWindowStart],
						[WednesdayNoCallWindowEnd],
						[ThursdayDoNotCall]  as [ThursdayNeverCall],
						[ThursdayCallWindowStart],
						[ThursdayCallWindowEnd],
						[ThursdayNoCallWindowStart],
						[ThursdayNoCallWindowEnd],
						[FridayDoNotCall]  as [FridayNeverCall],
						[FridayCallWindowStart],
						[FridayCallWindowEnd],
						[FridayNoCallWindowStart],
						[FridayNoCallWindowEnd],
						[SaturdayDoNotCall]  as [SaturdayNeverCall],
						[SaturdayCallWindowStart],
						[SaturdayCallWindowEnd],
						[SaturdayNoCallWindowStart],
						[SaturdayNoCallWindowEnd], 
						[SundayDoNotCall]  as [SundayNeverCall],
						[SundayCallWindowStart],  
						[SundayCallWindowEnd],  
						[SundayNoCallWindowStart],  
						[SundayNoCallWindowEnd],
				'' as [Filler]
			FROM Phones_Master pm WITH (NOLOCK) 
			OUTER APPLY
(SELECT TOP 1 * FROM Phones_Consent pc WITH (NOLOCK) WHERE pc.MasterPhoneId = pm.MasterPhoneID ORDER BY PhonesConsentId DESC) AS pc
			LEFT OUTER JOIN dbo.Phones_Preferences AS PP WITH (NOLOCK) ON PP.MasterPhoneId=pm.MasterPhoneID
			JOIN Receiver_DebtorReference dr WITH (NOLOCK) ON pm.DebtorID = dr.ReceiverDebtorID 
			JOIN [Master] m WITH (NOLOCK) ON m.Number = pm.Number
			JOIN Receiver_Reference rr WITH (NOLOCK) ON m.Number = rr.ReceiverNumber
			LEFT OUTER JOIN ServiceHistory sh WITH (NOLOCK) ON sh.RequestID = pm.RequestID
			LEFT OUTER JOIN Services s WITH (NOLOCK) ON sh.serviceid = s.serviceid
			LEFT OUTER JOIN Users u WITH (NOLOCK) ON pm.LoginName = u.LoginName
			WHERE
			rr.ClientID = @clientid AND
			(pm.DateAdded > @lastFileSentDT OR pm.LastUpdated > @lastFileSentDT) AND 
			(pm.LoginName NOT IN  ('AIM','SYNC','CONVERSION') OR pm.UpdatedBy NOT IN ('AIM','SYNC','CONVERSION')) AND
			NOT (pm.PhoneNumber IS NULL OR pm.PhoneNumber = '' OR replace(pm.phonenumber,'0','') = '')
			AND m.qlevel < '999'
			AND pm.NearbyContactID IS NULL AND pm.PhoneTypeId <=6
			ORDER BY pc.EffectiveDate ASC
		-- Otherwise we don't have Phones_Master so adjust accordingly KAR on 02/25/2010
		
		/*Email Consent Data*/

		SELECT
		'AEML' as record_type,
		rr.sendernumber as file_number,
		dr.senderdebtorid as debtor_number,
		CASE 
		 WHEN d.ContactMethod='Letter' THEN '1'
		 WHEN d.ContactMethod='Phone' THEN '2'
		 WHEN d.ContactMethod='Email' THEN '3'
		 WHEN d.ContactMethod='SMS' THEN '4'
		  ELSE NULL END AS PreferredMethod,
		E.[Email] as EmailAddress,
		TypeCd as EmailType,
		CASE WHEN E.ConsentGiven = 1 THEN 'Y' ELSE 'N' END AS ConsentToEmail, 
		CAST(E.WrittenConsent AS VARCHAR(1)) AS Method,
		ConsentSource as ObtainedFrom,
		ModifiedWhen as EffectiveDate,
		E.comment as Comment,
		CASE WHEN E.TypeCd = 'Work' THEN 'Y' ELSE 'N' END AS WorkEmail,
		'' as Filler
		FROM dbo.Email AS E WITH (NOLOCK)
		INNER JOIN [Debtors] AS D ON D.DebtorID=E.DebtorId
		INNER JOIN [Master] AS M ON M.number=D.Number
		JOIN Receiver_DebtorReference dr WITH (NOLOCK) ON dr.ReceiverDebtorID = D.DebtorID
		JOIN Receiver_Reference rr WITH (NOLOCK) ON rr.ReceiverNumber = m.Number
		WHERE (COALESCE(E.ModifiedWhen,E.CreatedWhen)>= @lastFileSentDT ) AND E.ModifiedBy <> 'AIM'
		AND m.qlevel < '999'


			/*Validation Notice Data*/
		SELECT 'AUVN' AS record_type,
		dr.senderdebtorid as debtor_number,
		rr.sendernumber as [file_number],
		VN.[ValidationNoticeSentDate] AS [SentDate],
		VN.[ValidationPeriodExpiration] AS [PeriodEndDate],
		CASE WHEN ISNULL(VN.[ValidationNoticeType],'')='Letter' THEN 1 
		WHEN ISNULL(VN.[ValidationNoticeType],'')='Digital' THEN 2
		WHEN ISNULL(VN.[ValidationNoticeType],'')='Verbally' THEN 3
		ELSE 0
		END AS [Method],
		--VN.[ValidationNoticeType] AS [Method],
		CASE WHEN ISNULL(VN.[Status],'')='Sent' THEN 1 
		WHEN ISNULL(VN.[Status],'')='Returned' THEN 2
		WHEN ISNULL(VN.[Status],'')='Completed' THEN 3
		ELSE 0
		END AS [Status],
		--VN.[Status],
		'' AS Filler
		FROM ValidationNotice AS VN with (NOLOCK)
		JOIN [Debtors] d WITH (NOLOCK) ON d.DebtorID = VN.DebtorID
		INNER JOIN [master] AS M ON M.number=d.Number
		JOIN Receiver_DebtorReference dr WITH (NOLOCK) ON dr.ReceiverDebtorID = d.DebtorID
		JOIN Receiver_Reference rr WITH (NOLOCK) ON rr.ReceiverNumber = m.Number
		WHERE VN.LastUpdated>= @lastFileSentDT
		AND m.qlevel < '999'
	END
end
GO
