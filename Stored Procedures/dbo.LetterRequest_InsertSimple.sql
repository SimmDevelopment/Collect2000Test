SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.LetterRequest_InsertSimple*/
CREATE  PROCEDURE [dbo].[LetterRequest_InsertSimple]
            @AccountID int,
            @DebtorID int,
            @LetterCode varchar(5),
            @RequestForDate datetime,
            @UserName varchar(10),
            @LetterRequestID int output
AS
-- Name:                        LetterRequest_InsertSimple
-- Function:                    Inserts a dunning letter into LetterRequests and LetterRequestRecipient table
--                                  Not used for other letter types such as PDC or PPA
-- Creation:                    12/2/2003 mr
-- Change History:          01/29/2004 jc Added distinct keyword to select statement to avoid problem
--                                  of multiple custltrallow records of same customer same letter.
--                                  
Declare @NULLDate datetime
Declare @Empty varchar(1)
DECLARE @Error INTEGER;

SET @NullDate = '1/1/1753 12:00:00'
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
            @NullDate,
            0,
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
INNER JOIN Letter L
ON L.Code = @LetterCode
INNER JOIN CustLtrAllow CLA
ON M.customer = CLA.CustCode AND CLA.LtrCode = @lettercode
WHERE m.number = @AccountID;

SET @Error = @@Error;

SELECT @LetterRequestID = SCOPE_IDENTITY();

IF @LetterRequestID IS NOT NULL AND @Error = 0 BEGIN
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
