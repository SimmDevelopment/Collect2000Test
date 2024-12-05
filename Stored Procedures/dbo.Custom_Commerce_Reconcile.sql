SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_Commerce_Reconcile]

	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)

AS
BEGIN

	SELECT
		'REC' AS [RecordID],
		m.account AS [Account],
		m.current0 AS [Balance],
		'PRN' AS [BalanceType],
		'SIMMSMAIN' AS [Contract],
		'' AS [Stategy],
		'PRIMARY' AS [Placement],
		m.id1 AS [Product]
		
		FROM master m with (nolock)
		WHERE m.received BETWEEN @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND m.returned is null


END
GO
