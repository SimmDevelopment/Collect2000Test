SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_ProcessImportAccount] 
	@UID int,
	@TargetDesk varchar(10),
	@NewAccountID int Output,
	@ReturnStatus int Output
AS

Declare @Name varchar(30)
Declare @Other varchar(30)
Declare @Street1 varchar(30)
Declare @Street2 varchar(30)
Declare @City varchar (30)
Declare @State varchar (3)
Declare @Zipcode varchar(10)
Declare @SSN varchar (15)
Declare @DOB datetime
Declare @Customer varchar(8)
Declare @DelinquencyDate datetime
Declare @AccountNumber varchar (30)
Declare @Received datetime
Declare @SysMonth tinyint
Declare @SysYear smallint
Declare @Original money
Declare @Original1 money
Declare @Original2 money
Declare @Original3 money
Declare @Original4 money
Declare @Original5 money
Declare @Original6 money
Declare @Original7 money
Declare @Original8 money
Declare @Original9 money
Declare @Original10 money
Declare @CurrencyType varchar(20)
Declare @CLIDLP datetime
Declare @CLIDLI datetime
Declare @CLIDLC datetime
Declare @IntRate real
Declare @HomePhone varchar(30)
Declare @WorkPhone varchar(30)

SELECT Code FROM Desk where Code = @TargetDesk
IF (@@rowcount=0)BEGIN
	SET @ReturnStatus = -1
	Return @ReturnStatus
END

SELECT @Name=Name, @Other=OtherName, @Street1=Street1, @Street2=Street2, @City=City, @State=State, @Zipcode=Zipcode, @SSN=SSN, @DOB=DOB,
	@Customer=Customer, @DelinquencyDate=DelinquencyDate, @AccountNumber=AccountNumber,  @Received=Received, @Original=Original,
	@Original1=Original1, @Original2=Original2, @Original3=Original3, @Original4=Original4, @Original5=Original5, 
	@Original6=Original6, @Original7=Original7, @Original8=Original8, @Original9=Original9,  @Original10=Original10,  
	@CurrencyType=CurrencyType,  @CLIDLP=CLIDLP, @CLIDLI=CLIDLI, @CLIDLC=CLIDLC,
	@IntRate=IntRate, @HomePhone=HomePhone, @WorkPhone=WorkPhone
FROM ImportAccounts WHERE UID = @UID

SELECT @NewAccountID=NextDebtor, @SysMonth=CurrentMonth, @SysYear=CurrentYear FROM controlfile

UPDATE controlfile set NextDebtor = @NewAccountID + 1

INSERT INTO Master (number, Desk, Name, Other, Street1, Street2, City, State, Zipcode, SSN, DOB, Customer, Account, Received,
	Original, Original1, Original2, Original3, Original4, Original5, Original6, Original7,
	Original8, Original9, Original10, CurrencyType, CLIDLP, lastinterest, CLIDLC,
	InterestRate, HomePhone, WorkPhone, SysMonth, SysYear, Status, QLevel, QDate,
	Paid, Paid1, Paid2, Paid3, Paid4, Paid5, Paid6, Paid7, Paid8, Paid9, Paid10,
	Current0, Current1, Current2, Current3, Current4, Current5, Current6, Current7, Current8, Current9, Current10,
	TotalViewed, Totalworked, TotalContacted, DelinquencyDate)
VALUES(@NewAccountID, @TargetDesk, @Name, @Other, @Street1, @Street2, @City, @State, @Zipcode, @SSN, @DOB, @Customer, @AccountNumber, @Received,
	@Original, @Original1, @Original2, @Original3, @Original4, @Original5, @Original6, @Original7,
	@Original8, @Original9, @Original10, @CurrencyType, @CLIDLP, @CLIDLI, @CLIDLC,
	@IntRate, @HomePhone, @WorkPhone, @SysMonth, @SysYear, 'NEW', '015', convert(varchar,getdate(),112),
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0, @DelinquencyDate)

IF (@@Error<>0) BEGIN
	SET @ReturnStatus = @@Error
	Return @ReturnStatus
END

INSERT INTO BigNotes(number, BigNote)
Select @NewAccountID, BigNote FROM ImportBigNotes Where ImportAcctID = @UID


IF (@@error <> 0) BEGIN
	SET @ReturnStatus = @@Error
	Return @ReturnStatus
END
ELSE BEGIN
	SET @ReturnStatus=0
	Return @ReturnStatus
END

GO
