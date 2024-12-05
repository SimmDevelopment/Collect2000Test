SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[cbrDataSummary](@Accountid int)

RETURNS TABLE AS
RETURN

	with cbrsummary as (
	select AccountID, 
			DebtorID, 
			Seq as DebtorSeq,
			case when pSpcomment != '' then 'Special Comment Set\t\n;' else '' end +
			Case when OutOfStatute=1 then 'Out of Statute\t\n' 
				 when cbrEnabled=0 then 'Client does not allow credit bureau reporting\t\n' 
				 when StatusCbrReport=0 then 'Status code configured to not report\t\n'
				 when rAcctStat='' and pAcctStat='' then 'Not Reported\t\n' +
				 	case when StatusIsPif=1 and cbrPrevent=0 and cbrExclude=0 and statuscbrreport=1 then 'PIF prior to first report\t\n'
						 when StatusIsSif=1 and cbrPrevent=0 and cbrExclude=0 and statuscbrreport=1 then 'SIF prior to first report\t\n' 
						 when MinBalException=1 then 'Minimum balance not met\t\n'
					  	 when RptDtException=1 and statuscbrreport=1 then 'Will Evaluate on '+convert(varchar(10),nextReporting,101) + '\t\n'
				 		 when pndException!='None' then 'Invalid Data\t\n'
						 else 'Not Yet Evaluated\t\n'		
				 	end
				 when rAcctStat!='' then 'Reported\t\n' +
					case when recoa='X' or rInfoInd!='' then
							case when rInfoInd!='' then isnull(rII.[Description],'Info Indicator ' + rInfoInd) + '\t\n' else '' end +
							case when recoa='X' then 'Deceased\t\n' else '' end
						 else
							case when rAcctStat in ('DA','DF') then 
									case when recoa='Z' then 'Delete\t\n' 
										 when recoa='T' then 'Terminate\t\n' 
										 else rAcctStat + '\t\n'
									end 
								 when rAcctStat in ('62','64') then 'Paid In Full\t\n' 
								 else 
									case when rCompliance = '' then 
											case when cbrParty='3rd' then 'Open Collection\t\n' else 'Charge-Off\t\n' end  
										 else isnull(rCC.[Description],'Compliance Condition ' + rCompliance) + '\t\n' 
									end
							end 
					end
				 when pAcctStat!='' then 'Will Report\t\n' +
				 	case when pAcctStat not in ('DA','DF','62','64','') and pCompliance = '' 
							  and pInfoInd <> ('Q') then case when cbrParty='3rd' then 'Open Collection\t\n' else 'Charge-Off\t\n' end
						 when pAcctStat in ('62','64') and (pSpcomment='') then  
							case when cbrParty='3rd' then  'Paid in Full, was a collection account\t\n'	
								 else 'Paid in Full, was a Charge-Off\t\n' 
							end			
						 when pAcctStat in ('62','64') and pSpcomment='AU' then 
							case when cbrParty='3rd' then 'Settled in Full, was a collection account\t\n' 
								 else 'Settled in Full, was a Charge-Off\t\n' 
							end
						 when pCompliance not in ('XR','') and pndException='None' then isnull(pCC.[Description],pCompliance) + '\t\n' 
						 when pAcctStat not in ('DA','DF','62','64','') and pInfoInd != '' then isnull(pII.[Description],'Info Indicator ' + pInfoInd) + '\t\n'
						 when cbrDoD=1 and pEcoa ='X' and pndException='None' then 'Delete\t\nDeceased\t\n'
						 when pAcctStat = 'DA' and pndException='None'  then 'Delete\t\n'
						 when pAcctStat = 'DF' and pndException='None'  then 'Delete Fraud\t\n'
						 when pCompliance = 'XR' and pndException='None'	then 'Remove Compliance Condition ' + rCompliance + '\t\n' 
						 when pndException in ('Acctx','Dbtrx') then 'Invalid Data' +
							case when cbrprevent=0 and cbrexclude=0 and cbrenabled=1 and statuscbrreport=1 and pndException = 'None' then '\t\nCHANGE PENDING' 
								 else '' 
							end
						 else ''
					end
				 else 'Not Likely\t\n'
			end	as Banner,
			
			Case when rAcctStat<>'' then -- the last reported date makes this a redundant value 'Reported\t\n' + so we don't prepend here.
					case when recoa='X' or rInfoInd!='' then
						case when rInfoInd!='' then isnull(rII.[Description],'Info Indicator ' + rInfoInd) + '\t\n' else '' end +
						case when recoa='X' then 'Deceased\t\n' else '' end
					else
						case when rAcctStat not in ('DA', 'DF', '62', '64') then 
							 	case when rCompliance = '' then 
										case when cbrParty='3rd' then 'Open Collection\t\n' else 'Charge-Off\t\n' end  
									 else isnull(rCC.[Description],'Compliance Condition ' + rCompliance) + '\t\n' 
								end
							 else ''
						end + 
						isnull(rAS.[Description],'Account Status ' + rAcctStat) + '\t\n'  +
						case when rSpcomment != '' then isnull(rSC.[Description],'Special Comment ' + rSpcomment) + '\t\n' else '' end 
					end
				 when rAcctStat='' then -- the last reported date should read 'Not Reported\t\n' + so we don't prepend here.
				 	case when cbrEnabled=0 then 'Client does not allow credit bureau reporting\t\n' 
				 		 when OutOfStatute=1 then 'Out of Statute\t\n'
				 		 when StatusCbrReport=0 then 'Status code configured to not report\t\n'
				 		 when MinBalException=1 then 'Minimum balance not met\t\n'
						 when StatusIsPif=1 and pAcctStat='' and cbrPrevent=0 and cbrExclude=0 and statuscbrreport=1 then 'PIF prior to first report\t\n'
						 when StatusIsSif=1 and pAcctStat='' and cbrPrevent=0 and cbrExclude=0 and statuscbrreport=1 then 'SIF prior to first report\t\n' 
						 when cbrprevent=1 then 'Account prevented from reporting\t\n'
						 when cbrexclude=1 and seq=0 then 'Primary excluded from reporting\t\n'
				 		 when pAcctStat='' and RptDtException=1 and statuscbrreport=1 then 'Will Evaluate on ' + convert(varchar(10),nextReporting,101) + '\t\n'
				 		 when pndException!='None' then 'Invalid Data\t\n'
				 		 else '' 
				 	end
			end as AccountReported,

			Case when pAcctStat<>'' then 'Will Report\t\n' +
					case when cbrDoD=1 or pInfoInd!='' then
						case when pInfoInd!='' then isnull(pII.[Description],'Info Indicator ' + pInfoInd) + '\t\n' else '' end +
						case when cbrDoD=1 then 'Deceased\t\n' else '' end
					else
				 		case when StatusCbrDelete=1 then 'Status code configured to delete\t\n'
							 when pAcctStat not in ('DA', 'DF', '62', '64') then
							 	case when pCompliance = '' then 
										case when cbrParty='3rd' then 'Open Collection\t\n' ELSE 'Charge-Off\t\n' end  
									 else isnull(pCC.[Description],'Compliance Condition ' + pCompliance) + '\t\n' 
								end
							 else ''
						end + 
						isnull(pAS.[Description],'Account Status ' + pAcctStat) + '\t\n'  +
						case when pSpcomment != '' then isnull(pSC.[Description],'Special Comment ' + pSpcomment) + '\t\n' else '' end 
					end
				 when pAcctStat='' then 'Will Not Report\t\n' +
				 	case when cbrEnabled=0 then 'Client does not allow credit bureau reporting\t\n' 
				 		 when OutOfStatute=1 then 'Out of Statute\t\n'
				 		 when StatusCbrReport=0 then 'Status code configured to not report\t\n'
				 		 when MinBalException=1 then 'Minimum balance not met\t\n'
						 when StatusIsPif=1 and rAcctStat='' and cbrPrevent=0 and cbrExclude=0 and statuscbrreport=1 then 'PIF prior to first report\t\n'
						 when StatusIsSif=1 and rAcctStat='' and cbrPrevent=0 and cbrExclude=0 and statuscbrreport=1 then 'SIF prior to first report\t\n' 
						 when cbrprevent=1 then 'Account prevented from reporting\t\n'
						 when cbrexclude=1 and seq=0 then 'Primary excluded from reporting\t\n'
				 		 when rAcctStat='' and RptDtException=1 and statuscbrreport=1 then 'Will Evaluate on ' + convert(varchar(10),nextReporting,101) + '\t\n'
				 		 when pndException!='None' then 'Exceptions Present\t\n'
				 		 else 'Not Scheduled\t\n' 
				 	end
			end as AccountPending,
			
			case when recoa<>'' then 'Reported\t\n' +
					case when rAcctStat in ('DA','DF') then 'Delete Account\t\n' 
						 when recoa = 'X' then 'Deceased\t\n'
						 when recoa = 'Z' then 'Delete\t\n'
						 when recoa = 'T' then 'Terminate\t\n'
						 when rInfoInd != '' and cbrenabled=1 and cbrprevent=0 and cbrexclude=0 then isnull(rII.[Description],'Info Indicator ' + rInfoInd) + '\t\n'
						 else isnull(rECOADesc.[Description],recoa) + '\t\n'
					end
				 else 'Not Reported\t\n' + 
				 	case when pndException ='Acctx' then 'Account Exception Present\t\n'
				 		 when pndException ='Dbtrx' then   'Debtor Exception present\t\n'
				 		 else ''
				 	end
			end as DebtorReported,
	 
			case when pecoa<>'' then 'Will Report\t\n' +
					case when pAcctStat in ('DA','DF') then 'Delete Account\t\n' 
						 when pecoa = 'X' then 'Deceased\t\n'
						 when pecoa = 'Z' then 'Delete\t\n'
						 when pecoa = 'T' then 'Terminate\t\n'
						 when pInfoInd != '' and cbrenabled=1 and cbrprevent=0 and cbrexclude=0 then isnull(pII.[Description],'Info Indicator ' + pInfoInd) + '\t\n'
						 else isnull(pECOADesc.[Description],pecoa) + '\t\n'
					end
				 else 'Will Not Report\t\n' + 
					case when cbrexclude=1 then 'Debtor Excluded\t\n'
				 		 when pndException ='Acctx' then 'Account Exception Present\t\n'
				 		 when pndException ='Dbtrx' then   'Debtor Exception present\t\n'
				 		 else ''
				 	end
			end as DebtorPending,		
	   
		   CbrPrevent,
		   SpecialNote,
		   CbrExclude,
		   case when recoa!='' then 1 else 0 end as ConsumerHasReported 

	from cbrDataPendingDtlex2_Acct(@Accountid) 
		outer apply  ( select [Description] from custom_listdata rAS where ListCode = 'cbractstat' and Code = rAcctstat) rAS
		outer apply  ( select [Description] from custom_listdata pAS where ListCode = 'cbractstat' and Code = pAcctstat) pAS
		outer apply  ( select [Description] from custom_listdata rCC where ListCode = 'CBRCMPLCND' and Code = rCompliance) rCC
		outer apply  ( select [Description] from custom_listdata pCC where ListCode = 'CBRCMPLCND' and Code = pCompliance) pCC
		outer apply  ( select [Description] from custom_listdata rSC where ListCode = 'CBRSPECCMT' and Code = rSpcomment) rSC
		outer apply  ( select [Description] from custom_listdata pSC where ListCode = 'CBRSPECCMT' and Code = pSpcomment) pSC
		outer apply  ( select [Description] from custom_listdata rECOADesc where ListCode = 'CBRECOACD' and Code = recoa) rECOADesc
		outer apply  ( select [Description] from custom_listdata pECOADesc where ListCode = 'CBRECOACD' and Code = pecoa) pECOADesc
		outer apply  ( select [Description] from custom_listdata rII where ListCode = 'CBRINFOIND' and Code = rInfoInd) rII
		outer apply  ( select [Description] from custom_listdata pII where ListCode = 'CBRINFOIND' and Code = pInfoInd) pII
	) 
	
	select c1.AccountID, 
			c1.DebtorID, 
			c1.DebtorSeq,
			c1.Banner + '; ' + case when c1.ConsumerHasReported = 1 then c1.DebtorReported else c1.DebtorPending end as Banner,
			c1.AccountReported,
			c1.AccountPending,
			c1.DebtorReported,
			c1.DebtorPending,
			c1.CbrPrevent,
		    c1.SpecialNote,
		    c1.CbrExclude 
	from cbrsummary c1;

GO
