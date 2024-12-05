SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[cbrPostHistory]
	@fileName varchar(255), @userName varchar(50), @fileId int output

AS
	declare @dateReported datetime;
	declare @deferExport bit;
	declare @ExportExists int;
	
	select @deferExport = bitvalue, @ExportExists = IntValue1 from GlobalSettings
	where NameSpace = 'Credit Reporting' and SettingName = 'Defer CBR Export Post Processing'
	
	if @ExportExists is not null
	begin
		RAISERROR ('Cannot run cbrPostHistory because an export exists that has not been fully processed.  Please run cbrPostHistoryDeferCleanup to finish processing the prior Export.', 16, 1) WITH LOG	
	end
	
	if not object_id('tempdb..#donotreportaccountagain') is null drop table #donotreportaccountagain
	create table #donotreportaccountagain (AccountID int, Accountstatus varchar(2), portfolioindicator int);

	if not object_id('tempdb..#donotreportdebtoragain') is null drop table #donotreportdebtoragain
	create table #donotreportdebtoragain (AccountID int, InformationIndicator varchar(2), debtorseq int, debtorid int, ecoacode varchar(8));
	
	if not object_id('tempcbrAccountHistory') is null drop table tempcbrAccountHistory

	if not object_id('tempcbrDebtorHistory') is null drop table tempcbrDebtorHistory
	
	if not object_id('tempcbrAccountHistorykeys') is null drop table tempcbrAccountHistorykeys

	--assign local variables
	set @dateReported = GETDATE()

	--insert cbr_metro2_files
	insert into cbr_metro2_files(fileName, dateCreated, userName)
	values(@fileName, @dateReported, @userName)
	
	--assign returned id to local variable
	select @fileID = @@identity

	--populate tempcbrAccountHistory
	select * into tempcbrAccountHistory
	from cbrAccountHistory(null)

	--populate tempcbrDebtorHistory
	select * into tempcbrDebtorHistory
	from cbrDebtorHistory(null)

	--populate tempcbrAccountHistorykeys
	select Accountid, fileid into tempcbrAccountHistorykeys
	from cbrAccountHistory(null)
	group by accountid, fileid

	--insert cbr_metro2_accounts
	insert into cbr_metro2_accounts (
	fileID, dateReported, accountid, customerID, primaryDebtorID, portfolioType, accountType, accountStatus, 
	originalLoan, actualpayment, currentBalance, amountPastDue, termsDuration,
	specialComment, complianceCondition, openDate, billingDate, 
	delinquencyDate, closedDate, lastPaymentDate, originalCreditor, creditorClassification,
    [ChargeOffAmount], [PaymentHistoryProfile], [PaymentHistoryDate], [ConsumerAccountNumber], [CreditLimit],
    [SecondaryAgencyIdenitifier], [SecondaryAccountNumber], [MortgageIdentificationNumber],
    [PortfolioIndicator], [SoldToPurchasedFrom])
  	OUTPUT inserted.accountid, inserted.Accountstatus, inserted.portfolioindicator INTO #donotreportaccountagain
	select 	@fileID, @dateReported, accountid, customerID, primaryDebtorID, portfolioType, accountType, 
	accountStatus, originalLoan, actualpayment, currentBalance, amountPastDue, termsDuration,
	specialComment, complianceCondition, openDate, billingDate, delinquencyDate, closedDate, 
	lastPaymentDate, originalCreditor, creditorClassification,
    [ChargeOffAmount], [PaymentHistoryProfile], [PaymentHistoryDate], [ConsumerAccountNumber], [CreditLimit],
    [SecondaryAgencyIdenitifier], [SecondaryAccountNumber], [MortgageIdentificationNumber],
    [PortfolioIndicator], [SoldToPurchasedFrom]
	from cbr_accounts a with(nolock)
	where a.written = 1 

	--insert cbr_metro2_debtors
	insert into cbr_metro2_debtors (
	recordID, dateReported, debtorid, debtorseq, accountid, transactionType, name, surname, firstName, 
	middleName, suffix, generationCode, ssn, dob, phone, ecoaCode, informationIndicator, countryCode, 
	address1, address2, city, state, zipcode, addressIndicator, residenceCode)
	OUTPUT inserted.accountid, inserted.informationindicator, inserted.debtorSeq, inserted.debtorID, inserted.ecoacode INTO #donotreportdebtoragain
	select 
	a.recordID, a.dateReported, d.debtorid, d.debtorseq, d.accountid, d.transactionType, d.name, 
	d.surname, d.firstName, d.middleName, d.suffix, d.generationCode, d.ssn, d.dob, d.phone, d.ecoaCode, 
	d.informationIndicator, d.countryCode, d.address1, d.address2, d.city, d.state, d.zipcode, 
	d.addressIndicator, d.residenceCode
	from cbr_debtors d with(nolock)
	inner join cbr_metro2_accounts a with(nolock) on a.accountID = d.accountid and a.fileID = @fileID;

	--update cbr_accounts lastFileID
	update cbr_accounts set lastFileID = @fileID, lastreported = @dateReported where written = 1 ;

	--prevent discharged bankruptcies, deceased primary debtors from future activity
	--prevent DA and sold portfolio accts from future activity

	with Updateset as 
		(select d.Accountid ,d.debtorid
		  from #donotreportdebtoragain d where d.InformationIndicator in ('E','F','G','H') OR (d.ecoacode = 'X' AND d.debtorseq = 0)	--prevent excluded debtors fom reporting in general
		  union 
		  select a.accountid, null  from #donotreportaccountagain a where a.Accountstatus IN ('DA','DF') OR a.portfolioindicator = 2
		  union 
		  select null  ,d.debtorid
		  from #donotreportdebtoragain d where d.ecoacode  IN ('X','T','Z') AND d.debtorseq <> 0)	--prevent excluded debtors fom reporting in general
		  	  
	update master 
	set cbrPrevent = 1 
	from Updateset u
	inner join master m on u.AccountID = m.number
	;
	
	with UpdateDbtrset as 
		(select d.debtorid 
		  from #donotreportdebtoragain d where (d.ecoacode IN ('X','T','Z') AND d.debtorseq <> 0)
		  )
		  
	update Debtors 
	set cbrExclude = 1 
	from UpdateDbtrset u
	inner join Debtors d on u.debtorid = d.debtorid
	Where d.Seq <> 0 AND ISNULL(d.cbrExclude,0)=0
	;
	
	with UpdatePndDbtrset as 
		(select d.debtorid 
		  from #donotreportdebtoragain d where (d.ecoacode IN ('X','T','Z') AND d.debtorseq <> 0)
		  )
		  
	delete from cbr_debtors 
	from UpdatePndDbtrset u
	inner join cbr_debtors d on u.debtorid = d.debtorid
	;	

	if not object_id('tempcbrAccountHistory') is null drop table tempcbrAccountHistory

	if not object_id('tempcbrDebtorHistory') is null drop table tempcbrDebtorHistory
	
	if not object_id('tempcbrAccountHistorykeys') is null drop table tempcbrAccountHistorykeys

	--populate tempcbrAccountHistory
	select * into tempcbrAccountHistory
	from cbrAccountHistory(null)

	--populate tempcbrDebtorHistory
	select * into tempcbrDebtorHistory
	from cbrDebtorHistory(null)

	--populate tempcbrAccountHistorykeys
	select Accountid, fileid into tempcbrAccountHistorykeys
	from cbrAccountHistory(null)
	group by accountid, fileid

	If @deferExport = 1
	BEGIN
		UPDATE GlobalSettings
		SET IntValue1 = @fileId, DateValue1 = @dateReported
		WHERE NameSpace = 'Credit Reporting' AND SettingName = 'Defer CBR Export Post Processing'
		GOTO DeferExportExit
	END
	
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
	
DeferExportExit:

GO
