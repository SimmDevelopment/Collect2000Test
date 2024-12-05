SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizGetDebtorNumber] 
 @firstnumber int 
AS
update nbmaster
 	set number = number + @firstnumber
update nbextradata
	set number = number + @firstnumber
update nbcustomernotes
	set number = number + @firstnumber
update nbhardcopy
	set number = number + @firstnumber











GO
