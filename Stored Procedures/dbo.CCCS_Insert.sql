SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CCCS_Insert]
	@DebtorID INTEGER,
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
	@Comments VARCHAR(2000),
	@ReturnID INTEGER OUTPUT
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[CCCS] ([DebtorID], [CompanyName], [Street1], [Street2], [City], [State], [ZipCode], [Phone], [Fax], [Contact], [ClientID], [CreditorID], [AcceptedAmount], [DateAccepted], [Comments], [DateCreated], [DateModified])
VALUES (@DebtorID, @CompanyName, @Street1, @Street2, @City, @State, @ZipCode, @Phone, @Fax, @Contact, @ClientID, @CreditorID, @AcceptedAmount, @DateAccepted, @Comments, GETDATE(), GETDATE());

IF @@ERROR <> 0 RETURN 1;

SET @ReturnID = SCOPE_IDENTITY();

RETURN 0;

GO
