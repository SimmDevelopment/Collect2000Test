SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizAddNBExtraData] 
@cliref varchar(30),
@ExtraCode varchar(30),
@Line1 varchar(30)=null,
@Line2 varchar(30)=null,
@Line3 varchar(30)=null,
@Line4 varchar(30)=null,@Line5 varchar(30)=null,
@ctl varchar(3) = null
as
--
--	Adds extra data info to NBExtraData table from client file.
--		Finds debtor number in NMMaster
--		Inserts record into NBExtraData
--		Adds extracode to NBMaster.Extracode
--
declare @debtornum  int

Select @debtornum=number 
from nbmaster
where @cliref = account


Insert NBExtraData (number,extracode, line1, line2, line3, line4, line5)
values (@debtornum,@extracode, @line1, @line2, @line3, @line4, @line5)

update nbmaster
	set extracodes = Ltrim(extracodes) + @ExtraCode
	where number = @debtornum
/*if @@error <> 0
    begin
	print 'Error reading Master file' + @@error + @debtornum
    	rollback transaction
    	return
    end
*/
	







































GO
