SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 02/08/2021
-- Description:	Create Keeper file after importing the main maintenance file
-- Changes:		02/11/2021 BGM Added to also look for accounts in current hold status with previous keeper status.
--				02/12/2021 BGM Changed last paid date to 60 days ago
--				02/16/2021 BGM Removed last paid requested by US Bank stating they do not recall last paid in 60 days
--				02/16/2021 BGM Changed Trans code to 911 so there will not be confusion with Maintenance or Recall imports.
--				02/26/2021 BGM Changed the look up in status history to only look if the account is currently in a hold status.
--				07/03/2023 Updated to customer group 382
--				10/13/2023 Setup for Language Preference Update
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Export_Keeper_File_Old]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustGroupID INT
--SET @CustGroupID = 382 --Production
SET @CustGroupID = 113 --Test	

    -- Insert statements for procedure here
	--Get Recalls
SELECT  cutr.AgencyID , cutr.LocationCode , cutr.AccountNumber , '911' AS TransCode ,cutr.TransDate ,cutr.RecallReason ,cutr.AccountingSysID 
FROM dbo.custom_usbank_temp_recall cutr WITH (NOLOCK)
WHERE AccountNumber IN (
SELECT  cutr.AccountNumber
FROM dbo.custom_usbank_temp_recall cutr WITH (NOLOCK) INNER JOIN dbo.master m WITH (NOLOCK) ON cutr.accountnumber = m.account
WHERE (status IN ('PDC', 'PCC', 'PPA', 'BKN', 'NPC', 'NSF', 'DCC', 'DBD', 'CLM', 'ESQ')
OR (status IN ('UHD', 'MHD', 'NHD', 'WHD', 'RHD') AND (select top 1 oldstatus from statushistory with (Nolock) where accountid = m.number and newstatus IN ('UHD', 'MHD', 'NHD', 'WHD', 'RHD') order by datechanged desc) IN ('PDC', 'PCC', 'PPA', 'BKN', 'NPC', 'NSF', 'DCC', 'DBD', 'CLM', 'ESQ'))
)
AND recallreason IN ('T', 'N', 'R') AND closed IS NULL
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)
)

END
GO
