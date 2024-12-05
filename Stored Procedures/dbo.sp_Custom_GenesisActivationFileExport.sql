SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Custom_GenesisActivationFileExport]
@customer varchar(8000),
@beginDate datetime,
@endDate datetime,
@pl95Date datetime
AS
BEGIN
	DECLARE @runDate as datetime
	SET @runDate = getdate()
	
	SET @endDate = CAST(CONVERT(varchar(10),@endDate,20) + ' 23:59:59.000' as datetime)	
	SELECT 
	CONVERT(varchar(8),@runDate,112) as fileDate,
	m.account as account,
	m.id2 as placementId,
	m.current0 as currentBalance,
	m.current1 as principleBalance,
	m.current2+m.current3+m.current4+m.current5+m.current6+m.current7+m.current8+m.current9+m.current10 as otherBalance,
	CONVERT(varchar(8),@pl95Date,112) as pl95Date
	FROM master m WITH(NOLOCK)
	WHERE m.received BETWEEN @beginDate AND @endDate AND
	m.customer IN(SELECT string FROM dbo.CustomStringToSet(@customer, '|'))
END
GO
