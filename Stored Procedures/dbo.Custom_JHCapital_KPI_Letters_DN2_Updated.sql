SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_KPI_Letters_DN2_Updated]
	-- Add the parameters for the stored procedure here
	@startDate as DATETIME,
	@endDate AS DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @startDate = dbo.F_START_OF_DAY(@startDate)
 SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))



    -- Insert statements for procedure here
		SELECT m.id1 AS data_id, CONVERT(VARCHAR(10), lr.DateProcessed, 101) + ' ' + CONVERT(VARCHAR(8), lr.DateProcessed, 108) AS activity_date,
		CASE WHEN lr.lettercode like 'BUY%' OR lettercode IN ('11', '11-ny') THEN 'Validation Notice Demand Mailed - GLB'
		 WHEN lr.lettercode LIKE 'VAL%' THEN 'Letter - Validation of Debt Mailed'
		 WHEN lr.lettercode LIKE '%SIF%' THEN 'Letter - Settlement Letter'
		 WHEN lr.lettercode IN ('13', '13CC') THEN 'Letter - PDC Notice Mailed'
		 end  activity_item_desc,
		

		 CASE WHEN lr.lettercode like 'BUY%' OR lettercode IN ('11', '11-ny') THEN '100007'
		 WHEN lr.lettercode LIKE 'VAL%' THEN '100085'
		 WHEN lr.lettercode LIKE '%SIF%' THEN '100021'
		 WHEN lr.lettercode IN ('13', '13CC') THEN '100004'				
		end AS [activitytype_id]
	
	
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON lr.AccountID = m.number
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND dbo.date(lr.DateProcessed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)and id2 not in ('AllGate','ARS-JMET')
AND (lr.ErrorDescription = '' OR lr.ErrorDescription IS NULL) AND (lr.lettercode like 'BUY%' or lr.lettercode LIKE 'VAL%' OR lr.lettercode LIKE '%SIF%' OR lr.lettercode IN ('11', '11-ny', '13', '13CC'))
END
GO
