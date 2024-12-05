SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GS2_Fortress_Demographics_File]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
        
	SELECT dbo.date(GETDATE()) AS effdate, '30' AS SRC, '39' AS PTADR, m.ssn AS PRSID, 'L' AS DCADR, d.Street1 AS STRADR1, d.Street2 AS STRADR2,
		'' AS STRADR3, d.City AS CT, d.State AS DOMST, d.Zipcode AS ZIPCDE, '' AS FGNST, '' AS FGNCNY, '' AS FGNCTR, CASE WHEN d.homephone = '' OR d.homephone IS NULL THEN '' ELSE 'H' END AS PHNTYPE, 
		d.HomePhone AS DOMPHN, '' AS PHNXTN, '' AS FORPHONE, '' AS PHN2, '' AS FORPHONE2, '' AS PHN3, '' AS FORPHONE3, '' AS DSBADRBEG,
		'' AS DSBADREND 
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
	INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID
WHERE dbo.date(ah.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND customer IN ('0001298','0002367')

END
GO
