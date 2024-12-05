SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizUpdStairStep]
@Customer varchar(7),
@SSYear varchar(4), 
@SSMonth varchar(2),
@NumPlaced integer,
@AmtPlaced money
AS
--
--	Updates the Stairstep using Customer, date received year and month, number placed and amount placed.
--
begin transaction
if exists
    (select customer,ssyear,ssmonth,numberplaced,grossdollarsplaced,netdollarsplaced from stairstep 
	where customer = @customer and ssyear = @ssyear and ssmonth = @ssmonth)
    begin
	update stairstep
		set numberplaced = numberplaced + @numplaced, 
		      grossdollarsplaced = grossdollarsplaced + @AmtPlaced,
		      netdollarsplaced = netdollarsplaced + @amtplaced
	where customer = @customer and ssyear = @ssyear and ssmonth = @ssmonth
    end 
else
    begin
 	insert stairstep (customer,ssyear,ssmonth,numberplaced,grossdollarsplaced,netdollarsplaced )
	values (@customer,@ssyear,@ssmonth,@numplaced,@amtplaced,@amtplaced)
    end
if @@error <> 0
    begin
	rollback transaction
	return
    end
Commit transaction











GO
