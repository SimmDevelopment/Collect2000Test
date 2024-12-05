SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_RTR_Chase_Auto_Monthly_Closes_Primes]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    
SELECT distinct m.account, CASE m.customer WHEN '0001256' THEN 'Prime' WHEN '0001257' THEN 'Tert' WHEN '0001258' THEN 'PBK' END AS Portfolio, 
	cast(isnull(m.returned,NULL) as smalldatetime) as [Date Returned],
	case WHEN customer = '0001220' THEN 
		CASE when m.status like 'B%' then 'DBK'
			when m.status='CAD' then 'DCR'
			when m.status='CCC' then 'DCR'
			WHEN m.STATUS = 'FRD' THEN 'DCR'
			when m.status='SIF' then 'SIF'
			when m.status='PIF' then 'PIF'
			WHEN m.STATUS = 'AEX' THEN 'DCR'
			WHEN M.STATUS = 'PLV' THEN 'ALV'
			WHEN m.STATUS = 'RSK' THEN 'RSK'
			ELSE 'PTP'
		END
		WHEN customer <> '0001220' THEN
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BKP'
			when m.STATUS IN ('CAD', 'CND') then 'CAD'
			WHEN m.STATUS = 'DEC' THEN 'DEC'
			WHEN m.STATUS = 'DSP' THEN 'DSP'
			WHEN m.STATUS = 'FRD' THEN 'FRD'
			WHEN m.STATUS = 'RSK' THEN 'LTG'
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			WHEN m.STATUS = 'PIF' THEN 'PIF'
			ELSE 'PTP'
		END 		
	END AS [NoteCode]
FROM master m with (nolock) 

WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND')
AND m.returned BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND customer IN ('0001256', '0001257', '0001258')

END
GO
