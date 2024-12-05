SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizAddCustomerNotes] AS
--
--	Adds records to CustomerNotes table from NBCustomerNotes
--
begin transaction
insert CustomerNotes 
select * from nbCustomerNotes
if @@error <> 0
    begin
	rollback transaction
	return
    end 
commit transaction









GO
