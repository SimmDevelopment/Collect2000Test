SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CbrReportExceptionsDtl]
as
select      x.number,
			x.debtorid,
			case when x.cbrexclude = 1 then 'DebtorExcluded' else '' end  as CbrExclude,
            case when x.responsible = 0 and d.isauthorizedaccountuser = 0 then 'DebtorNotResponsible' else '' end as Responsible,
            case when x.responsible = 1 and d.isauthorizedaccountuser = 1 then 'AuthorizedUserIsResponsible' else '' end as AuthResponsible,
        
            case when abs(x.cbrexception) & 1 = 1 then 'NullDelinquencyDt' else '' end as Acctx1,
            case when abs(x.cbrexception) & 2 = 2 then 'DelinquencyDt>Received' else '' end as Acctx2,
			case when abs(x.cbrexception) & 4 = 4 then 'DelinquencyDtWithin30daysOfReceived' else '' end as Acctx3,
			case when abs(x.cbrexception) & 8 = 8 then 'InvalidAcctType' else '' end as Acctx4,
			case when abs(x.cbrexception) & 16 = 16 then 'InvalidContractDate' else '' end as Acctx5,
			case when abs(x.cbrexception) & 32 = 32 then 'InvalidConsumerAccountNumber' else '' end as Acctx6,
			case when abs(x.cbrexception) & 64 = 64 then 'MissingChargeOffRecord' else '' end as Acctx7,
			case when abs(x.cbrexception) & 128 = 128 then 'MissingChargeOffAmount' else '' end as Acctx8,
			case when abs(x.cbrexception) & 256 = 256 then 'MissingSecondaryAgencyIdenitifier' else '' end as Acctx9,
			case when abs(x.cbrexception) & 512 = 512 then 'MissingSecondaryAccountNumber' else '' end as Acctx10,
			case when abs(x.cbrexception) & 1024 = 1024 then 'OpenChargeOffNotInBankruptcy' else '' end as Acctx11,
			case when abs(x.cbrexception) & 2048 = 2048 then 'MissingAcctOriginalCreditor' else '' end as Acctx12,
			case when abs(x.cbrexception) & 4096 = 4096 then 'MissingDefaultOriginalCreditor' else '' end as Acctx13,
			case when abs(x.cbrexception) & 8192 = 8192 then 'MissingCreditorClass' else '' end as Acctx14,
			case when abs(x.cbrexception) & 16384 = 16384 then 'MedicalWithin365Days' else '' end as Acctx15,
			case when abs(x.CbrException) & 32768 = 32768 then 'InvalidContractToPay' else '' end as Acctx16,
			case when abs(x.CbrException) & 2097152 = 2097152 then 'InvalidOriginalLoanAmount' else '' end as Acctx17,
 
            case when x.OutofStatute = 1 then 'OutofStatute' else '' end as OutofStatute,
            

            case when abs(x.DebtorExceptions) & 65536 = 65536  then 'NullDebtorName' else '' end as Dbtrx1, 
            case when abs(x.DebtorExceptions) & 131072 = 131072 then 'InvalidDebtorName' else '' end as Dbtrx2, 
            case when abs(x.DebtorExceptions) & 262144 = 262144 then 'NullDebtorZipcode' else '' end as Dbtrx3, 
            case when abs(x.DebtorExceptions) & 524288 = 524288 then 'InvalidDebtorZipcode' else '' end as Dbtrx4, 
            case when abs(x.DebtorExceptions) & 1048576 = 1048576 then 'ZeroedDebtorZipcode' else '' end as Dbtrx5, 
            case when abs(x.DebtorExceptions) & 4194304 = 4194304 then 'InvalidDOB' else '' end as Dbtrx6, 
			case when abs(x.DebtorExceptions) & 8388608 = 8388608 then 'MissingSSN&DOB' else '' end as Dbtrx7,            
			case when abs(x.DebtorExceptions) & 16777216 = 16777216 then 'InvalidState' else '' end as Dbtrx8,
			case when abs(x.DebtorExceptions) & 33554432 = 33554432 then 'MissingStreetAddress' else '' end as Dbtrx9,
			case when abs(x.DebtorExceptions) & 67108864 = 67108864 then 'MissingCity' else '' end as Dbtrx10,	
			case when abs(x.DebtorExceptions) & 134217728 = 134217728 then 'InvalidSSN' else '' end as Dbtrx11,
            case when x.IsBusiness = 1 then 'Business' else '' end as IsBusiness,
            case when x.RptDtException = 1 then 'ReportDateNotMet' else '' end as RptDtException,
            case when x.MinBalException = 1 then 'MinBalException' else '' end as MinBalException,
            x.cbrexception as CbrExceptionValue,
            x.DebtorExceptions as DebtorExceptionsValue,
            x.CbrExclude as CbrExcludeValue,
            x.responsible as ResponsibleValue
            
            
from		dbo.cbr_exceptions x inner join debtors d on d.debtorid = x.debtorid 
       
GO
