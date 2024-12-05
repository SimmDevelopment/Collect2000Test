SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizAddNBExtraDataCoSigner] 
@cliref varchar(30),
@ExtraCode varchar(30),
@Line1 varchar(30)=null,
@Line2 varchar(30)=null,
@Line3 varchar(30)=null,
@Line4 varchar(30)=null,@Line5 varchar(30)=null,
@ctl varchar(3) = null
as
--
--	Adds Cosigner info to NBExtraData table from client file.
--		Finds debtor number in NMMaster
--		Determines if 1st, 2nd, 3rd, etc cosigner
--		Inserts record into NBExtraData
--		Adds extracode to NBMaster.Extracode
--
declare @debtornum  int
declare @i int

Select @debtornum=number 
from nbmaster
where @cliref = account

set @i = 1
while @i  < 5
    begin
       	if  @i = 1 set @Extracode = 'C1'
      	if @i = 2 set @Extracode = 'C2'
      	if @i = 3 set @Extracode = 'C3'
       	if @i = 4 set @Extracode = 'C4'
         	if @i = 5 set @Extracode = 'C5'
      
        if not exists (select number from nbextradata where number = @debtornum and extracode = @extracode)
        begin
	Insert NBExtraData ( number,extracode, line1, line2, line3, line4, line5)
            values (@debtornum,@extracode, @line1, @line2, @line3, @line4, @line5)
	break
        end
        set @i = @i + 1      
    end

update nbmaster
	set extracodes = extracodes + @ExtraCode
	where number = @debtornum














GO
