SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- =============================================
-- Author:		Ibrahim Hashimi
-- ALTER  date: 01/30/2006
-- Description:	
-- =============================================
/*
exec Custom_ReportSherman_Pa2 @startDate='20060406', @enddate='20060412', @customer='0001401'
*/
CREATE    PROCEDURE [dbo].[Custom_ReportSherman_Pa2]
	-- Add the parameters for the stored procedure here
	@startDate as DateTime,
	@endDate as DateTime,
	@customer as varchar(7)
AS
BEGIN
Declare @misappliedStr varchar(50)
set @misappliedStr = 'MISAPPLIED'
	SET NOCOUNT ON;

--======================================================================================================================
--SECTION 1
	Select	m.account				as [Account],
			isnull(ph.paid1,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
			'NRV'				as [TranzCode],
			ph.datepaid			as [TranzDate],
			isnull(ph.fee1,0)		as [CommissionAmount],
			m.id2				as [BatchID],
			ph.paytype			as [ReferenceText],		--Should we put something else here?
			m.id1				as [AccountID],			
			isnull(ph.CheckNbr,'')		as [CheckNumber],
			ph.uid				as [AgencyTranzID],
			1				as [Section]
	From PayHistory ph with (nolock)
	join Master m with (nolock) on m.number=ph.number
	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
	and Upper(ph.comment)=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PU','PA')
	
	UNION

	Select	m.account			as [Account],
			isnull(ph.paid1,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
			'PMT'				as [TranzCode],
			ph.datepaid			as [TranzDate],
			isnull(ph.fee1,0)		as [CommissionAmount],
			m.id2				as [BatchID],
			ph.paytype			as [ReferenceText],		--Should we put something else here?
			m.id1				as [AccountID],			
			isnull(ph.CheckNbr,'')			as [CheckNumber],
			ph.uid				as [AgencyTranzID],
			2				as [Section]
	From PayHistory ph with (nolock)
	join Master m with (nolock) on m.number=ph.number
	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
	AND Upper(ph.comment)!=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PU','PA')
--select distinct batchtype from PayHistory order by batchtype desc
	UNION

	Select	m.account				as [Account],
			isnull(ph.paid1,0)		as [TranzAmount],		--is this the right amount?
			--ph.Comment			as [TranzCode],			
			'PRV'				as [TranzCode],
			ph.datepaid			as [TranzDate],
			isnull(ph.fee1,0)		as [CommissionAmount],
			m.id2				as [BatchID],
			ph.paytype			as [ReferenceText],		--Should we put something else here?
			m.id1				as [AccountID],			
			isnull(ph.CheckNbr,'')		as [CheckNumber],
			ph.uid				as [AgencyTranzID],
			3				as [Section]
	From PayHistory ph with (nolock)
	join Master m with (nolock) on m.number=ph.number
	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
	AND Upper(ph.comment)!=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PUR','PAR')



--They only want Payment(princple) to be reported 05/26/2006 Scott
--	UNION
----======================================================================================================================
----SECTION 2
--	Select	m.account			as [Account],
--			isnull(ph.paid2,0)		as [TranzAmount],		--is this the right amount?
--			--ph.Comment			as [TranzCode],			
--			'FREV'				as [TranzCode],			--what should this be
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
--	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	and Upper(ph.comment)=@misappliedStr and ph.paid2>0 and ph.batchtype in ('PU','PA')
--	
--	UNION
--
--	Select	m.account			as [Account],
--			isnull(ph.paid2,0)		as [TranzAmount],		--is this the right amount?
--			--ph.Comment			as [TranzCode],			
--			'CCIP'				as [TranzCode],
--			ph.datepaid			as [TranzDate],--
--			isnull(ph.fee2,0)		as [CommissionAmount],
--			m.id2				as [BatchID],
--			ph.paytype			as [ReferenceText],		--Should we put something else here?
--			m.id1				as [AccountID],			
--			isnull(ph.CheckNbr,'')		as [CheckNumber],
--			ph.uid				as [AgencyTranzID],
--			5				as [Section]
--	From PayHistory ph with (nolock)
--	join Master m with (nolock) on m.number=ph.number
--	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid2>0 and ph.batchtype in ('PU','PA')
----select distinct batchtype from PayHistory order by batchtype desc
--	UNION
--
--	Select	m.account			as [Account],
--			isnull(ph.paid2,0)		as [TranzAmount],		--is this the right amount?
--			--ph.Comment			as [TranzCode],			
--			'CCIR'				as [TranzCode],
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
--	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PUR','PAR')
--
--	UNION
----======================================================================================================================
----SECTION 3
--	Select	m.account			as [Account],
--			isnull(ph.paid3,0)		as [TranzAmount],		--is this the right amount?
--			--ph.Comment			as [TranzCode],			
--			'PREV'				as [TranzCode],
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
--	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	and Upper(ph.comment)=@misappliedStr and ph.paid2>0 and ph.batchtype in ('PU','PA')
--	
--	UNION
--
--	Select	m.account			as [Account],
--			isnull(ph.paid3,0)		as [TranzAmount],		--is this the right amount?
--			--ph.Comment			as [TranzCode],			
--			'PMT'				as [TranzCode],
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
--	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid3>0 and ph.batchtype in ('PU','PA')
----select distinct batchtype from PayHistory order by batchtype desc
--	UNION
--
--	Select	m.account			as [Account],
--			isnull(ph.paid3,0)		as [TranzAmount],		--is this the right amount?
--			--ph.Comment			as [TranzCode],			
--			'NSF'				as [TranzCode],
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
--	where ph.entered between @startDate and @endDate and m.customer=@customer and ph.customer=@customer
--	AND Upper(ph.comment)!=@misappliedStr and ph.paid1>0 and ph.batchtype in ('PUR','PAR')
--
--
--


END





GO
