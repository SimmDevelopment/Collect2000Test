SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Changes:
-- 01/04/2023 BGM Updated code to pull correct account from phones_consent table.

CREATE PROCEDURE [dbo].[Phones_GetByAccountID] @AccountID INTEGER, @LinkID INTEGER = NULL
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Phones TABLE (
	[ID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
);

INSERT INTO @Phones ([ID])
SELECT [Phones_Master].[MasterPhoneID]
FROM [dbo].[Phones_Master]
INNER JOIN [dbo].[fnGetLinkedAccounts](@AccountID, NULL) AS [Accounts]
ON [Phones_Master].[Number] = [Accounts].[AccountID] --WHERE [Phones_Master].Number=@AccountID;

IF @@ROWCOUNT = 0 BEGIN
	EXEC [dbo].[Phones_SyncFromAccounts] @AccountID = @AccountID, @LinkID = @LinkID;

	INSERT INTO @Phones ([ID])
	SELECT [Phones_Master].[MasterPhoneID]
	FROM [dbo].[Phones_Master]
	INNER JOIN [dbo].[fnGetLinkedAccounts](@AccountID, NULL) AS [Accounts]
	ON [Phones_Master].[Number] = [Accounts].[AccountID] --WHERE  [Phones_Master].Number=@AccountID;	
END;

--;WITH CTE_PhonesConsent AS
--(
--	SELECT TOP 1 * FROM PHONES_CONSENT WHERE [EFFECTIVEDATE] <= GETUTCDATE() ORDER BY EFFECTIVEDATE DESC --ASE-916
--)
SELECT [Phones_Master].[MasterPhoneID],
	[Phones_Master].[Number] AS [AccountID],
	[Phones_Master].[PhoneTypeID],
	[Phones_Master].[Relationship],
	[Phones_Master].[PhoneStatusID],
	[Phones_Master].[OnHold],
		--check time zone if out of zone then mask number  1 = can call 0 = Cannot call
		CASE WHEN (SELECT distinct CASE when SUBSTRING(PhoneNumber, 1, 3) IN ('800', '888', '877', '866', '855', '844') THEN 1
				--Uncomment below for pre 8 a.m. testing.
				--WHEN @phonenumber = '3023837812' THEN 1
		
		
			--Special Resurgent Restrictions
			WHEN (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN (SELECT customerid FROM Fact WITH (NOLOCK) WHERE CustomGroupID = 24)
				THEN CASE
						WHEN state IN ('CA', 'ID', 'IL', 'MS', 'OK', 'WV', 'SD') AND DATEPART(hh, timecur) BETWEEN 9 AND 20 THEN 1
						WHEN state IN ('IN', 'NV') AND DATEPART(hh, timecur) BETWEEN 9 AND 19 THEN 1
						WHEN state IN ('SC') AND DATEPART(hh, timecur) BETWEEN 8 AND 18 THEN 1
						WHEN state IN ('LA') AND DATEPART(hh, timecur) BETWEEN 8 AND 19 THEN 1
						WHEN state NOT IN ('CA', 'ID', 'IL', 'MS', 'OK', 'WV', 'SD', 'IN', 'NV', 'SC', 'LA') AND DATEPART(hh, timecur) BETWEEN 8 AND 20 THEN 1
					ELSE 0 
				end
				WHEN DATEPART(hh, timecur) BETWEEN 8 AND 20 THEN 1
				ELSE 0 END
				FROM dbo.AreaCode
				WHERE convert(varchar(3), areacode) = SUBSTRING(PhoneNumber, 1, 3) AND convert(varchar(3), prefix) = SUBSTRING(PhoneNumber, 4, 3)) = 0

		THEN '******' + RIGHT(PhoneNumber, 4) 

			--block accounts in paypal NB
			--WHEN (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('0002337', '0002338', '0002366')
			--	THEN '******' + RIGHT(PhoneNumber, 4) 
 

		--****SPECIAL RESTRICTION FOR STATES DUE TO CORVID-19****ADDED 03/30/2020 removed 6/10/2020
		--WHEN state IN ('MA', 'NV', 'DC') THEN '******' + RIGHT(PhoneNumber, 4)
		--WHEN @AccountID IN (SELECT NUMBER FROM master WITH (NOLOCK) WHERE STATE IN ('MA', 'NV', 'DC')) THEN '******' + RIGHT(PhoneNumber, 4)
		--WHEN @AccountID IN (SELECT NUMBER FROM DEBTORS WITH (NOLOCK) WHERE STATE IN ('MA', 'NV', 'DC')) THEN '******' + RIGHT(PhoneNumber, 4)

		WHEN (SELECT status FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('NHD', 'MHD', 'RHD', 'WHD', 'HLD', 'LCP', 'WHL','UHD', 'VRB', 'VCD', 'VRD')
		THEN '******' + RIGHT(PhoneNumber, 4) 
		--WHEN [phones_master].[PhoneNumber] IN (SELECT Phone FROM dbo.ztempPayPalPhoneExclude WITH (NOLOCK))
		--THEN '**********' 
		WHEN @accountid = 8418698 
		THEN '******' + RIGHT(PhoneNumber, 4) 
		WHEN [phones_master].[PhoneNumber] IN (SELECT PhoneNumber FROM Braxtel_ContactQ_DoNotCall WITH (NOLOCK))
		THEN '******' + RIGHT(PhoneNumber, 4)

		--Turn off numbers for Investinet in Iowa Derecho 2020
		WHEN (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('0002363') 
			AND SUBSTRING(PhoneNumber, 1, 3) IN ('319', '505')
		THEN '******' + RIGHT(PhoneNumber, 4)
				

		--Turn off numbers for Hyundai for HI Hurricane Lane
		--WHEN (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('0001122', '0001123') 
		--AND (SELECT state FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('HI') 
		----OR (SELECT SUBSTRING(zipcode, 1, 5) FROM master WITH (NOLOCK) WHERE number = @AccountID) IN (SELECT CONVERT(VARCHAR(10), zipcode) FROM ztempHyundaiDisZips WITH (NOLOCK)))
		--THEN '******' + RIGHT(PhoneNumber, 4)

		--Turn off numbers for HI Hurricane 10/14/2017 JH Capital per counties provided opened calls on 8/28/2018
		--WHEN (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN (SELECT CustomerID FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 280) 
		--AND (SELECT SUBSTRING(zipcode, 1, 5) FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('96778','96785','96777','96772','96704',
		--'96718','96743','96740','96738','96710','96719','96720','96727','96728','96749','96755','96760','96764','96771','96773','96774',
		--'96776','96780','96781','96783','96725','96726','96737','96739','96745','96750','96701','96712','96759','96782','96786','96789',
		--'96791','96797','96857','96706','96707','96709','96792','96795','96801','96802','96803','96804','96805','96806','96807','96808',
		--'96809','96810','96811','96812','96813','96814','96815','96816','96817','96818','96819','96820','96821','96822','96823','96824',
		--'96825','96826','96828','96830','96836','96837','96838','96839','96840','96841','96843','96846','96847','96848','96849','96850',
		--'96853','96858','96859','96860','96898','96796','96714','96722','96741','96746','96754','96705','96716','96747','96752','96769',
		--'96717','96730','96731','96734','96744','96762','96844','96861','96703','96715','96756','96765','96766','96863')
		--THEN '******' + RIGHT(PhoneNumber, 4)

		--Turn off numbers for HI Volcano 5/11/2018 Zones by Customer Paypal
		--Turn off numbers for CA Wild fires 8/8/2018 by zipcode for Paypal only
		--Turn off state of HI for Hurricane Lane 8/25/2018
		--WHEN (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('0001256', '0001257', '0001258', '0001220') 
		--AND (SELECT state FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('HI') 
		----AND (SELECT SUBSTRING(zipcode, 1, 5) FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('92264','92339','92399','92544', '93220','93306','93518','93546','93601','93604','93623','93644','95223','95311','95314','95321',
		----'95345','95364','95389','95418','95422','95423','95424','95470','95479','95481','95482','95485','95428','95435','95443','95449','95451','95453','95457','95458',
		----'95461','95464','95469','95493','95606','95637','95679','95912','95939','95979','95987','96002','96007','96008','96011','96013','96016','96017',
		----'96022','96024','96028','96033','96039','96040','96047','96048','96051','96052','96056','96059','96062','96065','96069','96070','96071','96073','96076','96079','96084',
		----'96088','96089','96091','96093','96095','96096','96099','96130', '95251', '92530', '92883', '92676', '92679')
		--THEN '******' + RIGHT(PhoneNumber, 4)



		--Turn off numbers for Hurricane Disaster Zones by Customer Suntrust
		WHEN (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE (CustomGroupID IN (186)))
		AND (SELECT state FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('CT')
		THEN '******' + RIGHT(PhoneNumber, 4)

		--Turn off numbers for Hurricane Disaster Zones	by State for all Customers
		--WHEN (SELECT state FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('PR') 
		--AND (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) NOT IN ('0001256', '0001257', '0001220', '0001280', '0001281', '0001317', '0001410')
		--THEN '******' + RIGHT(PhoneNumber, 4)


		--WHEN SUBSTRING(PhoneNumber, 1, 3) IN ('305', '786', '239', '754', '772', '863', '941', '239', '321', '407', '727', '813', '352', '386', '904')
		--	AND (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) IN ('0000882', '0001475') 
		--THEN '******' + RIGHT(PhoneNumber, 4)

		--Turn off numbers for Hurricane Disaster Zone by Area Codes Key West and Miami, exclude caliber
		--WHEN SUBSTRING(PhoneNumber, 1, 3) IN ('305', '786', '239', '754', '954', '561', '772', '863', '941', '239', '321', '407', '727', '813', '352', '386', '904')
		--	AND (SELECT customer FROM master WITH (NOLOCK) WHERE number = @AccountID) NOT IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE (CustomGroupID IN (24, 181) OR customerid IN ('0001484', '0001215', '0001224', '0001122', '0001123'))) 
		--THEN '******' + RIGHT(PhoneNumber, 4)
		else
			[Phones_Master].[PhoneNumber] END AS [PhoneNumber],
	
--Normal Code
	--[Phones_Master].[PhoneNumber],
	[Phones_Master].[PhoneName],
	[Phones_Master].[DebtorID],
	[Phones_Master].[DateAdded],
	[Phones_Master].[RequestID],
	[Services].[Description],
	[Phones_Master].[LoginName],
	[Phones_Master].[PhoneExt],
	[Phones_Master].[NearbyContactID],
	[Phones_Master].[LastUpdated],
	[Phones_Master].[UpdatedBy],
	PHC.[PhonesConsentId],  
	PHC.[MasterPhoneId],  
	PHC.[AllowManualCall],  
	PHC.[AllowAutoDialer],  
	PHC.[AllowFax],  
	PHC.[AllowText],  
	PHC.[WrittenConsent],  
	PHC.[ObtainedFrom],  
	PHC.[DocumentationId],  
	PHC.[UserId],  
	PHC.[EffectiveDate],  
	PHC.[comment]  
	--[Phones_Consent].[PhonesConsentId],
	--[Phones_Consent].[MasterPhoneId],
	--[Phones_Consent].[AllowManualCall],
	--[Phones_Consent].[AllowAutoDialer],
	--[Phones_Consent].[AllowFax],
	--[Phones_Consent].[AllowText],
	--[Phones_Consent].[WrittenConsent],
	--[Phones_Consent].[ObtainedFrom],
	--[Phones_Consent].[DocumentationId],
	--[Phones_Consent].[UserId],
	--[Phones_Consent].[EffectiveDate],
	--[Phones_Consent].[comment]
FROM [dbo].[Phones_Master]
INNER JOIN @Phones AS [Phones]
ON [Phones_Master].[MasterPhoneID] = [Phones].[ID]
--LEFT OUTER JOIN CTE_PhonesConsent AS [Phones_Consent] 
--ON [Phones_Master].[MasterPhoneID] = [Phones_Consent].[MasterPhoneID]  
LEFT OUTER JOIN [dbo].[ServiceHistory]
ON [ServiceHistory].[RequestID] = [Phones_Master].[RequestID]
LEFT OUTER JOIN [dbo].[Services]
ON [Services].[ServiceID] = [ServiceHistory].[ServiceID]  
OUTER APPLY(SELECT TOP 1 * FROM PHONES_CONSENT WHERE [EFFECTIVEDATE] <= GETUTCDATE() AND MasterPhoneID = [Phones_Master].[MasterPhoneID]
ORDER BY EFFECTIVEDATE DESC) AS PHC
--AND [Phones_Master].Number=@AccountID

SELECT [Phones_Attempts].[MasterPhoneID],
	[Phones_Attempts].[AttemptedDate],
	[Phones_Attempts].[LoginName]
FROM [dbo].[Phones_Attempts]
INNER JOIN @Phones AS [Phones]
ON [Phones_Attempts].[MasterPhoneID] = [Phones].[ID];

RETURN 0;

GO
