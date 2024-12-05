SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_ProcessImportCoDebtor]
	@UID int,
	@AcctID int,
	@ReturnStatus int Output

AS

	
INSERT INTO Debtors(Number, Seq, Name, Street1, Street2, City, State, Zipcode, HomePhone,
	WorkPhone, SSN, DOB)
SELECT @AcctID, Seq, Name, Street1, Street2, City, State, Zipcode, HomePhone, WorkPhone, SSN, DOB
FROM ImportCoDebtors WHERE UID = @UID


if (@@Error <> 0) BEGIN
	Set @ReturnStatus = @@error
	Return @@Error
END
ELSE BEGIN
	Set @ReturnStatus=0
	Return 0
END
GO
