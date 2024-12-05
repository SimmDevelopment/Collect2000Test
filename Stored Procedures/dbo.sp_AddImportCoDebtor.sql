SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_AddImportCoDebtor]
	@ImportAccountID int,
	@Seq int,
	@Name varchar (30),
	@Street1 varchar(30),
	@Street2 varchar(30),
	@City varchar (30),
	@State varchar (3),
	@ZipCode varchar (10),
	@HomePhone varchar (15),
	@WorkPhone varchar (15),
	@SSN varchar (20),
	@DOB datetime,
	@UID int Output,
	@ReturnStatus int output

AS

INSERT INTO ImportCoDebtors(UID, Seq, Name, Street1, Street2, City, State,
	Zipcode, HomePhone, WorkPhone, SSN, DOB)
VALUES(@ImportAccountID, @Seq, @Name, @Street1, @Street2, @City, @State, 
	@Zipcode, @HomePhone, @WorkPhone, @SSN, @DOB)

If (@@error <> 0) BEGIN
	Select @UID = SCOPE_IDENTITY()
	SET @ReturnStatus = 0	
END
ELSE
	SET @ReturnStatus = @@error

GO
