SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*Daily_Account_Contacted_Add Procedure*/
CREATE PROCEDURE [dbo].[Daily_Account_Contacted_Add]
	@AccountID	int
AS

 /*
**Name		:Daily_Account_Contacted_Add Procedure
**Function	:Adds a record to the Daily_Account_Contacted table which the dialers read to find out if
**		:an account has been worked during the current day.  Table is cleared at night.
**Creation	:5/2004 mike Devlin
**Used by 	:Called from sp_AddNote
**Change History:
*/

 /* insert a new record */
INSERT INTO Daily_Account_Contacted(AccountID, CreatedDate)VALUES(@AccountID, GETDATE())

RETURN @@Error

GO
