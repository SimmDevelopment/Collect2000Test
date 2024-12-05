SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[Custom_Insert_PhoneHistory]
@AccountID int,
@DebtorID int,
@User varchar(50),
@PhoneType tinyint,
@OldPhone varchar(50) = '',
@NewPhone varchar(50) = ''
AS

Insert into PhoneHistory (AccountID, DebtorID, DateChanged, UserChanged, PhoneType,
OldNumber, NewNumber, TransmittedDate) VALUES (@AccountID, @DebtorID, GetDate(), @User, 
@PhoneType, @OldPhone, @NewPhone, null)



DECLARE @seq INT
SELECT @seq = seq + 1 FROM Debtors WITH (NOLOCK) WHERE DebtorID = @DebtorID

INSERT INTO NOTES (Number,Created,User0,Action,Result,Comment)
VALUES
(@AccountID,GETDATE(),'EXG','PHONE','CHNG','Debtor(' + cast(@seq as varchar(10)) +') ' + CASE @PhoneType WHEN 1 THEN 'Home' WHEN 2 THEN 'Work' ELSE 'Home' END + ' Phone: ' + @oldphone + '  to  ' +@newPhone)


GO
