SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spDebtorAttorney_Insert*/
CREATE  PROCEDURE [dbo].[spDebtorAttorney_Insert]
	@DebtorID int,
	@Name varchar (50),
	@Firm varchar (100),
	@Addr1 varchar (50),
	@Addr2 varchar (50),
	@City varchar (50),
	@State varchar (5),
	@Zipcode varchar (20),
	@Phone varchar (20),
	@Fax varchar (20),
	@Email varchar (50),
	@Remarks varchar (500),
	@ReturnID int output
AS
	Declare @AcctID int
	Declare @Err int

	Select @AcctID = number from Debtors where DebtorID = @DebtorID

	IF @AcctID > 0 BEGIN
		INSERT INTO DebtorAttorneys (AccountID, DebtorID, Name, Firm, Addr1, Addr2, City, State, Zipcode, Phone, Fax, Email, Comments)
		VALUES (@AcctID, @DebtorID, @Name, @Firm, @Addr1, @Addr2, @City, @State, @Zipcode, @Phone, @Fax, @Email, @Remarks)

		Set @Err = @@Error
		IF @Err = 0
			Select @ReturnID = SCOPE_IDENTITY()
		Return @Err
	END
	ELSE
		Return -1


GO
