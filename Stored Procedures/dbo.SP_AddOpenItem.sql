SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*SP_AddOpenItem*/
CREATE PROCEDURE [dbo].[SP_AddOpenItem] 
	@Invoice int,
	@InvoiceDate DateTime,
	@Cust varchar (7),
	@AmtDue money,
	@ReturnSts int output	

AS
 /*
**Name		:sp_AddOpenItem		
**Function	:Adds a record to the OpenItem Table
**Creation	:7/2/2001
**Used by 	:C2KFIN.dll		
**Change History:11/15/2003 mr changed the TDate value from GetDate() to cast(Convert(varchar, GetDate(), 107)as datetime)
**		:2/17/2004  mr added the InvoiceDate parameter instead of using GetDate() for version 4.0.21
*/

	Declare @SyYear int
	Declare @SyMonth int

	SELECT @SyYear=CurrentYear, @SyMonth=CurrentMonth FROM ControlFile

	/*Need to Check for NULLs from the statement above */

	INSERT INTO OpenItem (Invoice, TDate, SyYear, SyMonth, Customer, Amount)
	VALUES (@Invoice, cast(CONVERT(varchar, @InvoiceDate, 107)as datetime), @SyYear, @SyMonth, @Cust, @AmtDue)

	IF (@@error = 0) BEGIN
		set @ReturnSts = 1
	END
	ELSE BEGIN
		set @ReturnSts = 0
	END
GO
