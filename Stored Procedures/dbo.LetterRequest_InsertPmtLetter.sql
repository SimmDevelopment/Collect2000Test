SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*dbo.LetterRequest_InsertPmtLetter*/
CREATE  PROCEDURE [dbo].[LetterRequest_InsertPmtLetter]
	@AccountID int,
	@DebtorID int,
	@LetterCode varchar(5),
	@AmountDue money,
	@DateDue smalldatetime,
	@RequestForDate datetime,
	@UserName varchar(10),
	@LetterRequestID int output
AS

-- Name:		LetterRequest_InsertPmtLetter
-- Function:		Inserts a Payment type letter (NITD, Pmt Reminder) into LetterRequests and LetterRequestRecipient table
-- Used by :		C2KPayment.dll (ScheduleNITD)
-- Creation:		8/8/2004 mr
-- Change History:	
--			


Declare @Empty varchar(1)
SET @Empty = ''

BEGIN TRAN

INSERT INTO LetterRequest
(
AccountID,
CustomerCode,
LetterID,
LetterCode,
DateRequested,
DueDate,
AmountDue,
UserName,
Suspend,
SifPmt1,
SifPmt2,
SifPmt3,
SifPmt4,
SifPmt5,
SifPmt6,
CopyCustomer,
SaveImage,
ProcessingMethod,
DateCreated,
DateUpdated,
FutureID,
SubjDebtorID
)
SELECT distinct
	@AccountID,
	M.Customer,
	L.LetterID,
	@lettercode,
	@RequestForDate,
	@DateDue,
	@AmountDue,
	@UserName,
	0,
	@Empty,
	@Empty,
	@Empty,
	@Empty,
	@Empty,
	@Empty,
	CLA.CopyCustomer,
	CLA.SaveImage,
	0,
	GetDate(),
	GetDate(),
	0,
	@DebtorID

FROM Master M
JOIN Letter L ON L.Code = @LetterCode
JOIN CustLtrAllow CLA ON M.customer = CLA.CustCode AND CLA.LtrCode = @lettercode
WHERE m.number = @AccountID

IF @@Error = 0 BEGIN
	SELECT @LetterRequestID = SCOPE_IDENTITY()

	--Now add the recipient
	INSERT INTO LetterRequestRecipient(LetterRequestID,AccountID,Seq,DebtorID)
	SELECT @LetterRequestID, @AccountID, Seq, @DebtorID FROM Debtors where DebtorID = @DebtorID

	IF @@Error = 0 BEGIN
		COMMIT TRAN
		Return 0
	END
END

--If this executes there was a error
Rollback Tran
Return @@Error




GO
