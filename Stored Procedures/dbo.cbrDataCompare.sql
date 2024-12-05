SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[cbrDataCompare]
AS 
 
	TRUNCATE TABLE [dbo].[CbrDataCycleUpdates];
	
	if not OBJECT_ID('tempdb..#cbrcompare') is null  drop table #cbrcompare;   
	--aggregate measures over dimensions for data that has changed
	
	with --prvcycle as ( select top (1) FileId from CbrDataCycleEnd order by FileId desc),
	currentcycle as (select 
	      cast(f.[number] as varchar(15))  as [number]  --dim attribute
	----configuration changes 
	  --Count(*) AS Dbtrs
	  --,Case when f.fileid <> d.[FileId],'0') then 1 else 0 end as [FileId]		
	  --configuration -- change dates explicitly to varchar
	  ,Case when isnull(f.[CbrEnabled] ,'')<> isnull(d.[CbrEnabled],'') then cast(f.[CbrEnabled] AS varchar(155)) else null end as [CbrEnabled]
      ,Case when isnull(f.[cbrPrevent] ,'')<> isnull(d.[cbrPrevent],'') then cast(f.[cbrPrevent] AS varchar(155)) else null end as [cbrPrevent]
      ,Case when isnull(f.[CbrOverride] ,'')<> isnull(d.[CbrOverride],'') then cast(f.[CbrOverride] AS varchar(155)) else null end as [CbrOverride]
      ,Case when isnull(f.[extenddays] ,'')<> isnull(d.[cbrextenddays],'') then cast(f.[extenddays] AS varchar(155)) else null end as [cbrextenddays]
      ,Case when isnull(f.[WaitDays] ,'')<> isnull(d.[CbrWaitDays],'') then cast(f.[WaitDays] AS varchar(155)) else null end as [CbrWaitDays]
      ,Case when isnull(f.[CreditorClass] ,'')<> isnull(d.[CbrCreditorClass],'') then cast(f.[CreditorClass] AS varchar(155)) else null end as [CbrCreditorClass]
      ,Case when isnull(f.[DefaultOriginalCreditor] ,'')<> isnull(d.[CbrDefaultOriginalCreditor],'') then cast(f.[DefaultOriginalCreditor] AS varchar(155)) else null end as [CbrDefaultOriginalCreditor]
      ,Case when isnull(f.[UseAccountOriginalCreditor] ,'')<> isnull(d.[CbrUseAccountOriginalCreditor],'') then cast(f.[UseAccountOriginalCreditor] AS varchar(155)) else null end as [CbrUseAccountOriginalCreditor]
      ,Case when isnull(f.[UseCustomerOriginalCreditor] ,'')<> isnull(d.[CbrUseCustomerOriginalCreditor],'') then cast(f.[UseCustomerOriginalCreditor] AS varchar(155)) else null end as [CbrUseCustomerOriginalCreditor]
      ,Case when isnull(f.[PrincipalOnly] ,'')<> isnull(d.[CbrPrincipalOnly],'') then cast(f.[PrincipalOnly] AS varchar(155)) else null end as [CbrPrincipalOnly]
      ,Case when isnull(f.[IncludeCodebtors] ,'')<> isnull(d.[CbrIncludeCodebtors],'') then cast(f.[IncludeCodebtors] AS varchar(155)) else null end as [CbrIncludeCodebtors]
      ,Case when isnull(f.[DeleteReturns] ,'')<> isnull(d.[CbrDeleteReturns],'') then cast(f.[DeleteReturns] AS varchar(155)) else null end as [CbrDeleteReturns]
 
      ,Case when isnull(f.[Customer] ,'')<> isnull(d.[Customer],'') then cast(f.[Customer] AS varchar(155)) else null end as [Customer]
      ,Case when isnull(f.[Customercode] ,'')<> isnull(d.[CbrCustomercode],'') then cast(f.[Customercode] AS varchar(155)) else null end as [CbrCustomercode]
      ,Case when isnull(f.[Customerid] ,'')<> isnull(d.[CbrCustomerid],'') then cast(f.[Customerid] AS varchar(155)) else null end as [CbrCustomerid]
      ,Case when isnull(f.[CustomerName] ,'')<> isnull(d.[CbrCustomerName],'') then cast(f.[CustomerName] AS varchar(155)) else null end as [CbrCustomerName]
      ,Case when isnull(f.[CustomerCreditorClass] ,'')<> isnull(d.[CbrCustomerCreditorClass],'') then cast(f.[CustomerCreditorClass] AS varchar(155)) else null end as [CbrCustomerCreditorClass]
      ,Case when isnull(f.[CustomerOriginalCreditor] ,'')<> isnull(d.[CbrCustomerOriginalCreditor],'') then cast(f.[CustomerOriginalCreditor] AS varchar(155)) else null end as [CbrCustomerOriginalCreditor]
      ,Case when isnull(f.[MinBalance] ,'')<> isnull(d.[CbrMinBalance],'') then cast(f.[MinBalance] AS varchar(155)) else null end as [CbrMinBalance]
      ,Case when isnull(f.[OriginalCreditor] ,'')<> isnull(d.[OriginalCreditor],'') then cast(f.[OriginalCreditor] AS varchar(155)) else null end as [OriginalCreditor]
      ,Case when isnull(f.[ContractDate] ,'')<> isnull(d.[ContractDate],'') then convert(varchar(8),f.[ContractDate],112) else null end as [ContractDate]
      ,Case when isnull(f.[ConsumerAccountNumber] ,'')<> isnull(d.[ConsumerAccountNumber],'') then cast(f.[ConsumerAccountNumber] AS varchar(155)) else null end as [ConsumerAccountNumber]
 
      ,Case when isnull(f.[IndustryCode] ,'')<> isnull(d.[CbrIndustryCode],'') then cast(f.[IndustryCode] AS varchar(155)) else null end as [CbrIndustryCode]
      ,Case when isnull(f.[PortfolioType] ,'')<> isnull(d.[CbrPortfolioType],'') then cast(f.[PortfolioType] AS varchar(155)) else null end as [CbrPortfolioType]
      ,Case when isnull(f.[AccountType] ,'')<> isnull(d.[CbrAccountType],'') then cast(f.[AccountType] AS varchar(155)) else null end as [CbrAccountType]
 
      --,Case when isnull(f.[Abbrev] ,'0')<> isnull(d.[CbrParmAbbrev],'0') then 1 else 0 end as [CbrParmAbbrev]
      --,Case when isnull(f.[Lookup] ,'0')<> isnull(d.[CbrValueLookup],'0') then 1 else 0 end as [CbrValueLookup]
      
      --account changes
      --,Case when isnull(f.[Status] ,'0')<> isnull(d.[Status],'0') then f.[Status] else null end as [Status]
      --,Case when isnull(f.[qlevel] ,'0')<> isnull(d.[qlevel],'0') then f.[qlevel] else null end as [qlevel]
      ,Case when isnull(f.[receiveddate] ,'')<> isnull(d.[receiveddate],'') then convert(varchar(8),f.[receiveddate],112) else null end as [receiveddate]
      ,Case when isnull(f.[DelinquencyDate] ,'')<> isnull(d.[DelinquencyDate],'') then convert(varchar(8),f.[DelinquencyDate],112) else null end as [DelinquencyDate]
      --,Case when isnull(f.[OriginalPrincipal] ,'0')<> isnull(d.[OriginalPrincipal],'0') then 1 else 0 end as [OriginalPrincipal]
      --,Case when isnull(f.[original] ,'0')<> isnull(d.[original],'0') then 1 else 0 end as [original]
 
 --portfolio indicator
      ,Case when isnull(f.[soldportfolio] ,'')<> isnull(d.[soldportfolio],'') then cast(f.[soldportfolio] AS varchar(155)) else null end as [soldportfolio]
      ,Case when isnull(f.[purchasedportfolio] ,'')<> isnull(d.[purchasedportfolio],'') then cast(f.[purchasedportfolio] AS varchar(155)) else null end as [purchasedportfolio]

--      ,Case when isnull(f.[PrvCbrException] ,'0')<> isnull(d.[PrvCbrException],'0') then 1 else 0 end as [PrvCbrException]
 
 --accountstatus - special comment
      ,Case when isnull(f.[specialnote] ,'')<> isnull(d.[specialnote],'') then cast(f.[specialnote] AS varchar(155)) else null end as [specialnote]
      ,Case when isnull(f.[StatusCbrReport] ,'')<> isnull(d.[StatusCbrReport],'') then cast(f.[StatusCbrReport] AS varchar(155)) else null end as [StatusCbrReport]
      ,Case when isnull(f.[StatusCbrDelete] ,'')<> isnull(d.[StatusCbrDelete],'') then cast(f.[StatusCbrDelete] AS varchar(155)) else null end as [StatusCbrDelete]
      ,Case when isnull(f.[StatusIsPIF] ,'')<> isnull(d.[StatusIsPIF],'') then cast(f.[StatusIsPIF] AS varchar(155)) else null end as [StatusIsPIF]
      ,Case when isnull(f.[StatusIsSIF] ,'')<> isnull(d.[StatusIsSIF],'') then cast(f.[StatusIsSIF] AS varchar(155)) else null end as [StatusIsSIF]
      ,Case when isnull(f.[StatusIsFraud] ,'')<> isnull(d.[StatusIsFraud],'') then cast(f.[StatusIsFraud] AS varchar(155)) else null end as [StatusIsFraud]
--accountstatus and payment made in cycle - special comment
      ,Case when isnull(f.[CurrentPrincipal] ,'')<> isnull(d.[CurrentPrincipal],'') then cast(f.[CurrentPrincipal] AS varchar(155)) else null end as [CurrentPrincipal]
      ,Case when isnull(f.[CurrentBalance] ,'')<> isnull(d.[CurrentBalance],'') then cast(f.[CurrentBalance] AS varchar(155)) else null end as [CurrentBalance]
      ,Case when isnull(f.[lastpaid] ,'')<> isnull(d.[lastpaid],'') then convert(varchar(8),f.[lastpaid],112) else null end as [lastpaid]
      ,Case when isnull(f.[SettlementID] ,'')<> isnull(d.[SettlementID],'') then cast(f.[SettlementID] AS varchar(155)) else null end as [SettlementID]
      ,Case when isnull(f.[lastpaidamt] ,'')<> isnull(d.[lastpaidamt],'') then cast(f.[lastpaidamt] AS varchar(155)) else null end as [lastpaidamt]
      ,Case when isnull(f.[CLIDLP] ,'')<> isnull(d.[CLIDLP],'') then convert(varchar(8),f.[CLIDLP],112) else null end as [CLIDLP]
      ,Case when isnull(f.[LastPaymentDate] ,'')<> isnull(d.[LastPaymentDate],'') then convert(varchar(8),f.[LastPaymentDate],112) else null end as [LastPaymentDate]
      ,Case when isnull(f.[lastPaymentAmount] ,'')<> isnull(d.[lastPaymentAmount],'') then cast(f.[lastPaymentAmount] AS varchar(155)) else null end as [lastPaymentAmount]
      ,Case when isnull(f.[payhistorydatepaid] ,'')<> isnull(d.[payhistorydatepaid],'') then convert(varchar(8),f.[payhistorydatepaid],112) else null end as [payhistorydatepaid]
 
      --,Case when isnull(f.[IsBankruptcy] ,'0')<> isnull(d.[IsBankruptcy],'0') then 1 else 0 end as [IsBankruptcy]
      --,Case when isnull(f.[IsDeceased] ,'0')<> isnull(d.[IsDeceased],'0') then 1 else 0 end as [IsDeceased]
 --compliance condition code 
      ,Case when isnull(f.[IsDisputed] ,'')<> isnull(d.[IsDisputed],'') then cast(f.[IsDisputed] AS varchar(155)) else null end as [IsDisputed]
      
      --mco
      --,Case when isnull(f.[Chargeoffnumber] ,'0')<> isnull(d.[McoChargeoffnumber],'0') then 1 else 0 end as [McoChargeoffnumber]
      ,Case when isnull(f.[SecondaryAgencyIdenitifier] ,'')<> isnull(d.[McoSecondaryAgencyIdenitifier],'') then cast(f.[SecondaryAgencyIdenitifier] AS varchar(155)) else null end as [McoSecondaryAgencyIdenitifier]
      ,Case when isnull(f.[SecondaryAccountNumber] ,'')<> isnull(d.[McoSecondaryAccountNumber],'') then cast(f.[SecondaryAccountNumber] AS varchar(155)) else null end as [McoSecondaryAccountNumber]
      ,Case when isnull(f.[MortgageIdentificationNumber] ,'')<> isnull(d.[McoMortgageIdentificationNumber],'') then cast(f.[MortgageIdentificationNumber] AS varchar(155)) else null end as [McoMortgageIdentificationNumber]
      ,Case when isnull(f.[TermsDuration] ,'')<> isnull(d.[McoTermsDuration],'') then cast(f.[TermsDuration] AS varchar(155)) else null end as [McoTermsDuration]
      ,Case when isnull(f.[ClosedDate] ,'')<> isnull(d.[McoClosedDate],'') then convert(varchar(8),f.[ClosedDate],112) else null end as [McoClosedDate]
      ,Case when isnull(f.[ChargeOffStatus] ,'')<> isnull(d.[McoChargeOffStatus],'') then cast(f.[ChargeOffStatus] AS varchar(155)) else null end as [McoChargeOffStatus]
      ,Case when isnull(f.[ChargeOffAmount] ,'')<> isnull(d.[McoChargeOffAmount],'') then cast(f.[ChargeOffAmount] AS varchar(155)) else null end as [McoChargeOffAmount]
      ,Case when isnull(f.[PaymentHistoryProfile] ,'')<> isnull(d.[McoPaymentHistoryProfile],'') then cast(f.[PaymentHistoryProfile] AS varchar(155)) else null end as [McoPaymentHistoryProfile]
      ,Case when isnull(f.[PaymentHistoryDate] ,'')<> isnull(d.[McoPaymentHistoryDate],'') then convert(varchar(8),f.[PaymentHistoryDate],112) else null end as [McoPaymentHistoryDate]
      ,Case when isnull(f.[HighestCredit] ,'')<> isnull(d.[McoHighestCredit],'') then cast(f.[HighestCredit] AS varchar(155)) else null end as [McoHighestCredit]
      ,Case when isnull(f.[CreditLimit] ,'')<> isnull(d.[McoCreditLimit],'') then cast(f.[CreditLimit] AS varchar(155)) else null end as [McoCreditLimit]
      ,Case when isnull(f.[McoSpecialComment] ,'')<> isnull(d.[McoSpecialComment],'') then cast(f.[McoSpecialComment] AS varchar(155)) else null end as [McoSpecialComment]
      ,Case when isnull(f.[McoComplianceCondition] ,'')<> isnull(d.[McoComplianceCondition],'') then cast(f.[McoComplianceCondition] AS varchar(155)) else null end as [McoComplianceCondition]
      
 --portfolio indicator
      --aim
      ,Case when isnull(f.[portfolioid] ,'')<> isnull(d.[portfolioid],'') then cast(f.[portfolioid] AS varchar(155)) else null end as [portfolioid]
      ,Case when isnull(f.[AimGroupSeller] ,'')<> isnull(d.[AimGroupSeller],'') then cast(f.[AimGroupSeller] AS varchar(155)) else null end as [AimGroupSeller]
      ,Case when isnull(f.[AimGroupBuyer] ,'')<> isnull(d.[AimGroupBuyer],'') then cast(f.[AimGroupBuyer] AS varchar(155)) else null end as [AimGroupBuyer]
      ,Case when isnull(f.[PortfolioSoldDate] ,'')<> isnull(d.[PortfolioSoldDate],'') then convert(varchar(8),f.[PortfolioSoldDate],112) else null end as [PortfolioSoldDate]
      
      --debtors
      --,Case when isnull(f.[debtornumber] ,'0')<> isnull(d.[debtornumber],'0') then 1 else 0 end as [debtornumber]
      --,Case when isnull(f.[PrimaryDebtorID] ,'')<> isnull(d.[PrimaryDebtorID],'') then f.[PrimaryDebtorID] else null end as [PrimaryDebtorID]
      ,f.[DebtorID] as [DebtorID] -- Dim DebtorId
 
      --,Case when isnull(f.[seq] ,'0')<> isnull(d.[Debtorseq],'0') then 1 else 0 end as [Debtorseq]
      ,Case when isnull(f.[CbrExclude] ,'')<> isnull(d.[CbrExclude],'') then cast(f.[CbrExclude] AS varchar(155)) else null end as [CbrExclude]
      ,Case when isnull(f.[IsBusiness] ,'')<> isnull(d.[IsBusiness],'') then cast(f.[IsBusiness] AS varchar(155)) else null end as [IsBusiness]
      ,Case when isnull(f.[Responsible] ,'')<> isnull(d.[DebtorResponsible],'') then cast(f.[Responsible] AS varchar(155)) else null end as [DebtorResponsible]
      ,Case when isnull(f.[IsAuthorizedAccountUser] ,'')<> isnull(d.[IsAuthorizedAccountUser],'') then cast(f.[IsAuthorizedAccountUser] AS varchar(155)) else null end as [IsAuthorizedAccountUser]
 
--transaction code / demographic significant changes
      --,Case when isnull(f.[PrvDebtorExceptions] ,'0')<> isnull(d.[PrvDebtorExceptions],'0') then 1 else 0 end as [PrvDebtorExceptions]
      ,Case when isnull(f.[Debtorname] ,'')<> isnull(d.[Debtorname],'') then cast(f.[Debtorname] AS varchar(155)) else null end as [Debtorname]
      ,Case when isnull(f.[DebtorSSN] ,'')<> isnull(d.[DebtorSSN],'') then cast(f.[DebtorSSN] AS varchar(155)) else null end as [DebtorSSN]
      ,Case when isnull(rtrim(ltrim(f.[DebtorStreet1])) ,'')<> isnull(rtrim(ltrim(d.[DebtorStreet1])),'') then cast(f.[DebtorStreet1] AS varchar(155)) else null end as [DebtorStreet1]
      ,Case when isnull(f.[DebtorStreet2] ,'')<> isnull(d.[DebtorStreet2],'') then cast(f.[DebtorStreet2] AS varchar(155)) else null end as [DebtorStreet2]
      ,Case when isnull(f.[DebtorCity] ,'')<> isnull(d.[DebtorCity],'') then cast(f.[DebtorCity] AS varchar(155)) else null end as [DebtorCity]
      ,Case when isnull(f.[DebtorState] ,'')<> isnull(d.[DebtorState],'') then cast(f.[DebtorState] AS varchar(155)) else null end as [DebtorState]
      ,Case when isnull(f.[DebtorZipCode] ,'')<> isnull(d.[DebtorZipCode],'') then cast(f.[DebtorZipCode] AS varchar(155)) else null end as [DebtorZipCode]
--specialcomment      
      ,Case when isnull(f.[CCCS] ,'')<> isnull(d.[CCCS],'') then cast(f.[CCCS] AS varchar(155)) else null end as [CCCS]
--compliance condition
      ,Case when isnull(f.[PrimaryDebtorDispute] ,'')<> isnull(d.[PrimaryDebtorDispute],'') then cast(f.[PrimaryDebtorDispute] AS varchar(155)) else null end as [PrimaryDebtorDispute]
--ecoacode      
      ,Case when isnull(f.[datedeceased] ,'')<> isnull(d.[datedeceased],'') then convert(varchar(8),f.[datedeceased],112) else null end as [datedeceased]
      
--consumerinformationindicator  and paymenthistoryprofile
      --bankruptcy
      --,Case when isnull(f.[bankruptdebtorid] ,'0')<> isnull(d.[bankruptdebtorid],'0') then 1 else 0 end as [bankruptdebtorid]
      
      --should greater than be added to provide for the most significant date or change
      
      ,Case when isnull(f.[chapter] ,'')<> isnull(d.[bankruptchapter],'') then cast(f.[chapter] AS varchar(155)) else null end as [bankruptchapter]

      ,Case when isnull(f.[dateFiled] ,'')<> isnull(d.[bankruptdateFiled],'') then convert(varchar(8),f.[dateFiled],112) else null end as [bankruptdateFiled]
      ,Case when isnull(f.[dateNotice] ,'')<> isnull(d.[bankruptdateNotice],'') then convert(varchar(8),f.[dateNotice],112) else null end as [bankruptdateNotice]
      ,Case when isnull(f.[proofFiled] ,'')<> isnull(d.[bankruptproofFiled],'') then convert(varchar(8),f.[proofFiled],112) else null end as [bankruptproofFiled]
      ,Case when isnull(f.[dateTime341] ,'')<> isnull(d.[bankruptdateTime341],'') then convert(varchar(8),f.[dateTime341],112) else null end as [bankruptdateTime341]
      ,Case when isnull(f.[WithdrawnDate] ,'')<> isnull(d.[bankruptWithdrawnDate],'') then convert(varchar(8),f.[WithdrawnDate],112) else null end as [bankruptWithdrawnDate]
      ,Case when isnull(f.[dischargeDate] ,'')<> isnull(d.[bankruptdischargeDate],'') then convert(varchar(8),f.[dischargeDate],112) else null end as [bankruptdischargeDate]
      ,Case when isnull(f.[dismissalDate] ,'')<> isnull(d.[bankruptdismissalDate],'') then convert(varchar(8),f.[dismissalDate],112) else null end as [bankruptdismissalDate]
      ,Case when isnull(f.[reaffirmDateFiled] ,'')<> isnull(d.[bankruptreaffirmDateFiled],'') then convert(varchar(8),f.[reaffirmDateFiled],112) else null end as [bankruptreaffirmDateFiled]
      ,Case when isnull(f.[PersonalReceivership_Amortization] ,'')<> isnull(d.[PersonalReceivership_Amortization],'') then cast(f.[PersonalReceivership_Amortization] AS varchar(155)) else null end as [PersonalReceivership_Amortization]
      
      --,Case when isnull(f.[cccdebtorid] ,'0')<> isnull(d.[cccdebtorid],'0') then 1 else 0 end as [cccdebtorid]
      --,Case when isnull(f.[lastpaidnumber] ,'0')<> isnull(d.[lastpaidnumber],'0') then 1 else 0 end as [lastpaidnumber]
      --,Case when isnull(f.[DateCreated] <> d.
 
		,coalesce(f.prvcbrexception, f.prvdebtorexceptions) as exception
 from  dbo.cbrdatafx(null) f
	left outer join CbrDataCycleEnd d on f.number = d.number and f.DebtorID = d.DebtorID 

)

      select * into #cbrcompare from currentcycle  ;
		--create nonclustered index cbrcomp on #cbrcompare (Configurationid) ;
--select * from #cbrcompare where number=1648185903
--return

  insert into [CbrDataCycleUpdates]( CbrChangeType , number , debtorid, datapoint, item , exception)
	select
	--configuration changes 
	  --,Case when f.fileid <> d.[FileId],'0') then 1 else 0 end as [FileId]
	--configuration
				   'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrEnabled' as datapoint,[CbrEnabled] as cbrenabled,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrEnabled] IS not null
      union select 'Exclusion' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrprevent' as datapoint,[cbrPrevent] as cbrprevent ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrPrevent] is not null
	  union select 'Exclusion' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrOverride' as datapoint,[CbrOverride] as [CbrOverride] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrOverride] is not null

      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrextenddays' as datapoint,[cbrextenddays]  as [cbrextenddays] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrextenddays] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrWaitDays' as datapoint,[cbrWaitDays] as [CbrWaitDays] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrWaitDays] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrCreditorClass' as datapoint,[cbrCreditorClass] as [CbrCreditorClass] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrCreditorClass] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrDefaultOriginalCreditor' as datapoint,[cbrDefaultOriginalCreditor] as [CbrDefaultOriginalCreditor] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrDefaultOriginalCreditor] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrUseAccountOriginalCreditor' as datapoint,[cbrUseAccountOriginalCreditor] as [CbrUseAccountOriginalCreditor] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrUseAccountOriginalCreditor] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrUseCustomerOriginalCreditor' as datapoint,[cbrUseCustomerOriginalCreditor] as [CbrUseCustomerOriginalCreditor] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrUseCustomerOriginalCreditor] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrPrincipalOnly' as datapoint,[cbrPrincipalOnly] as [CbrPrincipalOnly] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrPrincipalOnly] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrIncludeCodebtors' as datapoint,[cbrIncludeCodebtors] as [CbrIncludeCodebtors] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrIncludeCodebtors] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'cbrDeleteReturns' as datapoint,[cbrDeleteReturns] as [CbrDeleteReturns] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [cbrDeleteReturns] is not null
 
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'Customer' as datapoint,[Customer] as [Customer] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [Customer] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrCustomercode' as datapoint,[CbrCustomercode] as [CbrCustomercode] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrCustomercode] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrCustomerid' as datapoint,[CbrCustomerid] as [CbrCustomerid] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrCustomerid] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrCustomerName' as datapoint,[CbrCustomerName] as [CbrCustomerName] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrCustomerName] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrCustomerCreditorClass' as datapoint,[CbrCustomerCreditorClass] as [CbrCustomerCreditorClass] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrCustomerCreditorClass] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrCustomerOriginalCreditor' as datapoint,[CbrCustomerOriginalCreditor] as [CbrCustomerOriginalCreditor] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrCustomerOriginalCreditor] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrMinBalance' as datapoint,[CbrMinBalance] as [CbrMinBalance] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrMinBalance] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'OriginalCreditor' as datapoint,[OriginalCreditor] as [OriginalCreditor] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [OriginalCreditor] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'ContractDate' as datapoint,[ContractDate]  as [ContractDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [ContractDate] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'ConsumerAccountNumber' as datapoint,[ConsumerAccountNumber] as [ConsumerAccountNumber] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [ConsumerAccountNumber] is not null
 
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrIndustryCode' as datapoint,[CbrIndustryCode] as [CbrIndustryCode] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrIndustryCode] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrPortfolioType' as datapoint,[CbrPortfolioType] as [CbrPortfolioType] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrPortfolioType] is not null
      union select 'Configuration' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrAccountType' as datapoint,[CbrAccountType] as [CbrAccountType] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrAccountType] is not null
 
--      --,Case when isnull(f.[Abbrev] ,'0')<> isnull(d.[CbrParmAbbrev],'0') then 1 else 0 end as [CbrParmAbbrev]
--      --,Case when isnull(f.[Lookup] ,'0')<> isnull(d.[CbrValueLookup],'0') then 1 else 0 end as [CbrValueLookup]
      
--      --account changes
--      --,Case when isnull(f.[Status] ,'0')<> isnull(d.[Status],'0') then f.[Status] else null end as [Status]
--      --,Case when isnull(f.[qlevel] ,'0')<> isnull(d.[qlevel],'0') then f.[qlevel] else null end as [qlevel]
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'receiveddate' as datapoint,[receiveddate] as [receiveddate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [receiveddate] is not null
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DelinquencyDate' as datapoint,[DelinquencyDate] as [DelinquencyDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DelinquencyDate] is not null
      --,Case when isnull(f.[OriginalPrincipal] ,'0')<> isnull(d.[OriginalPrincipal],'0') then 1 else 0 end as [OriginalPrincipal]
--      --,Case when isnull(f.[original] ,'0')<> isnull(d.[original],'0') then 1 else 0 end as [original]
 
-- --portfolio indicator
      union select 'PortfolioTransInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'soldportfolio' as datapoint,[soldportfolio] as [soldportfolio] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [soldportfolio] is not null
      union select 'PortfolioTransInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'purchasedportfolio' as datapoint,[purchasedportfolio] as [purchasedportfolio] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [purchasedportfolio] is not null

----      ,Case when isnull(f.[PrvCbrException] ,'0')<> isnull(d.[PrvCbrException],'0') then 1 else 0 end as [PrvCbrException]
 
-- --accountstatus - special comment
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'specialnote' as datapoint,[specialnote] as [specialnote] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [specialnote] is not null
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'StatusCbrReport' as datapoint,[StatusCbrReport] as [StatusCbrReport] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [StatusCbrReport] is not null
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'StatusCbrDelete' as datapoint,[StatusCbrDelete] as [StatusCbrDelete] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [StatusCbrDelete] is not null
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'StatusIsPIF' as datapoint,[StatusIsPIF] as [StatusIsPIF] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [StatusIsPIF] is not null
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'StatusIsSIF' as datapoint,[StatusIsSIF] as [StatusIsSIF] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [StatusIsSIF] is not null
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'StatusIsFraud' as datapoint,[StatusIsFraud] as [StatusIsFraud] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [StatusIsFraud] is not null
----accountstatus and payment made in cycle - special comment
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CurrentPrincipal' as datapoint,[CurrentPrincipal] as [CurrentPrincipal] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CurrentPrincipal] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CurrentBalance' as datapoint,[CurrentBalance] as [CurrentBalance] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CurrentBalance] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'lastpaid' as datapoint,[lastpaid] as [lastpaid] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [lastpaid] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'SettlementID' as datapoint,[SettlementID] as [SettlementID] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [SettlementID] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'lastpaidamt' as datapoint,[lastpaidamt] as [lastpaidamt] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [lastpaidamt] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CLIDLP' as datapoint,[CLIDLP] as [CLIDLP] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CLIDLP] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'LastPaymentDate' as datapoint,[LastPaymentDate] as [LastPaymentDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [LastPaymentDate] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'lastPaymentAmount' as datapoint,[lastPaymentAmount] as [lastPaymentAmount] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [lastPaymentAmount] is not null
      union select 'AccountBalanceInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'payhistorydatepaid' as datapoint,[payhistorydatepaid] as [payhistorydatepaid] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [payhistorydatepaid] is not null
 
      --union select Case when isnull(f.[IsBankruptcy] ,'0')<> isnull(d.[IsBankruptcy],'0') then 1 else 0 end as [IsBankruptcy]
      --union select Case when isnull(f.[IsDeceased] ,'0')<> isnull(d.[IsDeceased],'0') then 1 else 0 end as [IsDeceased]
-- --compliance condition code 
      union select 'AccountStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'IsDisputed' as datapoint,[IsDisputed] as [IsDisputed] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [IsDisputed] is not null
      
--      --mco
--      --,Case when isnull(f.[Chargeoffnumber] ,'0')<> isnull(d.[McoChargeoffnumber],'0') then 1 else 0 end as [McoChargeoffnumber]
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoSecondaryAgencyIdenitifier' as datapoint,[McoSecondaryAgencyIdenitifier] as [McoSecondaryAgencyIdenitifier] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoSecondaryAgencyIdenitifier] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoSecondaryAccountNumber' as datapoint,[McoSecondaryAccountNumber] as [McoSecondaryAccountNumber] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoSecondaryAccountNumber] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoMortgageIdentificationNumber' as datapoint,[McoMortgageIdentificationNumber] as [McoMortgageIdentificationNumber] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoMortgageIdentificationNumber] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoTermsDuration' as datapoint,[McoTermsDuration] as [McoTermsDuration] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoTermsDuration] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoClosedDate' as datapoint,[McoClosedDate] as [McoClosedDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoClosedDate] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoChargeOffStatus' as datapoint,[McoChargeOffStatus] as [McoChargeOffStatus] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoChargeOffStatus] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoChargeOffAmount' as datapoint,[McoChargeOffAmount] as [McoChargeOffAmount] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoChargeOffAmount] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoPaymentHistoryProfile' as datapoint,[McoPaymentHistoryProfile] as [McoPaymentHistoryProfile] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoPaymentHistoryProfile] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoPaymentHistoryDate' as datapoint,[McoPaymentHistoryDate] as [McoPaymentHistoryDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoPaymentHistoryDate] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoHighestCredit' as datapoint,[McoHighestCredit] as [McoHighestCredit] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoHighestCredit] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoCreditLimit' as datapoint,[McoCreditLimit] as [McoCreditLimit] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoCreditLimit] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoSpecialComment' as datapoint,[McoSpecialComment] as [McoSpecialComment] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoSpecialComment] is not null
      union select 'ChargeOffInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'McoComplianceCondition' as datapoint,[McoComplianceCondition] as [McoComplianceCondition] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [McoComplianceCondition] is not null
      
-- --portfolio indicator
      --aim
      union select 'PortfolioTransInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'portfolioid' as datapoint,[portfolioid] as [portfolioid] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [portfolioid] is not null
      union select 'PortfolioTransInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'AimGroupSeller' as datapoint,[AimGroupSeller] as [AimGroupSeller] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [AimGroupSeller] is not null
      union select 'PortfolioTransInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'AimGroupBuyer' as datapoint,[AimGroupBuyer] as [AimGroupBuyer] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [AimGroupBuyer] is not null
      union select 'PortfolioTransInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'PortfolioSoldDate' as datapoint,[PortfolioSoldDate] as [PortfolioSoldDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [PortfolioSoldDate] is not null
      
      --debtors
--    --,Case when isnull(f.[debtornumber] ,'0')<> isnull(d.[debtornumber],'0') then 1 else 0 end as [debtornumber]
      --union select 6 as DebtorStatusInfoID,[number]  as [number],[DebtorID]  as [DebtorID],[PrimaryDebtorID] as [PrimaryDebtorID] from #cbrcompare where [PrimaryDebtorID] is not null
      --union select '6' as DebtorStatusInfoID,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorID' as datapoint,null from #cbrcompare
 
--      --,Case when isnull(f.[seq] ,'0')<> isnull(d.[Debtorseq],'0') then 1 else 0 end as [Debtorseq]
      union select 'Exclusion' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CbrExclude' as datapoint,[CbrExclude] as [CbrExclude] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CbrExclude] is not null
      union select 'DebtorStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'IsBusiness' as datapoint,[IsBusiness] as [IsBusiness] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [IsBusiness] is not null
      union select 'DebtorStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorResponsible' as datapoint,[DebtorResponsible] as [DebtorResponsible] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DebtorResponsible] is not null
      union select 'DebtorStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'IsAuthorizedAccountUser' as datapoint,[IsAuthorizedAccountUser] as [IsAuthorizedAccountUser] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [IsAuthorizedAccountUser] is not null
 
----transaction code / demographic significant changes
--      --,Case when isnull(f.[PrvDebtorExceptions] ,'0')<> isnull(d.[PrvDebtorExceptions],'0') then 1 else 0 end as [PrvDebtorExceptions]
       
	  union select 'DebtorDemographicInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorName' as datapoint,[Debtorname] as [Debtorname] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [Debtorname] is not null
      union select 'DebtorDemographicInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorSSN' as datapoint,[DebtorSSN] as [DebtorSSN] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DebtorSSN] is not null
      union select 'DebtorDemographicInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorStreet1' as datapoint,[DebtorStreet1] as [DebtorStreet1] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DebtorStreet1] is not null
      union select 'DebtorDemographicInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorStreet2' as datapoint,[DebtorStreet2] as [DebtorStreet2] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DebtorStreet2] is not null
      union select 'DebtorDemographicInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorCity' as datapoint,[DebtorCity] as [DebtorCity] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DebtorCity] is not null
	  union select 'DebtorDemographicInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorState' as datapoint,[DebtorState] as [DebtorState] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DebtorState] is not null
      union select 'DebtorDemographicInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'DebtorZipCode' as datapoint,[DebtorZipCode] as [DebtorZipCode] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [DebtorZipCode] is not null
----specialcomment      
      union select 'DebtorStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'CCCS' as datapoint,[CCCS] as [CCCS] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [CCCS] is not null
----compliance condition
      union select 'DebtorStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'PrimaryDebtorDispute' as datapoint,[PrimaryDebtorDispute] as [PrimaryDebtorDispute] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [PrimaryDebtorDispute] is not null
----ecoacode      
      union select 'DebtorStatusInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'datedeceased' as datapoint,[datedeceased] as [datedeceased] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [datedeceased] is not null
      
--consumerinformationindicator  and paymenthistoryprofile
      --bankruptcy
      --,Case when isnull(f.[bankruptdebtorid] ,'0')<> isnull(d.[bankruptdebtorid],'0') then 1 else 0 end as [bankruptdebtorid]
      
      --should greater than be added to provide for the most significant date or change
      
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptchapter' as datapoint,[bankruptchapter] as [bankruptchapter] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptchapter] is not null

      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptdateFiled' as datapoint,[bankruptdateFiled] as [bankruptdateFiled] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptdateFiled] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptdateNotice' as datapoint,[bankruptdateNotice] as [bankruptdateNotice] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptdateNotice] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptproofFiled' as datapoint,[bankruptproofFiled] as [bankruptproofFiled] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptproofFiled] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptdateTime341' as datapoint,[bankruptdateTime341] as [bankruptdateTime341] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptdateTime341] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptWithdrawnDate' as datapoint,[bankruptWithdrawnDate] as [bankruptWithdrawnDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptWithdrawnDate] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptdischargeDate' as datapoint,[bankruptdischargeDate] as [bankruptdischargeDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptdischargeDate] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptdismissalDate' as datapoint,[bankruptdismissalDate] as [bankruptdismissalDate] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptdismissalDate] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'bankruptreaffirmDateFiled' as datapoint,[bankruptreaffirmDateFiled] as [bankruptreaffirmDateFiled] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception from #cbrcompare where [bankruptreaffirmDateFiled] is not null
      union select 'BankruptcyInfo' as CbrChangeType,[number]  as [number],[DebtorID]  as [DebtorID],'PersonalReceivership_Amortization' as datapoint,[PersonalReceivership_Amortization] as [PersonalReceivership_Amortization] ,case when isnull(exception,0)=0 then 0 else 1 end As Exception 
      from #cbrcompare where [PortfolioSoldDate] is not null
      
      --,Case when isnull(f.[cccdebtorid] ,'0')<> isnull(d.[cccdebtorid],'0') then 1 else 0 end as [cccdebtorid]
      --,Case when isnull(f.[lastpaidnumber] ,'0')<> isnull(d.[lastpaidnumber],'0') then 1 else 0 end as [lastpaidnumber]
      --,Case when isnull(f.[DateCreated] <> d.
      
;
GO
