SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- =============================================
-- Author:		Jeff Mixon
-- ALTER  date:	12/29/2007
-- Description:	Commerce(TSYS) Export
--Modified by: Brian Meehan
--Changes: Removed lines that would grab the product id from the wrong fields.  The product ID is in the id1 field for this customer
-- =============================================
/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20050101'
set @endDate='20061221'
--set @endDate='12/20/2006 12:15:00'
set @customer='0000001|0000002|0000003|0000004|0000000|'
exec Custom_Commerce_Payment @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE      PROCEDURE [dbo].[Custom_Commerce_Payment]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN

	--====== Payment Record =====---
	SELECT
		'PMT' AS [RecordType],
		--(select top 1 TheData from MiscExtra --rem Brian Meehan 8/2/2007
		 --where Title = 'CommerceProductID' and number = m.number)  --rem Brian Meehan 8/2/2007
		m.id1 AS [ProductID],
		m.account AS [Account],
		CASE WHEN p.batchtype IN ('PU', 'PA', 'PC')
		THEN 'CK'
		WHEN p.paytype LIKE '%NSF%' THEN 'NSF'
		ELSE 'COR' END AS [TransType],
		p.datepaid AS [DatePaid], --use twice
		p.paid1 AS [Amount],
		case when p.batchtype in ('PU','PA','PC') then 'SIMMS PAYMENT' 
	   	     when p.paytype LIKE '%NSF%' THEN 'SIMMS NSF' 
		     else 'SIMMS CORRECTION' 
		end AS [Reference],
--		isnull(CASE WHEN p.ReverseOfUID > 0 THEN r.datepaid
--		     ELSE NULL 
--		END,'') 
		'' AS [RDatePaid],
		CASE WHEN p.ReverseOfUID > 0 THEN r.comment
		     ELSE '' 
		END AS [RComment]
		

		FROM master m with (nolock)
		JOIN payhistory p with (nolock)
		ON m.number=p.number
		LEFT JOIN payhistory r with (nolock)
		ON p.uid = r.reverseofuid
		WHERE p.datepaid between @startDate AND @endDate
		AND m.closed is null
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

END
GO
