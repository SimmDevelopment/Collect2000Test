SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_MT_CACS_Audit_File_Outgoing] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--exec Custom_USBank_Audit_File_Outgoing

--Record Audit
SELECT 'SIM    ' AS ThirdPartyID, id2 AS LocationCode, m.account AS Acctnumber, '+' + CASE WHEN m.customer = '0003107' THEN '050'WHEN m.customer = '0003109' THEN '041' END AS CommissionPerc, 
CASE WHEN m.current0 > 0 THEN '+' ELSE '-' END AS DelqSign, REPLACE(CONVERT(VARCHAR(19), m.current0), '.', '') + '0000' AS TotalDelinqAmt,
'+0' AS OverLimitAmt, '+0' AS InterestRate, ' ' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	INNER JOIN FeeSchedules fs WITH (NOLOCK) ON c.FeeSchedule = fs.Code
	INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON fs.Code = fsd.Code
WHERE m.customer IN ('0003107','0003109') AND closed IS NULL



END
GO
