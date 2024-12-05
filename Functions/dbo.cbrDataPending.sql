SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[cbrDataPending] ( @AccountId INT)
RETURNS TABLE
AS  
    RETURN 

						
		select racctstat, rcompliance,
		rinfoind, rspcomment,
		case when pndexception in ('Acctx','Dbtrx') then '' else pacctstat end as pacctstat,
		pcompliance, 
		pinfoind, pspcomment,
		specialnote,case when pndexception <> '' then '' else fileid end as fileid, cbrenabled,
		portfoliotype, AccountType,
		seq, recoa,
		pecoa, responsible, cbrexclude, cbrprevent,
		isdisputed, isdeceased, statusisfraud, statuscbrreport,
		statuscbrdelete, pndexception,		
		cbrdod, cbroverride,
		creditorclass, case when qlevel = '999' and isdate(returned)=1 then 'Yes' else 'No' end as returned,
		count(*) as rptLines

		from cbrDataPendingDtlex(@AccountID) p 

		group by racctstat, rcompliance,
				rinfoind, rspcomment,
				case when pndexception in ('Acctx','Dbtrx') then '' else pacctstat end ,
				pcompliance, 
				pinfoind, pspcomment,
				specialnote,case when pndexception <> '' then '' else fileid end, cbrenabled,
				portfoliotype, AccountType,
				seq, recoa,
				pecoa, responsible, cbrexclude, cbrprevent,
				isdisputed, isdeceased, statusisfraud, statuscbrreport,
				statuscbrdelete, pndexception,		
				cbrdod, cbroverride,
				creditorclass, case when qlevel = '999' and isdate(returned)=1 then 'Yes' else 'No' end;


GO
