SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[LionGetLettersByNumber]
(
	@number int
)
AS
	SET NOCOUNT ON;
SELECT     LetterRequestID, AccountID, CustomerCode, LetterID, LetterCode, DateRequested, DateProcessed, Description, JobName, DueDate, AmountDue, UserName, 
                      Suspend, SifPmt1, SifPmt2, SifPmt3, SifPmt4, SifPmt5, SifPmt6, Manual, Edited, Deleted, DateCreated, ErrorDescription, DateUpdated, 
                      SubjDebtorID
FROM         LionLetterView
WHERE     (DateProcessed > CONVERT(DATETIME, '1900-01-01 00:00:00', 102)) AND (ErrorDescription IS NULL OR
                      ErrorDescription = '') AND (AccountID = @number)
GO
