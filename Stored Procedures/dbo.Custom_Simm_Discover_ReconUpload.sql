SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
[dbo].[Custom_Simm_Discover_ReconUpload]
'0000000|0000001', 
'2001-01-01',
'2007-12-01'
*/

CREATE PROCEDURE [dbo].[Custom_Simm_Discover_ReconUpload]
@customer varchar(8000),
@dateBegin datetime,
@dateEnd datetime

AS
-- Variable declaration.
DECLARE @runDate datetime
SET @runDate=getdate()

BEGIN

	Select d.agencycode as recovererCode, m.account as accountNumber, case when m.current0 < 0.00 then 0.00 Else m.current0 End as balance, 
	Replace(Convert(varchar(10), @dateBegin, 101), '/', '') as beginDate,      
	Replace(Convert(varchar(10), @dateEnd, 101), '/', '') as endDate    

    From master m with (nolock)
	inner join discover_customerMapping d with (nolock)
	on d.customer = m.customer
	Where m.customer in (SELECT string from [dbo].[StringToSet](@Customer, '|'))
	and (m.status not in ('SIF', 'PIF') and m.qlevel not in ('999', '998'))
     or (m.status in ('PIF', 'SIF') and datediff(day, closed, @runDate) <= 30) 
 
END
GO
