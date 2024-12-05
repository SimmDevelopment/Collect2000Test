SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_InsertLedgerMedia]

 

@LedgerID int,

@WantsStatements bit,

@StatementStartDate datetime,

@StatementEndDate datetime,

@StatementsCount int,

@StatementTotalCost money,

@StatementComment text,

@WantsApplication bit,

@ApplicationTotalCost money,

@ApplicationComment text,

@WantsLenderAffidavit bit,

@LenderAffidavitTotalCost money,

@LenderAffidavitComment text,

@WantsThirdPartyAffidavit bit,

@ThirdPartyAffidavitTotalCost money,

@ThirdPartyAffidavitComment text,

@WantsAffidavitLostLoanDoc bit,

@AffidavitLostLoanDocTotalCost money,

@AffidavitLostLoanDocComment text,

@WantsLastPayment bit,

@LastPaymentTotalCost money,

@LastPaymentComment text,

@WantsContract bit,

@ContractTotalCost money,

@ContractComment text,

@WantsPaymentChecks bit,

@PaymentChecksStartDate datetime,

@PaymentChecksEndDate datetime,

@PaymentChecksCount int,

@PaymentChecksTotalCost money,

@PaymentChecksComment text,

@WantsOtherMedia bit,

@OtherMediaCost money,

@OtherMediaComment text,

@StorageLocation varchar(500)

 

AS

 

INSERT INTO AIM_LedgerMedia

(

 

LedgerID,

WantsStatements,

StatementStartDate,

StatementEndDate,

StatementsCount,

StatementTotalCost,

StatementComment,

WantsApplication,

ApplicationTotalCost,

ApplicationComment,

WantsLenderAffidavit,

LenderAffidavitTotalCost,

LenderAffidavitComment,

WantsThirdPartyAffidavit,

ThirdPartyAffidavitTotalCost,

ThirdPartyAffidavitComment,

WantsAffidavitLostLoanDoc,

AffidavitLostLoanDocTotalCost,

AffidavitLostLoanDocComment,

WantsLastPayment,

LastPaymentTotalCost,

LastPaymentComment,

WantsContract,

ContractTotalCost,

ContractComment,

WantsPaymentChecks,

PaymentChecksStartDate,

PaymentChecksEndDate,

PaymentChecksCount,

PaymentChecksTotalCost,

PaymentChecksComment,

WantsOtherMedia,

OtherMediaCost,

OtherMediaComment,

StorageLocation

)

VALUES

(

 

@LedgerID,

@WantsStatements,

@StatementStartDate,

@StatementEndDate,

@StatementsCount,

@StatementTotalCost,

@StatementComment,

@WantsApplication,

@ApplicationTotalCost,

@ApplicationComment,

@WantsLenderAffidavit,

@LenderAffidavitTotalCost,

@LenderAffidavitComment,

@WantsThirdPartyAffidavit,

@ThirdPartyAffidavitTotalCost,

@ThirdPartyAffidavitComment,

@WantsAffidavitLostLoanDoc,

@AffidavitLostLoanDocTotalCost,

@AffidavitLostLoanDocComment,

@WantsLastPayment,

@LastPaymentTotalCost,

@LastPaymentComment,

@WantsContract,

@ContractTotalCost,

@ContractComment,

@WantsPaymentChecks,

@PaymentChecksStartDate,

@PaymentChecksEndDate,

@PaymentChecksCount,

@PaymentChecksTotalCost,

@PaymentChecksComment,

@WantsOtherMedia,

@OtherMediaCost,

@OtherMediaComment,

@StorageLocation

)


GO
