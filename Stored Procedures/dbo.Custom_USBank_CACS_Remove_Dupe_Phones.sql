SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 01/23/2020
-- Description:	Removes duplicate phone numbers sent by US Banks File.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Remove_Dupe_Phones] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WHILE (SELECT COUNT(*)
FROM (
SELECT TransCode, AcctNumber, ContactId, PhoneNumber, PhoneType, ServiceType-- ContactId, ExternalKey, PhoneNumber, PhoneType, ServiceType, PreferredPhoneNumberInd
FROM Custom_USBank_Temp_Phones cubtp WITH (NOLOCK)
GROUP BY AcctNumber, ContactId, PhoneNumber, PhoneType, ServiceType, TransCode
HAVING COUNT(*) > 1
) AS z)
 > 0

BEGIN

DELETE FROM Custom_USBank_Temp_Phones
WHERE uid IN (
SELECT MAX(uid)
FROM Custom_USBank_Temp_Phones p WITH (NOLOCK) INNER JOIN 
(
SELECT TransCode, AcctNumber, ContactId, PhoneNumber, PhoneType, ServiceType-- ContactId, ExternalKey, PhoneNumber, PhoneType, ServiceType, PreferredPhoneNumberInd
FROM Custom_USBank_Temp_Phones cubtp WITH (NOLOCK)
GROUP BY AcctNumber, ContactId, PhoneNumber, PhoneType, ServiceType, TransCode
HAVING COUNT(*) > 1
) z ON p.TransCode = z.TransCode AND p.AcctNumber = z.AcctNumber
AND p.ContactId = z.ContactId AND p.PhoneNumber = z.PhoneNumber 
AND p.PhoneType = z.PhoneType AND p.ServiceType = z.ServiceType
GROUP BY p.AcctNumber, p.ContactId, p.PhoneNumber, P.PhoneType, P.ServiceType, P.TransCode
)

END
END
GO
