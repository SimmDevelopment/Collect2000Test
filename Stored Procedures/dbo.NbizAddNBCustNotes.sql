SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizAddNBCustNotes]
@cliref varchar(30),
@seq int,
@notedate smalldatetime,
@notetext char(255) 
AS
--
--	Adds Customer notes to NBCustomer from client file
--
declare @dnumber int
select @dnumber = number from nbmaster where account = @cliref
Insert NBCustomerNotes (Number, seq, Notedate,Notetext)
		Values 	(@dNumber, @seq, @Notedate,@notetext)

if @@error <> 0
    begin
    	rollback transaction
    	return
    end 
	












GO
