SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Bank_Insert]
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
	@PermitDepositToGeneral BIT,
	@ID INTEGER OUTPUT
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[bank] (
	[code],
	[ABA],
	[Name],
	[Street1],
	[Street2],
	[City],
	[State],
	[Zipcode],
	[phone],
	[AcctName],
	[CheckStockName],
	[AcctNum],
	[StartCheckNumber],
	[CurrencyISO3],
	[PermitDepositToGeneral])
VALUES (
	@code,
	@ABA,
	@Name,
	@Street1,
	@Street2,
	@City,
	@State,
	@Zipcode,
	@phone,
	@AcctName,
	@CheckStockName,
	@AcctNum,
	@StartCheckNumber,
	@CurrencyISO3,
	@PermitDepositToGeneral
);

SET @ID = SCOPE_IDENTITY();

RETURN 0;


GO
