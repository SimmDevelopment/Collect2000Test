SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Adding number in order to fix LAT-10741
CREATE FUNCTION [dbo].[cbrDataPhonesMasterex] ( @DebtorID INT , @Number INT)
RETURNS TABLE
AS 
    RETURN

	WITH tphones AS (SELECT PhoneTypeID, phonestatusid FROM Phones_Types 
					CROSS JOIN Phones_Statuses
					WHERE PhoneTypeDescription = 'home' AND PhoneStatusDescription = 'good'
				),
				dphones AS (
							SELECT p.number, p.PhoneNumber, ROW_NUMBER() OVER ( PARTITION BY p.number ORDER BY p.phonestatusid ASC) AS hphone, 
							p.MasterPhoneID, p.DebtorID, p.PhoneTypeID , p.phonestatusid
							FROM phones_master p inner join tphones t on t.PhoneTypeID = p.PhoneTypeID and t.PhoneStatusID = p.PhoneStatusID
							WHERE p.DebtorID = @DebtorID and p.number =@Number
							)
							
							SELECT * FROM dphones WHERE hphone = 1;
		
		
GO
