CREATE TABLE [dbo].[Custom_Equabli_Account_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliPlacementId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[agencyCycle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[originalLenderCreditor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currentLenderCreditor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[originalAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[additionalAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[consentFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customerType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateAccountOpened] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateLastPayment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastPaymentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateofdelinquency] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[chargeOffDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastPurchaseDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastCashAdvanceDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastBalanceTransferDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[interestAccuredPostChargeOff] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[feesAccuredPostChargeOff] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postChargeOffPayments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postChargeOffCredits] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postChargeOffFeesRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postChargeOffInterestRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preChargeOffPrincipal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preChargeOffInterest] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preChargeOffInterestRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preChargeOffFees] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeOffBalance] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preChargeOffFeeRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amountAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[principalAmountAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[interstAmountAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lateFeesAmountAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[otherFeesAmountAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastPurchaseAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastCashAdvanceAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastBalanceTransferAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[courtCostsAmountAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attorneyFeesAmountAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastContactDatePreChargeOff] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateFirstDelinquency] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelMilitaryStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelCeaseDesistFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[productCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postChargeOffUnpaidCharges] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[monthlyPaymentBeforeChargeoff] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOLDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountOpenLocation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[applicationType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountOpenIPAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[debtSettlementFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[affinity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[debtType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[productSubType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creditLimit] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[originalBal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appApr] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loanReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[originTerm] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appReqLoanAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentUnitsPostCo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nsfUnitsPostCo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nsfDollarsPostCo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[receivingMailedStatements] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientPortfolioId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bankruptcyStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isDeceased] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isFraud] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelOFACFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountChannel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelAttorneyRepFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelCCCSFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountLevelLitigiousFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[preLegalTalkoff] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Account_Info] ADD CONSTRAINT [PK_Custom_Equabli_Account_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO