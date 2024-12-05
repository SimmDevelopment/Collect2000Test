SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Prob_Post_Load] 
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update debtors
	set county = z.county, DLNum = z.county
	from master m with (nolock) inner join zipcodesprobate z with (nolock) on CASE LEN(m.zipcode) WHEN 3 THEN '00' + m.zipcode WHEN 4 THEN '0' + m.zipcode WHEN 8 THEN '0' + substring(m.zipcode, 1, 4) ELSE substring(m.zipcode, 1, 5) end = z.zipcode
	where debtors.seq = 0 and debtors.number = m.number AND m.number = @number
	
	
	
	UPDATE dbo.Deceased
	SET courtdivision = cp.county + ' '  + cp.court, CourtStreet1 = cp.street1, courtstreet2 = cp.Street2, courtcity = cp.City, courtstate = cp.STATE, CourtZipcode = cp.zipcode, courtphone = cp.TELEPHONE
	FROM  master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.Seq = 0 INNER JOIN deceased de WITH (NOLOCK) ON d.DebtorID = de.DebtorID
		INNER JOIN dbo.Custom_Probate_Court_Info cp WITH (NOLOCK) ON d.County = cp.COUNTY AND d.State = cp.STATE 
	WHERE m.number = @number AND (de.courtdivision IS NULL OR de.CourtDivision = '')

	
END
GO
