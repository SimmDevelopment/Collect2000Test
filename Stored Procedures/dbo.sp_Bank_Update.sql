SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Bank_Update]
	@ID INTEGER,
	@code VARCHAR(5),
	@ABA VARCHAR(10),
	@Name VARCHAR(50),
	@Street1 VARCHAR(50),
	@Street2 VARCHAR(50),
	@City VARCHAR(20),
	@State VARCHAR(3),
	@Zipcode VARCHAR(10),
	@phone VARCHAR(20),
	@AcctName VARCHAR(50),
	@CheckStockName VARCHAR(50),
	@AcctNum VARCHAR(20),
	@StartCheckNumber VARCHAR(15),
	@CurrencyISO3 VARCHAR(3),
	@PermitDepositToGeneral BIT
AS
SET NOCOUNT ON;

UPDATE [dbo].[bank]
SET [code] = @code,
	[ABA] = @ABA,
	[Name] = @Name,
	[Street1] = @Street1,
	[Street2] = @Street2,
	[City] = @City,
	[State] = @State,
	[Zipcode] = @Zipcode,
	[phone] = @Phone,
	[AcctName] = @AcctName,
	[CheckStockName] = @CheckStockName,
	[AcctNum] = @AcctNum,
	[StartCheckNumber] = @StartCheckNumber,
	[CurrencyISO3] = @CurrencyISO3,
	[PermitDepositToGeneral] = @PermitDepositToGeneral
WHERE [ID] = @ID;

RETURN 0;


GO
