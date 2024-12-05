SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[LionLetterView]
AS
SELECT     dbo.LetterRequest.LetterRequestID, dbo.LetterRequest.AccountID, dbo.LetterRequest.CustomerCode, dbo.LetterRequest.LetterID, 
                      dbo.LetterRequest.LetterCode, dbo.LetterRequest.DateRequested, dbo.LetterRequest.DateProcessed, dbo.letter.Description, 
                      dbo.LetterRequest.JobName, dbo.LetterRequest.DueDate, dbo.LetterRequest.AmountDue, dbo.LetterRequest.UserName, dbo.LetterRequest.Suspend, 
                      dbo.LetterRequest.SifPmt1, dbo.LetterRequest.SifPmt2, dbo.LetterRequest.SifPmt3, dbo.LetterRequest.SifPmt4, dbo.LetterRequest.SifPmt5, 
                      dbo.LetterRequest.SifPmt6, dbo.LetterRequest.Manual, dbo.LetterRequest.Edited, dbo.LetterRequest.Deleted, dbo.LetterRequest.DateCreated, 
                      dbo.LetterRequest.ErrorDescription, dbo.LetterRequest.DateUpdated, dbo.LetterRequest.SubjDebtorID
FROM         dbo.LetterRequest INNER JOIN
                      dbo.letter ON dbo.LetterRequest.LetterID = dbo.letter.LetterID

GO
