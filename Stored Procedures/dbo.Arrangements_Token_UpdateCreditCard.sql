SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_Token_UpdateCreditCard]
	@ID INTEGER,
	@PaymentVendorTokenId INTEGER,
	@StateL VARCHAR(3),
	@ZipCodeL VARCHAR(10),
	@CreditCard VARCHAR(4),
	@Amount MONEY,
	@Printed VARCHAR(1),
	@ApprovedBy VARCHAR(10),
	@DepositDate DATETIME,
	@LetterCode VARCHAR(5), -- ignored, the arrangements panel does not have good access to the loaded letter code, leave arg in for incidental compatibility
	@NITDSentDate DATETIME,
	@ProjectedFee MONEY,
	@UseProjectedFee BIT,
	@SurCharge MONEY,
	@AuthDate DATETIME,
	@AuthCode VARCHAR(255),
	@AuthErrCode INTEGER,
	@AuthErrDesc VARCHAR(255),
	@AuthAVS VARCHAR(3),
	@AuthCVV2 VARCHAR(3),
	@AuthReferenceNumber VARCHAR(50),
	@AuthSource VARCHAR(16),
	@BatchNumber INTEGER
AS
SET NOCOUNT ON;

UPDATE [dbo].[DebtorCreditCards]
SET [CreditCard] = ISNULL(@CreditCard, [CreditCard]), 
	[PaymentVendorTokenId] = ISNULL(@PaymentVendorTokenId, [PaymentVendorTokenId]), 
	[Amount] = @Amount,
	[Printed] = @Printed,
	[ApprovedBy] = @ApprovedBy,
	[DepositDate] = @DepositDate,
--	[LetterCode] = @LetterCode, -- ignored
	[NITDSentDate] = @NITDSentDate,
	[ProjectedFee] = @ProjectedFee,
	[UseProjectedFee] = @UseProjectedFee,
	[SurCharge] = @SurCharge,
	[AuthDate] = @AuthDate,
	[AuthCode] = @AuthCode,
	[AuthErrCode] = @AuthErrCode,
	[AuthErrDesc] = @AuthErrDesc,
	[AuthAVS] = @AuthAVS,
	[AuthCVV2] = @AuthCVV2,
	[AuthReferenceNumber] = @AuthReferenceNumber,
	[AuthSource] = @AuthSource,
	[BatchNumber] = @BatchNumber
WHERE [ID] = @ID;

RETURN 0;
GO
