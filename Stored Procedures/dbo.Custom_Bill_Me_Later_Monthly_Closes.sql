SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Bill_Me_Later_Monthly_Closes]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    
SELECT distinct m.account, cast(isnull(m.returned,NULL) as smalldatetime) as [Date Returned],
	case WHEN customer = '0001220' THEN 
		CASE when m.status like 'B%' then 'DBK'
			when m.status IN ('CAD', 'CND') then 'DCR'
			when m.status ='CCC' then 'DCR'
			WHEN m.STATUS = 'FRD' THEN 'DCR'
			when m.status ='SIF' then 'SIF'
			when m.status ='PIF' then 'PIF'
			WHEN m.STATUS = 'AEX' THEN 'DCR'
			WHEN M.STATUS = 'PLV' THEN 'ALV'
			WHEN m.STATUS = 'RSK' THEN 'RSK'
			WHEN M.STATUS = 'MIL' THEN 'MIL'
			WHEN M.STATUS = 'DIP' THEN 'DIP'
			WHEN M.STATUS = 'POA' THEN 'POA'
			WHEN m.STATUS = 'OOS' THEN 'OOS'
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
			WHEN M.STATUS = 'MIL' THEN 'MIL'
			WHEN M.STATUS = 'DIP' THEN 'DIP'
			WHEN M.STATUS = 'POA' THEN 'POA'
			WHEN m.STATUS = 'OOS' THEN 'OOS'
			ELSE 'PTP'
		END 		
	END AS [NoteCode]
FROM master m with (nolock) 

WHERE (m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP', 'POA', 'OOS')
OR (m.status IN ('sif', 'pif') AND m.returned between (@startdate - 15) and (@endDate - 15)))
AND m.returned BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND customer IN ('0001220')

END
GO
