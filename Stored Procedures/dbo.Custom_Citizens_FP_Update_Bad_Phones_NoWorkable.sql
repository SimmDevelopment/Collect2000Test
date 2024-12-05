SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/17/2019
-- Description:	Mark phone numbers as bad in Latitude if the phone number is not in the Inventory file from CTZ
-- Changes:
--	10/13/2022 BGM Added code to insert or update the Custom_Citizens_FP_Inventory_History table for use in the input efficency report. 
-- =============================================
CREATE	 PROCEDURE [dbo].[Custom_Citizens_FP_Update_Bad_Phones_NoWorkable]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Phones_Master
SET PhoneStatusID = 1
WHERE MasterPhoneID IN (
SELECT pm.MasterPhoneID
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE customer = '0002226' AND m.closed IS NULL AND (pm.PhoneStatusID = 2 OR pm.PhoneStatusID IS NULL)
AND (PhoneName <> 'cbc innovis rpc' and LoginName = '')
AND pm.PhoneNumber NOT IN (


SELECT phone1--, phone2, phone3, Skip_Phone1, Skip_Phone2, Skip_Phone3, Skip_Phone4
FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
)
AND pm.PhoneNumber NOT IN (
SELECT phone2--, phone3, Skip_Phone1, Skip_Phone2, Skip_Phone3, Skip_Phone4
FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
)
AND pm.PhoneNumber NOT IN (
SELECT phone3--, Skip_Phone1, Skip_Phone2, Skip_Phone3, Skip_Phone4
FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
)
AND pm.PhoneNumber NOT IN (
SELECT Skip_Phone1--, Skip_Phone2, Skip_Phone3, Skip_Phone4
FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
)
AND pm.PhoneNumber NOT IN (
SELECT Skip_Phone2--, Skip_Phone3, Skip_Phone4
FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
)
AND pm.PhoneNumber NOT IN (
SELECT Skip_Phone3--, Skip_Phone4
FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
)
AND pm.PhoneNumber NOT IN (
SELECT Skip_Phone4
FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
)
)

--set back to Custom_Citizens_First_Party_Master_Temp_File after loading all history files
UPDATE master
SET received = CAST(filedate AS DATE)
FROM Custom_Citizens_First_Party_NonWorkable_Temp_File
WHERE  c_flag NOT IN ('Y', '1') 
AND account = acct_num AND customer = '0002226'


--Load Inventory History Table for the input efficiency report
--IF EXISTS(SELECT TOP 1 CAST(productiondate AS DATE) FROM Custom_Citizens_FP_Inventory_History ccfih WITH (NOLOCK) WHERE CAST(productiondate AS DATE) = CAST(GETDATE() AS DATE))
--		BEGIN
		
--			 UPDATE Custom_Citizens_FP_Inventory_History
--			 SET Total_Inventory = c.total_inv
--			 FROM (SELECT COUNT(*) AS total_inv
--			 FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf  WITH (NOLOCK)) c
--			 WHERE CAST(ProductionDate AS DATE) = CAST(GETDATE() AS DATE)
--	   END
--	ELSE
--	   BEGIN
	  
--			INSERT INTO Custom_Citizens_FP_Inventory_History (ProductionDate, Total_Inventory)
--			SELECT CAST(GETDATE() AS DATE), COUNT(*) AS num_placed
--			FROM Custom_Citizens_First_Party_Master_Temp_File ccfpmtf WITH (NOLOCK)
--	   END


END
GO
