SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*

DECLARE @invoice varchar(8000)
SET @invoice = '10263|'
EXECUTE [Custom_ReportSherman_Pa2_Invoice] @invoice

*/


-- =============================================
-- Author:		Ibrahim Hashimi
-- ALTER  date: 02/08/2007 by Scott Gorman
-- Description:	
-- =============================================
/*
exec Custom_ReportSherman_Pa2_Invoice @invoic=13722
*/
CREATE              PROCEDURE [dbo].[Custom_ReportSherman_Pa2_Invoice]
	@invoice varchar(8000)
	-- Add the parameters for the stored procedure here
--	,@startDate as DateTime
--	,@endDate as DateTime
--	@customer as varchar(7)
AS
BEGIN
Declare @misappliedStr varchar(50)
set @misappliedStr = 'MISAPPLIED'
	SET NOCOUNT ON;

--======================================================================================================================
--SECTION 1
	Select	m.account				as [Account],
			isnull((dbo.Custom_CalculatePaymentTotalPaid(ph.uid)),0)--  -isnull(ph.overpaidamt,0)	
                                                	as [TranzAmount],	
--			isnull(ph.paid1,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
			'NRV'				as [TranzCode],
			ph.datepaid			as [TranzDate],
			isnull(ph.fee1,0)+ isnull(ph.fee2,0) +
                        isnull(ph.fee3,0)+ isnull(ph.fee4,0) +
                        isnull(ph.fee5,0)+ isnull(ph.fee6,0) +
                        isnull(ph.fee7,0)+ isnull(ph.fee8,0) +
                        isnull(ph.fee9,0)+ isnull(ph.fee10,0)	
                                                        as [CommissionAmount],

--			isnull(ph.fee1,0)		as [CommissionAmount],
			isnull(m.id2,m.account)		as [BatchID],
			ph.paytype			as [ReferenceText],		--Should we put something else here?
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID') as [AccountID],			
			isnull(ph.CheckNbr,'')		as [CheckNumber],
			ph.uid				as [AgencyTranzID],
			1				as [Section]
	From PayHistory ph with (nolock)
	join Master m with (nolock) on m.number=ph.number
	where
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
	ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') )
	and Upper(ph.comment)=@misappliedStr and ph.batchtype in ('PU','PA')
--	and Upper(ph.comment)=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PU','PA')
	and dbo.Custom_CalculatePaymentTotalPaid(ph.uid) <> 0
	
	UNION

	Select	m.account			        as [Account],
			isnull((dbo.Custom_CalculatePaymentTotalPaid(ph.uid)),0)--  -isnull(ph.overpaidamt,0)	
                                                	as [TranzAmount],	
--			isnull(ph.paid1,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
			'PMT'				as [TranzCode],
			ph.datepaid			as [TranzDate],
			isnull(ph.fee1,0)+ isnull(ph.fee2,0) +
                        isnull(ph.fee3,0)+ isnull(ph.fee4,0) +
                        isnull(ph.fee5,0)+ isnull(ph.fee6,0) +
                        isnull(ph.fee7,0)+ isnull(ph.fee8,0) +
                        isnull(ph.fee9,0)+ isnull(ph.fee10,0)	
                                                        as [CommissionAmount],
--			isnull(ph.fee1,0)		as [CommissionAmount],
			isnull(m.id2,m.account)				as [BatchID],
			ph.paytype			as [ReferenceText],		--Should we put something else here?
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AccountID],			
			isnull(ph.CheckNbr,'')			as [CheckNumber],
			ph.uid				as [AgencyTranzID],
			2				as [Section]
	From PayHistory ph with (nolock)
	join Master m with (nolock) on m.number=ph.number
	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
	ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') )
	AND Upper(ph.comment)!=@misappliedStr and ph.batchtype in ('PU','PA')
	and dbo.Custom_CalculatePaymentTotalPaid(ph.uid) <> 0
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PU','PA')
--select distinct batchtype from PayHistory order by batchtype desc
	UNION

	Select	m.account				as [Account],
			isnull((dbo.Custom_CalculatePaymentTotalPaid(ph.uid)),0)--  -isnull(ph.overpaidamt,0)	
                                                	as [TranzAmount],	
--			isnull(ph.paid1,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
			'NSF'				as [TranzCode],
			ph.datepaid			as [TranzDate],
			isnull(ph.fee1,0)+ isnull(ph.fee2,0) +
                        isnull(ph.fee3,0)+ isnull(ph.fee4,0) +
                        isnull(ph.fee5,0)+ isnull(ph.fee6,0) +
                        isnull(ph.fee7,0)+ isnull(ph.fee8,0) +
                        isnull(ph.fee9,0)+ isnull(ph.fee10,0)	
                                                        as [CommissionAmount],

--			isnull(ph.fee1,0)		as [CommissionAmount],
			isnull(m.id2,m.account)				as [BatchID],
			ph.paytype			as [ReferenceText],		--Should we put something else here?
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AccountID],			
			isnull(ph.CheckNbr,'')		as [CheckNumber],
			ph.uid				as [AgencyTranzID],
			3				as [Section]
	From PayHistory ph with (nolock)
	join Master m with (nolock) on m.number=ph.number
	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
	ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') )
	AND Upper(ph.comment)!=@misappliedStr and ph.batchtype in ('PUR','PAR')
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PUR')
	AND ph.iscorrection = 0
	and dbo.Custom_CalculatePaymentTotalPaid(ph.uid) <> 0

	UNION
	Select	m.account				as [Account],
			isnull((dbo.Custom_CalculatePaymentTotalPaid(ph.uid)),0)--  -isnull(ph.overpaidamt,0)	
                                                	as [TranzAmount],	
--			isnull(ph.paid1,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
			'PRV'				as [TranzCode],
			ph.datepaid			as [TranzDate],
			isnull(ph.fee1,0)+ isnull(ph.fee2,0) +
                        isnull(ph.fee3,0)+ isnull(ph.fee4,0) +
                        isnull(ph.fee5,0)+ isnull(ph.fee6,0) +
                        isnull(ph.fee7,0)+ isnull(ph.fee8,0) +
                        isnull(ph.fee9,0)+ isnull(ph.fee10,0)	
                                                        as [CommissionAmount],

--			isnull(ph.fee1,0)		as [CommissionAmount],
			isnull(m.id2,m.account)				as [BatchID],
			ph.paytype			as [ReferenceText],		--Should we put something else here?
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AccountID],			
			isnull(ph.CheckNbr,'')		as [CheckNumber],
			ph.uid				as [AgencyTranzID],
			3				as [Section]
	From PayHistory ph with (nolock)
	join Master m with (nolock) on m.number=ph.number
	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
	ph.invoice in (select string from dbo.CustomStringToSet(@invoice,'|') )
	AND Upper(ph.comment)!=@misappliedStr and ph.batchtype in ('PAR','PUR')
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PAR')
	AND ph.iscorrection = 1
	and dbo.Custom_CalculatePaymentTotalPaid(ph.uid) <> 0
--======================================================================================================================
--SECTION 2
--	Select	m.account			as [Account],
--			isnull(ph.paid2,0)		as [TranzAmount],		--is this the right amount?
--			--ph.Comment			as [TranzCode],			
--			'IREV'				as [TranzCode],
--			ph.datepaid			as [TranzDate],
--			isnull(ph.fee2,0)		as [CommissionAmount],
--			m.id2				as [BatchID],
--			ph.paytype			as [ReferenceText],		--Should we put something else here?
--			m.id1				as [AccountID],			
--			isnull(ph.CheckNbr,'')		as [CheckNumber],
--			ph.uid				as [AgencyTranzID],
--			4				as [Section]
--	From PayHistory ph with (nolock)
--	join Master m with (nolock) on m.number=ph.number
--	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	ph.invoice=@invoice
--	and Upper(ph.comment)=@misappliedStr and ph.paid2>0 and ph.batchtype in ('PU','PA')
	
--	UNION

--	Select	m.account			as [Account],
--			isnull(ph.paid2,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
--			'IPMT'				as [TranzCode],
--			ph.datepaid			as [TranzDate],
--			isnull(ph.fee2,0)		as [CommissionAmount],
--			m.id2				as [BatchID],
--			ph.paytype			as [ReferenceText],		--Should we put something else here?
--			m.id1				as [AccountID],			
--			isnull(ph.CheckNbr,'')		as [CheckNumber],
--			ph.uid				as [AgencyTranzID],
--			5				as [Section]
--	From PayHistory ph with (nolock)
--	join Master m with (nolock) on m.number=ph.number
--	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	ph.invoice=@invoice
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid2>0 and ph.batchtype in ('PU','PA')
--select distinct batchtype from PayHistory order by batchtype desc
--	UNION

--	Select	m.account			as [Account],
--			isnull(ph.paid2,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
--			'INSF'				as [TranzCode],
--			ph.datepaid			as [TranzDate],
--			isnull(ph.fee2,0)		as [CommissionAmount],
--			m.id2				as [BatchID],
--			ph.paytype			as [ReferenceText],		--Should we put something else here?
--			m.id1				as [AccountID],			
--			isnull(ph.CheckNbr,'')		as [CheckNumber],
--			ph.uid				as [AgencyTranzID],
--			6				as [Section]
--	From PayHistory ph with (nolock)
--	join Master m with (nolock) on m.number=ph.number
--	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	ph.invoice=@invoice
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid2>0 and ph.batchtype in ('PUR','PAR')

--	UNION
--======================================================================================================================
--SECTION 3
--	Select	m.account			as [Account],
--			isnull(ph.paid3,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
--			'CREV'				as [TranzCode],
--			ph.datepaid			as [TranzDate],
--			isnull(ph.fee3,0)		as [CommissionAmount],
--			m.id2				as [BatchID],
--			ph.paytype			as [ReferenceText],		--Should we put something else here?
--			m.id1				as [AccountID],			
--			isnull(ph.CheckNbr,'')		as [CheckNumber],
--			ph.uid				as [AgencyTranzID],
--			7				as [Section]
--	From PayHistory ph with (nolock)
--	join Master m with (nolock) on m.number=ph.number
--	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	ph.invoice=@invoice
--	and Upper(ph.comment)=@misappliedStr and ph.paid3>0 and ph.batchtype in ('PU','PA')
	
--	UNION

--	Select	m.account			as [Account],
--			isnull(ph.paid3,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
--			'CPMT'				as [TranzCode],
--			ph.datepaid			as [TranzDate],
--			isnull(ph.fee3,0)		as [CommissionAmount],
--			m.id2				as [BatchID],
--			ph.paytype			as [ReferenceText],		--Should we put something else here?
--			m.id1				as [AccountID],			
--			isnull(ph.CheckNbr,'')		as [CheckNumber],
--			ph.uid				as [AgencyTranzID],
--			8				as [Section]
--	From PayHistory ph with (nolock)
--	join Master m with (nolock) on m.number=ph.number
--	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	ph.invoice=@invoice
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid3>0 and ph.batchtype in ('PU','PA')
--select distinct batchtype from PayHistory order by batchtype desc
--	UNION

--	Select	m.account			as [Account],
--			isnull(ph.paid3,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
--			'CNSF'				as [TranzCode],
--			ph.datepaid			as [TranzDate],
--			isnull(ph.fee3,0)		as [CommissionAmount],
--			m.id2				as [BatchID],
--			ph.paytype			as [ReferenceText],		--Should we put something else here?
--			m.id1				as [AccountID],			
--			isnull(ph.CheckNbr,'')		as [CheckNumber],
--			ph.uid				as [AgencyTranzID],
--			9				as [Section]
--	From PayHistory ph with (nolock)
--	join Master m with (nolock) on m.number=ph.number
--	where 
	--ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	ph.invoice=@invoice
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid3>0 and ph.batchtype in ('PUR','PAR')
END














GO
