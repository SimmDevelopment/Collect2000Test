SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CbrDataExceptionDtlex_Acct](@Accountid int)
returns table as
return

/* 
	These functions need to be kept in sync with all applicable changes: 
	CbrDataExceptionDtlex
	CbrDataExceptionDtlex_Acct
	CbrDataExceptionDtlex_All
*/
	
	with exceptions as (
			select Number, DebtorId, Responsible, CbrException, CbrExclude, OutOfStatute, DebtorExceptions, IsBusiness, RptDtException, MinBalException FROM dbo.cbr_exceptions WHERE Number = @Accountid
			),
	details as (
			select number,	debtorid, case when cbrexclude = 1 then 'DebtorExcluded' else '' end  as error from	exceptions
			union all
			select x.Number, x.DebtorId, case when x.Responsible = 0 and d.IsAuthorizedAccountUser = 0 then 'DebtorNotResponsible' else '' end as error 
			from exceptions x inner join debtors d on d.debtorid = x.debtorid
			union all 
			select x.Number, x.DebtorId, case when x.Responsible = 1 and d.IsAuthorizedAccountUser = 1 then 'AuthorizedUserIsResponsible' else '' end as error 
			from exceptions x inner join debtors d on d.debtorid = x.debtorid
			union all 
			select number,	debtorid, case when abs(cbrexception) & 1 = 1 then 'NullDelinquencyDt' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 2 = 2 then 'DelinquencyDt>Received' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 4 = 4 then 'DelinquencyDtWithin30daysOfReceived' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 8 = 8 then 'InvalidAcctType' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 16 = 16 then 'InvalidContractDate' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 32 = 32 then 'InvalidConsumerAccountNumber' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 64 = 64 then 'MissingChargeOffRecord' else '' end as error from	exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 128 = 128 then 'MissingChargeOffAmount' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 256 = 256 then 'MissingSecondaryAgencyIdenitifier' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 512 = 512 then 'MissingSecondaryAccountNumber' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 1024 = 1024 then 'OpenChargeOffNotInBankruptcy' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 2048 = 2048 then 'MissingAcctOriginalCreditor' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 4096 = 4096 then 'MissingDefaultOriginalCreditor' else '' end as error from	exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 8192 = 8192 then 'MissingCreditorClass' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(cbrexception) & 16384 = 16384 then 'MedicalWithin365Days' else '' end as error from	exceptions
			union all
			select number,	debtorid, case when abs(CbrException) & 32768 = 32768 then 'InvalidContractToPay' else '' end as error from	exceptions
			union all
			select number,	debtorid, case when abs(CbrException) & 2097152 = 2097152 then 'InvalidOriginalLoanAmount' else '' end as error from	exceptions
			union all
			select number,	debtorid, case when OutofStatute = 1 then 'OutofStatute' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 65536 = 65536 then 'NullDebtorName' else '' end as error  from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 131072 = 131072 then 'InvalidDebtorName' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 262144 = 262144 then 'NullDebtorZipcode' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 524288 = 524288 then 'InvalidDebtorZipcode' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 1048576 = 1048576 then 'ZeroedDebtorZipcode' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 4194304 = 4194304 then 'InvalidDOB' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 8388608 = 8388608 then 'MissingSSN&DOB' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 16777216 = 16777216 then 'InvalidState' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 33554432 = 33554432 then 'MissingStreetAddress' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 67108864 = 67108864 then 'MissingCity' else '' end as error from exceptions
			union all
			select number,	debtorid, case when abs(DebtorExceptions) & 134217728 = 134217728 then 'InvalidSSN' else '' end as error from exceptions
			union all						
			select number,	debtorid, case when IsBusiness = 1 then 'Business' else '' end as error from exceptions
			union all
			select number,	debtorid, case when RptDtException = 1 then 'ReportDateNotMet' else '' end as error from exceptions
			union all
			select number,	debtorid, case when MinBalException = 1 then 'MinBalException' else '' end as error from exceptions
            )
	select * from details where error <> ''  ;

GO
