SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_AddImportAccount]
	@DebtorName varchar(30),
	@OtherName varchar(30),
	@Street1 varchar(30),
	@Street2 varchar(30),
	@City varchar(20),
	@State varchar(3),
	@Zipcode varchar (10),
	@SSN varchar (15),
	@DOB datetime,
	@Customer varchar(8),
	@DelinquencyDate datetime,
	@AccountNumber varchar (30),
	@Original money,
	@Original1 money,
	@Original2 money,
	@Original3 money,
	@Original4 money,
	@Original5 money,
	@Original6 money,
	@Original7 money,
	@Original8 money,
	@Original9 money,
	@Original10 money,
	@CurrencyType varchar (20),
	@CLIDLP datetime,
	@CLIDLI datetime,
	@CLIDLC datetime,
	@IntRate real,
	@HomePhone varchar (30),
	@WorkPhone varchar (30),
	@IsPODAcct bit,
	@ReturnUID int output,
	@ReturnStatus int Output
AS

INSERT INTO ImportAccounts(Name, street1, Street2, City, State, Zipcode, SSN, DOB,
	Customer, DelinquencyDate, AccountNumber, Received, Original, Original1,
	Original2, Original3, Original4, Original5, Original6, Original7, Original8,
	Original9, Original10, CurrencyType, CLIDLP, CLIDLI, CLIDLC, IntRate, HomePhone, WorkPhone, IsPODAcct)
VALUES (@DebtorName, @Street1, @Street2, @City, @State, @Zipcode, @SSN, @DOB,
	@Customer, @DelinquencyDate, @AccountNumber, cast(CONVERT(varchar, GETDATE(), 107)as datetime), @Original, @Original1,
	@Original2, @Original3, @Original4, @Original5, @Original6, @Original7, @Original8, 
	@Original9, @Original10, @CurrencyType, @CLIDLP, @CLIDLI, @CLIDLC, @IntRate, @HomePhone, @WorkPhone, @IsPODAcct)

IF (@@Error = 0)BEGIN
	Select @ReturnUID=SCOPE_IDENTITY()
	SET @ReturnStatus = 0
END
ELSE
	SET @ReturnStatus = 0

GO
