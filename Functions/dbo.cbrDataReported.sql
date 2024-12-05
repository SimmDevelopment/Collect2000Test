SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataReported] ( @AccountId INT)
RETURNS TABLE
AS  
    RETURN 
		with xcepts as (	select d.debtorid, ROW_NUMBER() OVER (PARTITION BY x.debtorid ORDER BY case when d.seq = 0 then 'Acctx' Else 'Dbtrx' end ASC) AS topError,
								case when d.seq = 0 then 'Acctx' Else 'Dbtrx' end as pndexception
								from CbrDataExceptionDtlex(null) x inner join cbrDatafx(null) d on d.number = x.number and  d.debtorid = x.debtorid
							where x.number = @AccountID 
							union all
							select d.debtorid, ROW_NUMBER() OVER (PARTITION BY x.debtorid ORDER BY case when d.seq = 0 then 'Acctx' Else 'Dbtrx' end ASC) AS topError,
								case when d.seq = 0 then 'Acctx' Else 'Dbtrx' end as pndexception
								from CbrDataExceptionDtlex(null) x inner join cbrDatafx(null) d on d.number = x.number and  d.debtorid = x.debtorid
							where @AccountID is null
						)

		select h.accountstatus as racctstat,h.compliancecondition as rcompliance,
		h2.informationindicator as rinfoind,h.specialcomment as rspcomment,
		pnd.accountstatus as pacctstat,pnd.compliancecondition as pcompliance, 
		pnd2.informationindicator as pinfoind,pnd.specialcomment as pspcomment,
		d.specialnote,h.fileid,d.cbrenabled,d.cbrportfoliotype,d.cbrAccountType,d.debtorseq,
		h2.ecoacode as recoa,pnd2.ecoacode as pecoa,d.debtorresponsible,d.cbrexclude,d.cbrprevent,
		d.isdisputed,d.isdeceased,d.statusisfraud,d.statuscbrreport,d.statuscbrdelete,
		x.pndexception,		
		case when d.datedeceased is not null then 1 else 0 end as cbrdod,d.cbroverride, 
		count(*) as rptLines
		
		from cbrdatacycleend d 
		left outer join cbraccounthistory(null) h on d.number = h.accountid and d.fileid = h.fileid
		left outer join cbrdebtorhistory(null) h2 on  h.recordID = h2.recordID and h2.debtorID = d.DebtorID 
		left outer join cbr_accounts pnd on d.number = pnd.accountid
		left outer join cbr_debtors pnd2 on h2.debtorid = pnd2.debtorid
		left outer join xcepts x on d.debtorid = x.debtorid and x.topError = 1
		where @AccountId = d.number or @AccountId is null
		
		group by h.accountstatus,h.compliancecondition,h2.informationindicator,h.specialcomment,
				 pnd.accountstatus,pnd.compliancecondition, pnd2.informationindicator,pnd.specialcomment,
				 d.specialnote,h.fileid,d.cbrenabled,d.cbrportfoliotype,d.cbrAccountType,d.debtorseq,h2.ecoacode,
				 pnd2.ecoacode,d.debtorresponsible,d.cbrexclude,d.cbrprevent,d.isdisputed,d.isdeceased,
				 d.statusisfraud,d.statuscbrreport,d.statuscbrdelete,
				 x.pndexception,
				 case when d.datedeceased is not null then 1 else 0 end, d.cbroverride;


GO
