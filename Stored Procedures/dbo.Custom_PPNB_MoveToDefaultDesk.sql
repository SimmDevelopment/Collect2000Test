SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/20/2021
-- Description:	moves from hold desk to default desk after 3 day hold period
-- =============================================
CREATE PROCEDURE [dbo].[Custom_PPNB_MoveToDefaultDesk]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @number int
declare @desk varchar(30)
declare @newdesk varchar(30)
declare @P1 varchar(10)
declare @date varchar(30)
declare @comment varchar(255)
declare @status varchar(5)
declare @qlevel varchar(3)

DECLARE @newStatus VARCHAR(5)

set @P1='00000'
--set @newdesk = '008'

declare cur cursor for

	--Get the accounts to move 15362174
	SELECT number, desk, status, qlevel, '0000000'
FROM master M WITH (NOLOCK) 
WHERE customer = '0002337' AND desk = 'PPNBHLD50'
AND DATEDIFF(dd, (SELECT TOP 1 CAST(thedata AS DATE) FROM MiscExtra me WITH (NOLOCK) WHERE m.number = number AND title = 'acc.0.Agency_Date_Sent'), GETDATE()) >= 2

	
open cur


fetch from cur into @number, @desk, @status, @qlevel, @newdesk
while @@fetch_status = 0 begin

set @date = dbo.makeqdate(getdate())
	
	--change the desk
	exec spDeskChange @number, @newdesk, @qlevel, @date, @P1 output, 'SYSTEM'

	set @date = convert(varchar, getdate(), 9)
	set @comment = 'Desk Changed from ' + @desk + ' to ' + @newdesk
	
	--enter note that the desk was changed
	exec spNote_AddV5 @number, @date, 'SYSTEM', 'DESK', 'CHNG', @comment, 0, 0

	fetch from cur into @number, @desk, @status, @qlevel, @newdesk

end

close cur
deallocate cur

END
GO
