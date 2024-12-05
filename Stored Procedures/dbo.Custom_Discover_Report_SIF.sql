SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Discover_Report_SIF]
@startDate datetime,
@endDate datetime

AS

SELECT 'Client' = case customer when '0000711' then 'Discover Card - 13SM' when '0000785' then 'Discover Card - 15SM' when '0000926' then 'Discover Card - 42SM' when '0000955' then 'Discover Card - 12SM' end, account [Account#], name [CM Name], original [Orig Bal], current0 [Curr Bal], 
	ABS(paid) [SIF Amt], ABS(paid) / original [SIF%], closed [Date SIF], received [Date Placed]
FROM master with (nolock)
WHERE customer IN (SELECT CustomerID FROM Fact with (nolock) WHERE CustomGroupID = 28) AND closed BETWEEN @startDate AND @endDate AND 
	status = 'SIF'
order by client
GO
