SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan, Simm Associates
-- Create date: 10/28/2008
-- Description:	Post account import process to update information that conflicted with how exchange runs.  Most could be obsolete after 8.5
-- added code to change to WRT status if not ended in WRT table
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Resurgent_Post_Import_NewBiz]
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

--Update Status and desk for accounts placed with existing Work Restrictions


-- Previous creditor is updated, here due to mapping was not available in previous exchange clients.  Can probably now be mapped in exchange.
--update master
--set previouscreditor = (select TOP 1 thedata from miscextra with (nolock) where number = m.number and title = 'ADL.0.Org Name')
--from master m with (nolock)
--where number = @number

--Removed courtcases so accounts wouldn't fall into judgement for recent payers customers
DELETE 
FROM CourtCases 
WHERE AccountID IN (SELECT number FROM master m WITH (NOLOCK) WHERE number = @number AND customer IN ('0001029', '0001186'))

--Loads resurgent's supplied date of death on probate accounts to avoid duplicate scrub hits.
insert into deceased(accountid, debtorid, ssn, firstname, lastname, state, postalcode, dob, dod) 
select m.number, d.debtorid, d.ssn, d.firstname, SUBSTRING(d.lastname, 1, 30), d.state, d.zipcode, d.dob, (select top 1 thedata from miscextra with (nolock) where number = m.number and title = 'dec.0.date of death')
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where m.number = @number and ((select top 1 thedata from miscextra with (nolock) where number = m.number and title = 'dec.0.date of death') is not null and (select top 1 thedata from miscextra with (nolock) where number = m.number and title = 'dec.0.date of death') <> '')
 and d.debtorid not in (select debtorid from deceased with (nolock))
 AND customer IN (SELECT customer FROM customer WITH (NOLOCK) WHERE cob LIKE '%prob%')

 --Change Status to WRT when a WRT record is sent with no End Date
 --Setup Variables
 DECLARE @oldStatus AS VARCHAR(5)

	 IF EXISTS(SELECT number
	 FROM master m WITH (NOLOCK)
	 WHERE number = @number AND id1 IN (SELECT acctid FROM Custom_Resurgent_WRT_History crwh WITH (NOLOCK) WHERE crwh.AcctID = m.id1 AND crwh.EndDate = ''))

		 BEGIN
			--Get variables
			SELECT @oldStatus = m.status
			FROM master m WITH (NOLOCK)
			WHERE number = @number AND id1 IN (SELECT acctid FROM Custom_Resurgent_WRT_History crwh WITH (NOLOCK) WHERE crwh.AcctID = m.id1 AND crwh.EndDate = '')


			--Update Status
			UPDATE master
			SET status = 'WRT'
			WHERE number = @number 

			INSERT INTO statushistory(accountid, datechanged, username, oldstatus, newstatus)
			VALUES (@number, GETDATE(), 'SYSTEM', @oldStatus, 'WRT')
							
			--Insert note for status change
			INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
			SELECT @number, GETDATE(), 'EXG', '+++++', '+++++', 'Status Changed | ' + @oldStatus + ' | WRT'
		END	

END
GO
