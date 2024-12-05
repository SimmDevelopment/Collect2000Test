SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- Removed Declined pay statuses from sending the PRM code 6/3/2014. per Jeff S.
-- Added CCS to send code CCC to Resurgent per Heather M. 7/14/2014.
-- =============================================
CREATE FUNCTION [dbo].[GetShermanStatus]
(
	@status varchar(5)
)
RETURNS varchar(5)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @retStatus varchar(5)

	select @retStatus = 
		Case(@status)
					when 'B07' then 'BAN'
					WHEN 'B11' THEN 'BAN'
					when 'B13' then 'BAN'
					when 'BKY' then 'BAN'
					when 'DEC' then 'DEC'
					when 'AEX' then 'AEX'
					when 'EXH' then 'AEX'
					WHEN 'ATY' then 'ATT'
					WHEN 'CCC' THEN 'CCC'
					WHEN 'CND' THEN 'CDR'
					WHEN 'CAD' THEN 'CDR'
					when 'PCC' then 'PDC'
					WHEN 'PDC' THEN 'PDC'
					WHEN 'PIF' THEN 'PIF'
					WHEN 'PPA' THEN 'PRM'
					WHEN 'PTP' THEN 'PRM'
					When 'STL' then 'PRM'
					WHEN 'SIF' THEN 'SIF'
					WHEN 'SKP' THEN 'SKP'
					WHEN 'UTL' THEN 'SKP'
					WHEN 'VDS' THEN 'VDS'
					when 'CLM' then 'DCF'
					WHEN 'DSP' THEN 'WDS'
					WHEN 'FRD' THEN 'WDS'
					WHEN 'PPP' THEN 'PPP'
					WHEN 'RSK' THEN 'AEX'
					WHEN 'WDS' THEN 'WDS'
					WHEN 'RFP' THEN 'AEX'
					WHEN 'CCS' THEN 'CCC'
					else 'ACT'
		End

	-- Return the result of the function
	RETURN @retStatus

END


GO
