SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizUpdControl] 
@TotalRead integer, 
@FirstDebtor integer output
AS
--
--	Updates the last  debtor number in the control file
--
begin transaction
select @firstdebtor = nextdebtor from controlfile

update controlfile 
set nextdebtor = nextdebtor + @totalread 
if @@error <> 0
    begin
	rollback transaction
	return
    end 
commit transaction













GO
