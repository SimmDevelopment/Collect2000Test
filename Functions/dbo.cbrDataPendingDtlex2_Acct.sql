SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataPendingDtlex2_Acct] (@AccountId INT)
RETURNS TABLE
AS  
    RETURN 

/* 
	These functions need to be kept in sync with all applicable changes: 
	cbrDataPendingDtlex2
	cbrDataPendingDtlex2_Acct
	cbrDataPendingDtlex2_All
*/
    
	WITH cteExDtl AS (
		SELECT number, debtorid FROM CbrDataExceptionDtlex_Acct(@Accountid)),
	cteData AS (	
		SELECT * FROM cbrDatafx2_Acct(@Accountid)), 
	xcepts AS (	
		SELECT d.number, d.debtorid, 
			ROW_NUMBER() OVER (PARTITION BY x.debtorid ORDER BY CASE WHEN d.seq = 0 THEN 'Acctx' ELSE 'Dbtrx' END ASC) AS topError,
			CASE WHEN d.seq = 0 THEN 'Acctx' ELSE 'Dbtrx' END AS pndexception
		FROM cteExDtl x INNER JOIN cteData d ON d.number = x.number AND d.debtorid = x.debtorid
	)
	SELECT  
		d.number as AccountID, 
		d.debtorID, 
		isnull(h.accountstatus,'') as racctstat,
		isnull(h.compliancecondition,'') as rcompliance,
		isnull(h2.informationindicator,'') as rinfoind,
		isnull(h.specialcomment,'') as rspcomment,
		--case when isnull(x.pndexception,'') <> '' then '' else isnull(pnd.accountstatus,'') end as pacctstat,
		isnull(pnd.accountstatus,'') as pacctstat,
		isnull(pnd.compliancecondition,'') as pcompliance, 
		isnull(pnd2.informationindicator,'') as pinfoind,
		isnull(pnd.specialcomment,'') as pspcomment,
		isnull(d.specialnote,'') as specialnote,
		--case when isnull(x.pndexception,'') <> '' then '' else isnull(d.fileid,'') end as fileid,
		isnull(d.fileid,'') as fileid,
		isnull(d.cbrenabled,'') as cbrenabled,
		isnull(d.portfoliotype,'') as portfoliotype,
		isnull(d.AccountType,'') as AccountType,
		isnull(d.seq,'') as seq,
		isnull(h2.ecoacode,'')  as recoa,
		isnull(pnd2.ecoacode,'') as pecoa,
		isnull(d.responsible,'') as responsible,
		isnull(d.cbrexclude,'') as cbrexclude,
		isnull(d.cbrprevent,'') as cbrprevent,
		isnull(d.isdisputed,'') as isdisputed,
		isnull(d.isdeceased,'') as isdeceased,
		isnull(d.statusisfraud,'') as statusisfraud,
		isnull(d.statuscbrreport,'') as statuscbrreport,
		isnull(d.statuscbrdelete,'') as statuscbrdelete,
		isnull(x.pndexception,'None') as pndexception,		
		case when d.datedeceased is not null then 1 else 0 end as cbrdod,
		isnull(d.cbroverride,'') as cbroverride,
		isnull(d.creditorClass,'') as creditorclass, 
		isnull(d.qlevel,'') as qlevel, 
		d.returned as returned, 
		case when isnull(d.soldportfolio,0) > 0 then 2
				when isnull(d.purchasedportfolio,0) > 0 then 1
				else 0 end as portfolioindicator,
		Case when d.IndustryCode = 'DEBTCOLL' then '3rd' else '1st' end as cbrParty,
		isnull(ex.OutOfStatute,0) as OutOfStatute,
		isnull(ex.MinBalException,0) as MinBalException,
		d.StatusIsPIF,
		d.StatusIsSIF,
		isnull(ex.RptDtException,0) as RptDtException,
		dateadd(d,d.waitDays+d.ExtendDays,d.receiveddate) as nextReporting
	FROM cteData d 
		left outer join tempcbraccounthistory h on d.number = h.accountid and d.fileid = h.fileid
		left outer join tempcbrdebtorhistory h2 on h2.recordid = h.recordid  and h2.debtorID = d.debtorid
		left outer join cbr_accounts pnd on d.number = pnd.accountid 
		left outer join cbr_debtors pnd2 on d.DebtorID = pnd2.debtorID
		left outer join xcepts x on  d.debtorid = x.debtorid and x.topError = 1
		left outer join cbr_exceptions ex on d.number =ex.Number and d.DebtorID = ex.debtorid
	GROUP BY 
		d.number , 
		d.debtorID, 
		isnull(h.accountstatus,'') ,
		isnull(h.compliancecondition,'') ,
		isnull(h2.informationindicator,'') ,
		isnull(h.specialcomment,'') ,
		--case when isnull(x.pndexception,'') <> '' then '' else isnull(pnd.accountstatus,'') end as pacctstat,
		isnull(pnd.accountstatus,'') ,
		isnull(pnd.compliancecondition,'') , 
		isnull(pnd2.informationindicator,'') ,
		isnull(pnd.specialcomment,'') ,
		isnull(d.specialnote,'') ,
		--case when isnull(x.pndexception,'') <> '' then '' else isnull(d.fileid,'') end as fileid,
		isnull(d.fileid,'') ,
		isnull(d.cbrenabled,'') ,
		isnull(d.portfoliotype,'') ,
		isnull(d.AccountType,'') ,
		isnull(d.seq,'') ,
		isnull(h2.ecoacode,'') ,
		isnull(pnd2.ecoacode,'') ,
		isnull(d.responsible,'') ,
		isnull(d.cbrexclude,'') ,
		isnull(d.cbrprevent,''),
		isnull(d.isdisputed,'') ,
		isnull(d.isdeceased,'') ,
		isnull(d.statusisfraud,'') ,
		isnull(d.statuscbrreport,'') ,
		isnull(d.statuscbrdelete,'') ,
		isnull(x.pndexception,'None') ,		
		case when d.datedeceased is not null then 1 else 0 end ,
		isnull(d.cbroverride,'') ,
		isnull(d.creditorClass,'') , 
		isnull(d.qlevel,'') , 
		d.returned , 
		case when isnull(d.soldportfolio,0) > 0 then 2
			 when isnull(d.purchasedportfolio,0) > 0 then 1
			 else 0 end,
		Case when d.IndustryCode = 'DEBTCOLL' then '3rd' else '1st' end ,
		isnull(ex.OutOfStatute,0),
		isnull(ex.MinBalException,0),
		d.StatusIsPIF,
		d.StatusIsSIF,
		isnull(ex.RptDtException,0),
		dateadd(d,d.waitDays+d.ExtendDays,d.receiveddate)
	;

GO
