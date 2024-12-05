SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CCCS_Update]
	@ID INTEGER,
	@CompanyName VARCHAR(100),
	@Street1 VARCHAR(50),
	@Street2 VARCHAR(50),
	@City VARCHAR(100),
	@State VARCHAR(3),
	@ZipCode VARCHAR(10),
	@Phone VARCHAR(50),
	@Fax VARCHAR(50),
	@Contact VARCHAR(100),
	@ClientID VARCHAR(50),
	@CreditorID VARCHAR(50),
	@AcceptedAmount MONEY,
	@DateAccepted DATETIME,
	@Comments VARCHAR(2000)
AS
SET NOCOUNT ON;

UPDATE [dbo].[CCCS]
SET [CompanyName] = @CompanyName,
	[Street1] = @Street1,
	[Street2] = @Street2,
	[City] = @City,
	[State] = @State,
	[ZipCode] = @ZipCode,
	[Phone] = @Phone,
	[Fax] = @Fax,
	[Contact] = @Contact,
	[ClientID] = @ClientID,
	[CreditorID] = @CreditorID,
	[AcceptedAmount] = @AcceptedAmount,
	[DateAccepted] = @DateAccepted,
	[Comments] = @Comments,
	[DateModified] = GETDATE()
WHERE [CCCS].[ID] = @ID;

IF @@ERROR <> 0 RETURN 1;

RETURN 0;

GO