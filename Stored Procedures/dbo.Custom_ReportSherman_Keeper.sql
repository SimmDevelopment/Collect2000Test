SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Ibrahim Hashimi
-- ALTER  date: 02/04/2006
-- Description:	This is used from Exchange to request to keep a set of accounts
--				after they have been recalled.
-- =============================================
/*
Exec Custom_ReportSherman_Keeper @accountNumbers = '14445|170035|170036|170037|'
select * from status
 --where description like '%pro%'
 order by code
*/
CREATE PROCEDURE [dbo].[Custom_ReportSherman_Keeper]
	@accountNumbers as varchar(8000)
AS
BEGIN
	SET NOCOUNT ON;


	Select	m.account			as [AccountNumber],
			'NSF'			as [ReasonToKeep],
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')			as [ResurgentId],
			--m.status		as
			CASE(m.status)
				WHEN 'ACT'	THEN 'ACT'
				WHEN 'AEX'	THEN 'AEX'
				WHEN 'ATY'	THEN 'ATT'
				WHEN 'B07'	THEN 'BAN'
				WHEN 'B11'	THEN 'BAN'
				WHEN 'B13'	THEN 'BAN'
				WHEN 'BKY'	THEN 'BAN'
				WHEN 'CCC'	THEN 'CCC'
				WHEN 'CAD'	THEN 'CDR'
				WHEN 'DEC'	THEN 'DEC'
				WHEN 'PDC'	THEN 'PDC'
				WHEN 'PIF'	THEN 'PIF'
				WHEN 'SIF'	THEN 'SIF'
				WHEN 'SKP'	THEN 'SKP'
				ELSE 'ACT'
			END
			/*
			Status codes from Resurgent that I'm not sure what is the correct Latitude Status:
			PPA, PRM, RPA,
			*/

	From Master m where m.number in (select string from dbo.CustomStringToSet(@accountNumbers,'|'))

END

/*
Select top 5 * from master
*/




GO
