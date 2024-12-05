SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 04/02/2021
-- Description:	When accounts are loaded, this will look for accounts previously placed
--				that closed while in CHD status, it will then check to see if the time
--				period has expired, if not the account will move to CHD status.
-- Changes:
--			06/23/2021 BGM Updated values to be less than equal to the amount of days instead of greater than.
--			08/24/2022 BGM Updated Values for Pays and Refusals
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Post_AccountLoad_CHDcheck]
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @P1 varchar(10)
declare @date varchar(30)
declare @comment varchar(255)
declare @oldstatus varchar(5)

DECLARE @newStatus VARCHAR(5)

set @P1='00000'
--set @newdesk = '008'

declare cur cursor for

SELECT Number, 'NEW' AS oldstatus, CASE WHEN QualifingResult IN ('LV', 'LM') AND DaysSinceHold <= 3 THEN 'CHD' WHEN QualifingResult IN ('RP') AND DaysSinceHold <= 7 THEN 'CHD'
WHEN QualifingResult IN ('PAY', 'ACHCC', 'IPAY', 'I99', 'PP') AND DaysSinceHold <= 7 THEN 'CHD'
WHEN z.QualifingResult IN ('CRNO','BK', 'DC', 'FR') AND z.DaysSinceHold <= 10 THEN 'CHD' ELSE 'NEW' END AS NewStatus
FROM (
SELECT m.number, (SELECT TOP 1 created FROM dbo.notes WITH (NOLOCK)  WHERE number = m.number AND result IN ('LM', 'LV', 'RP', 'PAY', 'ACHCC', 'IPAY', 'I99', 'PP', 'BK', 'CRNO', 'DC', 'FR') ORDER BY created DESC) AS RecentNote,
(SELECT TOP 1 result FROM dbo.notes WITH (NOLOCK)  WHERE number = m.number AND result IN ('LM', 'LV', 'RP', 'PAY', 'ACHCC', 'IPAY', 'I99', 'PP', 'BK', 'CRNO', 'DC', 'FR') ORDER BY created DESC) AS QualifingResult,
DATEDIFF(dd, (SELECT TOP 1 created FROM dbo.notes WITH (NOLOCK)  WHERE number = m.number AND result IN ('LM', 'LV', 'RP', 'PAY', 'ACHCC', 'IPAY', 'I99', 'PP', 'BK', 'CRNO', 'DC', 'FR') ORDER BY created DESC), GETDATE()) AS DaysSinceHold
--(SELECT TOP 1 oldstatus FROM dbo.StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus = 'CHD' ORDER BY DateChanged DESC) AS oldStatus
FROM dbo.master m WITH (NOLOCK) 
WHERE customer = '0002226' AND status <> 'CHD'
AND number = @number) z
WHERE CASE WHEN QualifingResult IN ('LV', 'LM') AND DaysSinceHold <= 3 THEN 1 WHEN QualifingResult IN ('RP') AND DaysSinceHold <= 7 THEN 1 
			WHEN QualifingResult IN ('PAY', 'ACHCC', 'IPAY', 'I99', 'PP') AND DaysSinceHold <= 7 THEN 1
			WHEN z.QualifingResult IN ('CRNO','BK', 'DC', 'FR') AND z.DaysSinceHold <= 10 THEN 1 ELSE 0 END = 1
	
open cur


fetch from cur into @number, @oldstatus, @newStatus
while @@fetch_status = 0 begin

set @date = dbo.makeqdate(getdate())
	
	--prepare for status change
	set @comment = 'Status has changed (Old Status = ' + @oldstatus + ')(New Status = ' + @newStatus +')'

	--change the status
	update master
	set status = @newStatus
	where number = @number

	exec statushistory_insert @number, 'SYSTEM', @oldstatus, @newStatus

	exec spNote_AddV5 @number, @date, 'SYSTEM', '+++++', '+++++', @comment, 0, 0

	fetch from cur into @number, @oldstatus, @newStatus

end

close cur
deallocate cur

END
GO
