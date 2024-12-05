SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_UpdateCheck]
	@ID INTEGER,
	@Deposit DATETIME,
	@Amount MONEY,
	@CheckNumber CHAR(10),
	@SurchargeCheckNumber CHAR(10),
	@LetterCode VARCHAR(5), -- ignored, the arrangements panel does not have good access to the loaded letter code, leave arg in for incidental compatibility
	@Desk VARCHAR(10), -- ignored
	@Customer VARCHAR(7), -- ignored
	@Surcharge MONEY,
	@Printed VARCHAR(1),
	@ApprovedBy VARCHAR(10),
	@ProjectedFee MONEY,
	@UseProjectedFee BIT,
	@CollectorFee MONEY,
	@Nitd DATETIME, -- ignored
	@DepositToGeneralTrust BIT, -- ignored
	@DebtorBankID INTEGER -- ignored
AS
SET NOCOUNT ON;

UPDATE [dbo].[pdc]
SET [amount] = @Amount,
	[deposit] = @Deposit,
	[checknbr] = @CheckNumber,
	[SurchargeCheckNbr] = @SurchargeCheckNumber,
--	[LtrCode] = @LetterCode, -- ignored
--	[Desk] = @Desk, -- ignored
--	[Customer] = @Customer, -- ignored
	[Surcharge] = @Surcharge,
	[Printed] = case @Printed when 'Y' then 1 when 'N' then 0 when '1' then 1 when '0' then 0 else NULL end,
	[ApprovedBy] = @ApprovedBy,
	[ProjectedFee] = @ProjectedFee,
	[UseProjectedFee] = @UseProjectedFee,
	[CollectorFee] = @CollectorFee
--	[nitd] = @Nitd, -- ignored
--	[DepositToGeneralTrust] = COALESCE(@DepositToGeneralTrust, [DepositToGeneralTrust]),
--	[DebtorBankID] = COALESCE(@DebtorBankID, [DebtorBankID])
WHERE [UID] = @ID;

RETURN 0;
GO
