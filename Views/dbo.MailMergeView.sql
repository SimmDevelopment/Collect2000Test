SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*View dbo.MailMergeView*/
CREATE VIEW [dbo].[MailMergeView]
AS
-- Name:		MailMergeView
-- Function:		This view will retrieve letter requests which have not yet been processed 
-- Creation:		Unknown
-- Change History:	11/21/2003 jc revised the view to query letterrequest tables 
--			rather than future table

	SELECT TOP 100 PERCENT dbo.letterrequest.accountid AS FileNumber, dbo.letterrequest.DateCreated, 
		dbo.letterrequest.DateRequested, dbo.letterrequest.LetterCode, dbo.letterrequest.DueDate, 
		dbo.letterrequest.AmountDue, dbo.letterrequest.SifPmt1, dbo.letterrequest.SifPmt2, 
		dbo.letterrequest.SifPmt3, dbo.letterrequest.SifPmt4, dbo.letterrequest.SifPmt5, 
		dbo.letterrequest.SifPmt6, dbo.letterrequest.LetterRequestID, dbo.master.*, 
		dbo.letterrequestrecipient.Seq AS DebtorSeq, dbo.letterrequest.UserName
	FROM dbo.letterrequest 
	INNER JOIN dbo.master ON dbo.letterrequest.accountid = dbo.master.number
	INNER JOIN dbo.letterrequestrecipient ON dbo.letterrequest.LetterRequestID = dbo.letterrequestrecipient.LetterRequestID
	WHERE dbo.letterrequest.DateProcessed = '1753-01-01 12:00:00.000'
	AND dbo.letterrequest.Deleted = 0
	AND dbo.letterrequest.Suspend = 0
	ORDER BY dbo.letterrequest.DateRequested, dbo.letterrequest.accountid
	 /*
	-- this is the old query
	SELECT TOP 100 PERCENT dbo.future.number AS FileNumber, dbo.future.Entered, dbo.future.Requested, 
		dbo.future.[action], dbo.future.lettercode, dbo.future.duedate, dbo.future.amtdue, dbo.future.SifPmt1, 
		dbo.future.SifPmt2, o.future.SifPmt3, dbo.future.SifPmt4, dbo.future.SifPmt5, dbo.future.SifPmt6, 
		dbo.future.uid, dbo.master.*, dbo.future.ctl AS DebtorSeq, dbo.future.user0
	FROM dbo.future 
	INNER JOIN dbo.master ON dbo.future.number = dbo.master.number
	WHERE (dbo.future.[action] = 'Letter')
	ORDER BY dbo.future.Requested, dbo.future.number
	 */
GO
