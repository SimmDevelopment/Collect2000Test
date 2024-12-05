SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 02/23/2021
-- Description:	Export Payments for Great America
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GS2_GreatAmerica_Export_Payments] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'D' AS recordType, '0001' AS batchNumber, row_number() over (order by datepaid) AS sequenceNumber, m.account AS accountNumber,
CONVERT(VARCHAR, p.totalpaid * 100) AS amountPaid, '0022222222' AS checkNumber, p.Invoice AS invoiceNumber
FROM dbo.master m WITH (NOLOCK) INNER JOIN dbo.payhistory p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer = '0002448' AND invoice IS NOT NULL
ORDER BY datepaid

END
GO
