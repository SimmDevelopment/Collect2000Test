SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_Demographic] 
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(5000),
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account as [C.D.#], d.Street1 AS ADDRESS1, d.Street2 AS ADD2,
	d.City as CITY, d.State as ST, d.Zipcode AS Zip, pm.PhoneNumber as phone, id2 AS [Location Code]
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID
	INNER JOIN dbo.Phones_Master pm with (nolock) on m.number = pm.Number
WHERE dbo.date(ah.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND ((customer IN ('0002258','0002259','0002509','0002510','0002513','0002514','0002512','0002775')) or (customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))


END

GO
