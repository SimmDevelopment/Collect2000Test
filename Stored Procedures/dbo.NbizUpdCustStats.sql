SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizUpdCustStats] 
@customer varchar(7),
@NumPlaced  integer,
@AmtPlaced money
AS
--
--	Update the customer stats using customer number and date received
--
begin transaction
update customer
set mtdnumberplaced = mtdnumberplaced + @numPlaced, mtddollarsplaced=mtddollarsplaced+@amtplaced,
ytdnumberplaced = ytdnumberplaced + @numPlaced, ytddollarsplaced=ytddollarsplaced+@amtplaced
where customer = @customer
if @@error <> 0
    begin
	rollback transaction
	return
   end 
commit transaction









GO
