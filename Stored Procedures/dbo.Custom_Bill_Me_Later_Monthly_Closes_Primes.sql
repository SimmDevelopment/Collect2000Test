SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 2013
-- Description:	Send accounts that closed during the select date range
-- Updates:  3/10/204 changed from accounts that have been returned to all acounts that were closed.
-- 04/07/2020 updated code to properly get SIF/PIF accounts with 15 day hold.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Bill_Me_Later_Monthly_Closes_Primes]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    
SELECT distinct m.account, CASE m.customer WHEN '0001256' THEN 'Prime' WHEN '0001257' THEN 'Tert' WHEN '0001258' THEN 'PBK' ELSE m.customer END AS Portfolio, 
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
			WHEN m.STATUS = 'RSK' THEN 'LTG'
			WHEN M.STATUS = 'MIL' THEN 'MIL'
			WHEN M.STATUS = 'DIP' THEN 'DIP'
			WHEN M.STATUS = 'POA' THEN 'POA'
			WHEN m.STATUS = 'OOS' THEN 'OOS'
			ELSE 'PTP'
		END
		WHEN customer <> '0001220' THEN
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BKT'
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

--Get all closed accounts in statuses as well as SIF/PIF after 15 day hold.
WHERE customer IN ('0001256', '0001257', '0001258') AND ((m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP', 'POA', 'OOS') AND m.returned BETWEEN dbo.date(@startDate) AND dbo.date(@endDate))
OR (m.status IN ('sif', 'pif') AND m.returned between (@startdate - 15) and (@endDate - 15)))


--Old code
--WHERE ((m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP', 'POA', 'OOS') AND m.returned BETWEEN dbo.date(@startDate) AND dbo.date(@endDate))
--OR (m.status IN ('sif', 'pif') AND m.returned between (@startdate - 15) and (@endDate - 15))))
-- AND customer IN ('0001256', '0001257', '0001258')

END
GO
