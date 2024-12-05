SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[cbrPostHistoryDeferCleanup]
AS

	declare @fileId int;
	declare @dateReported datetime;
	
	select @fileId = IntValue1, @dateReported = DateValue1 from GlobalSettings
	where NameSpace = 'Credit Reporting' and SettingName = 'Defer CBR Export Post Processing'
	
	if @fileId is null
	begin
		RAISERROR ('Cannot run [cbrPostHistoryDeferCleanup] because a deferred export does not exist.', 16, 1) WITH LOG	
		GOTO ExitProcedure
	end
	
	--insert notes	
	insert into notes(number, ctl, created, user0, action, result, comment)
	select 	a.accountid, 'cru', @dateReported, 'SYSTEM', 'crupd', 
		case 
			when a.racctstat = 'DF' then 'delfrd' 
			when a.racctstat = 'DA' and a.specialnote = 'DI' then 'delins'
			when a.racctstat = 'DA' then 'delete' 
			when a.racctstat IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') and a.rcompliance like 'X%' then 'dspute' 
			when a.racctstat IN ('62', '64') and a.rspcomment = 'AU' then 'sif' 
			when a.racctstat IN ('62', '64') then 'pif' 
			when a.racctstat = '93' then 'open' 
			when a.racctstat IN ('11', '71', '78', '80', '82', '83', '84', '97') then 'chgoff'
			when a.racctstat IN ('11', '71', '78', '80', '82', '83', '84', '97') and a.portfolioindicator = 2 then 'Sold'
			else 'crupd'
		end result,
		case 
			when a.racctstat = 'DF' then 'Account fraud, deletion submitted in credit bureau report file.' 
			when a.racctstat = 'DA' and a.specialnote = 'DI' then 'Account deletion submitted due to payment by insurance in credit bureau report file'
			when a.racctstat = 'DA' then 'Account deletion submitted in credit bureau report file.' 
			when a.racctstat IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') and a.rcompliance like 'X%' then 'Account dispute ' + a.rcompliance + ' submitted in credit bureau report file.' 
			when a.racctstat IN ('62', '64') and a.rspcomment = 'AU' then 'Account SIF submitted in credit bureau report file.' 
			when a.racctstat IN ('62', '64') then 'Account PIF submitted in credit bureau report file.' 
			when a.racctstat = '93' then 'Open collection account submitted in credit bureau report file.' 
			when a.racctstat IN ('11', '71', '78', '80', '82', '83', '84', '97') then 'Charge-off account submitted in credit bureau report file.'
			when a.racctstat IN ('11', '71', '78', '80', '82', '83', '84', '97') and a.portfolioindicator = 2 then 'Charge-off Account Sold'
			else 'Unknown account status'
			
		end as comment
	from cbrDataPendingDtlex2(NULL) a 
	inner join cbr_metro2_files f  on f.fileID = a.fileID
	where f.fileID = @fileID and a.fileID = @fileID and a.seq = 0
	
	union all
	
	select 	x.number, 'cru', @dateReported, 'SYSTEM', 'crupd', 'CBRx', 
			case when StatusCbrReport = 0 then 'NotConfigured'  else '' end + ' | ' +
			Case when cbrenabled = 1 then 'cbrenabled' else '' end + ' | ' +
			Case when cbroverride = 1 then 'cbrOverride' else '' end + ' | ' +
			case when cbrexclude = 1 then 'DebtorExcluded' else '' end + ' | ' +
            case when responsible = 0 then 'DebtorNotResponsible' else '' end + ' | ' +
            case when abs(cbrexception) & 1 = 1 then 'NullDelinquencyDt' else '' end + ' | ' +
            case when abs(cbrexception) & 2 = 2 then 'DelinquencyDt>Received' else '' end + ' | ' +
			case when abs(cbrexception) & 4 = 4 then 'DelinquencyDtWithin30daysOfReceived' else '' end + ' | ' +
			case when abs(cbrexception) & 8 = 8 then 'InvalidAcctType' else '' end + ' | ' +
			case when abs(cbrexception) & 16 = 16 then 'InvalidContractDate' else '' end + ' | ' +
			case when abs(cbrexception) & 32 = 32 then 'InvalidConsumerAccountNumber' else '' end + ' | ' +
			case when abs(cbrexception) & 64 = 64 then 'MissingChargeOffRecord' else '' end + ' | ' +
			case when abs(cbrexception) & 128 = 128 then 'MissingChargeOffAmount' else '' end + ' | ' +
			case when abs(cbrexception) & 256 = 256 then 'MissingSecondaryAgencyIdenitifier' else '' end + ' | ' +
			case when abs(cbrexception) & 512 = 512 then 'MissingSecondaryAccountNumber' else '' end + ' | ' +
			case when abs(cbrexception) & 1024 = 1024 then 'OpenChargeOffNotInBankruptcy' else '' end + ' | ' +
			case when abs(cbrexception) & 2048 = 2048 then 'MissingAcctOriginalCreditor' else '' end + ' | ' +
			case when abs(cbrexception) & 4096 = 4096 then 'MissingDefaultOriginalCreditor' else '' end + ' | ' +
			case when abs(cbrexception) & 8192 = 8192 then 'MissingCreditorClass' else '' end + ' | ' +
			case when abs(cbrexception) & 16384 = 16384 then 'MedicalWithin365Days' else '' end + ' | ' +
			case when abs(CbrException) & 32768 = 32768 then 'InvalidContractToPay' else '' end + ' | ' +
            case when OutofStatute = 1 then 'OutofStatute' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 65536 = 65536 then 'NullDebtorName' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 131072 = 131072 then 'InvalidDebtorName' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 262144 = 262144 then 'NullDebtorZipcode' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 524288 = 524288 then 'InvalidDebtorZipcode' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 1048576 = 1048576 then 'ZeroedDebtorZipcode' else '' end + ' | ' +
            case when IsBusiness = 1 then 'Business' else '' end + ' | ' +
            case when RptDtException = 1 then 'ReportDateNotMet' else '' end + ' | ' +
            case when MinBalException = 1 then 'MinBalException' else '' end  as comment
		
	from cbr_exceptions x ;
	
	insert into cbr_audit(accountid, debtorid, datecreated, [user], comment)
	select 	a.accountid, a.debtorid, getdate(), 'SYSTEM', 
		case 
			when a.racctstat = 'DF' then 'Account fraud, deletion submitted in credit bureau report file.' 
			when a.racctstat = 'DA' and a.specialnote = 'DI' then 'Account deletion submitted due to payment by insurance in credit bureau report file'
			when a.racctstat = 'DA' then 'Account deletion submitted in credit bureau report file.' 
			when a.racctstat IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') and a.rcompliance like 'X%' then 'Account dispute ' + a.rcompliance + ' submitted in credit bureau report file.' 
			when a.racctstat IN ('62', '64') and a.rspcomment = 'AU' then 'Account SIF submitted in credit bureau report file.' 
			when a.racctstat IN ('62', '64') then 'Account PIF submitted in credit bureau report file.' 
			when a.racctstat = '93' then 'Open collection account submitted in credit bureau report file.' 
			when a.racctstat IN ('11', '71', '78', '80', '82', '83', '84', '97') then 'Charge-off account submitted in credit bureau report file.'
			when a.racctstat IN ('11', '71', '78', '80', '82', '83', '84', '97') and a.portfolioindicator = 2 then 'Charge-off Account Sold'
			else 'Unknown account status'
			
		end as comment
	from cbrDataPendingDtlex2(NULL) a 
	inner join cbr_metro2_files f  on f.fileID = a.fileID
	where f.fileID = @fileID and a.fileID = @fileID and a.seq = 0
	
	union all
	
	select 	x.number, x.debtorid, getdate(), 'SYSTEM', 
			case when StatusCbrReport = 0 then 'NotConfigured'  else '' end + ' | ' +
			Case when cbrenabled = 1 then 'cbrenabled' else '' end + ' | ' +
			Case when cbroverride = 1 then 'cbrOverride' else '' end + ' | ' +
			case when cbrexclude = 1 then 'DebtorExcluded' else '' end + ' | ' +
            case when responsible = 0 then 'DebtorNotResponsible' else '' end + ' | ' +
            case when abs(cbrexception) & 1 = 1 then 'NullDelinquencyDt' else '' end + ' | ' +
            case when abs(cbrexception) & 2 = 2 then 'DelinquencyDt>Received' else '' end + ' | ' +
			case when abs(cbrexception) & 4 = 4 then 'DelinquencyDtWithin30daysOfReceived' else '' end + ' | ' +
			case when abs(cbrexception) & 8 = 8 then 'InvalidAcctType' else '' end + ' | ' +
			case when abs(cbrexception) & 16 = 16 then 'InvalidContractDate' else '' end + ' | ' +
			case when abs(cbrexception) & 32 = 32 then 'InvalidConsumerAccountNumber' else '' end + ' | ' +
			case when abs(cbrexception) & 64 = 64 then 'MissingChargeOffRecord' else '' end + ' | ' +
			case when abs(cbrexception) & 128 = 128 then 'MissingChargeOffAmount' else '' end + ' | ' +
			case when abs(cbrexception) & 256 = 256 then 'MissingSecondaryAgencyIdenitifier' else '' end + ' | ' +
			case when abs(cbrexception) & 512 = 512 then 'MissingSecondaryAccountNumber' else '' end + ' | ' +
			case when abs(cbrexception) & 1024 = 1024 then 'OpenChargeOffNotInBankruptcy' else '' end + ' | ' +
			case when abs(cbrexception) & 2048 = 2048 then 'MissingAcctOriginalCreditor' else '' end + ' | ' +
			case when abs(cbrexception) & 4096 = 4096 then 'MissingDefaultOriginalCreditor' else '' end + ' | ' +
			case when abs(cbrexception) & 8192 = 8192 then 'MissingCreditorClass' else '' end + ' | ' +
			case when abs(cbrexception) & 16384 = 16384 then 'MedicalWithin365Days' else '' end + ' | ' +
			case when abs(CbrException) & 32768 = 32768 then 'InvalidContractToPay' else '' end + ' | ' +
            case when OutofStatute = 1 then 'OutofStatute' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 65536 = 65536 then 'NullDebtorName' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 131072 = 131072 then 'InvalidDebtorName' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 262144 = 262144 then 'NullDebtorZipcode' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 524288 = 524288 then 'InvalidDebtorZipcode' else '' end + ' | ' +
            case when abs(DebtorExceptions) & 1048576 = 1048576 then 'ZeroedDebtorZipcode' else '' end + ' | ' +
            case when IsBusiness = 1 then 'Business' else '' end + ' | ' +
            case when RptDtException = 1 then 'ReportDateNotMet' else '' end + ' | ' +
            case when MinBalException = 1 then 'MinBalException' else '' end  as comment
		
	from cbr_exceptions x ;

	DELETE  FROM cbr_accounts
		WHERE accountid IN ( SELECT accountid FROM cbrAccountHistory(NULL) WHERE accountstatus IN ('62', '64','DA','DF') ) ;

	declare @sql nvarchar(500);
	declare @MDop int;
	declare @ParmDefinition nvarchar(500);
	set @MDop = 3;
	set @ParmDefinition = N'@MaxDop integer';
	set @sql = N'[dbo].[cbrauditdatacapture2] @MaxDop'
	execute sp_executesql @sql, @ParmDefinition, @MaxDop = @MDop;

	truncate table cbrDataCycleEndReported;
	insert into cbrDataCycleEndReported select * from cbrDataReported2(null);

	update GlobalSettings set IntValue1 = null, DateValue1 = null
	where NameSpace = 'Credit Reporting' and SettingName = 'Defer CBR Export Post Processing'

ExitProcedure:
	
GO
