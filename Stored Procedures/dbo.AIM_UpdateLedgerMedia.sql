SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_UpdateLedgerMedia]

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

UPDATE AIM_LedgerMedia
SET

WantsStatements = @WantsStatements,
StatementStartDate = @StatementStartDate,
StatementEndDate = @StatementEndDate,
StatementsCount = @StatementsCount,
StatementTotalCost = @StatementTotalCost,
StatementComment = @StatementComment,
WantsApplication = @WantsApplication,
ApplicationTotalCost = @ApplicationTotalCost,
ApplicationComment = @ApplicationComment,
WantsLenderAffidavit = @WantsLenderAffidavit,
LenderAffidavitTotalCost = @LenderAffidavitTotalCost,
LenderAffidavitComment = @LenderAffidavitComment,
WantsThirdPartyAffidavit = @WantsThirdPartyAffidavit,
ThirdPartyAffidavitTotalCost = @ThirdPartyAffidavitTotalCost,
ThirdPartyAffidavitComment = @ThirdPartyAffidavitComment,
WantsAffidavitLostLoanDoc = @WantsAffidavitLostLoanDoc,
AffidavitLostLoanDocTotalCost = @AffidavitLostLoanDocTotalCost,
AffidavitLostLoanDocComment = @AffidavitLostLoanDocComment,
WantsLastPayment = @WantsLastPayment,
LastPaymentTotalCost = @LastPaymentTotalCost,
LastPaymentComment = @LastPaymentComment,
WantsContract = @WantsContract,
ContractTotalCost = @ContractTotalCost,
ContractComment = @ContractComment,
WantsPaymentChecks = @WantsPaymentChecks,
PaymentChecksStartDate = @PaymentChecksStartDate,
PaymentChecksEndDate = @PaymentChecksEndDate,
PaymentChecksCount = @PaymentChecksCount,
PaymentChecksTotalCost = @PaymentChecksTotalCost,
PaymentChecksComment = @PaymentChecksComment,
WantsOtherMedia = @WantsOtherMedia,
OtherMediaCost = @OtherMediaCost,
OtherMediaComment = @OtherMediaComment,
StorageLocation = @StorageLocation

WHERE LedgerID = @LedgerID



GO
