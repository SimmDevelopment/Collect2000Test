SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Brian Meehan, Simm Associates, Inc.
-- Create date: 4/20/2013
-- Description:	Exports all information required for the export Upload Payments in Exchange
-- =============================================


/* Use below for testing output

declare @customer varchar(8000)
declare @invoice varchar(8000)

set @customer='256001|256002'
set @invoice = '23219|23220'
exec Custom_RTR_Chase_Auto_Upload_Payments @customer=@customer, @invoice = @invoice
*/
CREATE                        PROCEDURE [dbo].[Custom_RTR_Chase_Auto_Upload_Payments]
	 @customer varchar(8000),
	 @invoice VARCHAR(8000)

AS
BEGIN

DECLARE @id2 VARCHAR(50)
declare cur cursor for 
	
	--load the cursor with the alpha codes from the customer table
	SELECT DISTINCT AlphaCode FROM customer WITH (NOLOCK) WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	
open cur

--get the information from the cursor and into the variables
fetch from cur into @id2
while @@fetch_status = 0 begin

			IF EXISTS (SELECT * FROM tempdb.sys.tables WHERE name LIKE '#tmpcms_payment%')
			DROP TABLE #tmpcms_payment
			
			create table #tmpcms_payment (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)

			INSERT INTO #tmpcms_payment (number,amount)
			SELECT distinct number,sum(case when batchtype in ('PAR','PCR','PUR') THEN (-1*totalpaid) ELSE totalpaid END)
			FROM payhistory with(nolock)
			WHERE customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND Invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
			GROUP BY number

			

SELECT DISTINCT --Header Record
	--RecordCode
	--Filler
	cast(getdate() as smalldatetime) as [Date],
	--Type=1 hardcoded in Exchange C# script
	--SourceCode=1 hardcoded in Exchange C# script
	m.customer, --used for troubleshooting filtered out in Exchange C# script
	c.AlphaCode AS [AgencyCode], --Entered in the latitude customer properties Alpha Code field
	'Real Time Resolutions' AS [AgencyName],
	--Rec1
	--Get number of record 1 records
	(select count(*) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number INNER JOIN customer cu WITH (NOLOCK) ON m2.customer = cu.customer WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer AND cu.AlphaCode = @id2) AS [NumRec1],
	--Get total amount of record 1 payment, uses Total amount paid reversals negative payments positive amounts
	(select ISNULL(SUM(CASE WHEN p.batchtype LIKE '%r' THEN -(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) ELSE (dbo.Custom_CalculatePaymentTotalPaid (p.uid)) END), 0) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number INNER JOIN customer cu WITH (NOLOCK) ON m2.customer = cu.customer WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer AND cu.AlphaCode = @id2) AS [TotalPay],
	--Rec2
	--Rec3
	--Rec4
	--Rec5
	--Filler
	'03300' AS [BankID] --Change bank ID when testing is over to production bank ID
	--Fills
FROM master m with (nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
left outer JOIN #tmpcms_payment t1 ON m.number=t1.number
where m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.customer is not NULL AND c.AlphaCode = @id2


SELECT --Payment Record
	'1' AS [RecordCode], --Always a 1
	p.datepaid, --Payment Date YYYYMMDD
	case when p.batchtype in ('PU', 'PA') then '1' --1 for Payment + for Payment - for Correction
		WHEN p.batchtype IN ('PUR', 'PAR') AND p.iscorrection = 1 THEN '1' --make sure to mark is correction box when reversing payment in latitude
		ELSE '3' END as 'paymenttype', --3 for NSF
	'1' as 'sourcecode', --Always a 1
	case when p.batchtype in ('PU', 'PA') then 'pymt from ' + c.AlphaCode --Reference field, this is for a payment
		WHEN p.batchtype IN ('PUR', 'PAR') AND p.iscorrection = 1 THEN 'correction from ' + c.AlphaCode -- This is for a correction
		ELSE 'NSF pymt from ' + c.AlphaCode END as 'reference', -- This is for a NSF
	dbo.Custom_CalculatePaymentTotalPaid (p.uid) as amountpaid, --Signed amount paid
	
	case when p.batchtype in ('PUR','PAR') then '-' else '0' end as [sign], --signed amount paid
	dbo.Custom_CalculatePaymentTotalPaid (p.uid )as amountpaid,  -- signed amount paid
	'00000000.00' as [paid1], -- break down of payments is not used but for future use this is a placeholder
	'00000000.00' as [paid3], -- break down of payments is not used but for future use this is a placeholder
	'00000000.00' as [paid2], -- break down of payments is not used but for future use this is a placeholder
	'00000000.00' as [paid10], -- break down of payments is not used but for future use this is a placeholder
	case when p.batchtype in ('PUR','PAR') and p.fee6 <> 0 then '-' else '0' end as [sign4], --signed fee amount
	p.fee6 as [fee6], --signed fee amount
	'N' as fee,--Find fee due agency N for Net Y for Gross
    p.batchtype, --batchtype in latitude for reference only
	' ' AS id1,--not needed but placeholder if needed in the future
	m.account --account number
FROM PayHistory p with (nolock)
JOIN Master m with (nolock)
ON m.Number=p.Number INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
AND p.batchtype IN ('PU', 'PA', 'PUR', 'PAR')
AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
AND c.alphacode = @id2

fetch from cur into @id2
	
end
DROP TABLE #tmpcms_payment
--close and free up all the resources.
close cur
deallocate cur
end
GO
