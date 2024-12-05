SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_UpdateSS1]      /*Updates part of the StairStep record...The part that comes form master table  */
	@FileNumber int

 AS

Declare @Customer varchar(8)
Declare @SysMonth tinyint
Declare @SysYear smallint
Declare @Original money
Declare @Paid money
Declare @Rcvd datetime

	SELECT @Customer=Customer, @Original=Original, @Paid=Paid, @Rcvd=Received FROM master where number = @FileNumber	

	SET @SysMonth = datepart(m, @Rcvd)
	SET @SysYear = datepart(y, @Rcvd)

	UPDATE StairStep set NumberPlaced = NumberPlaced + 1, GrossDollarsPlaced = GrossDollarsPlaced + @Original, GTCollections = GTCollections + @Paid
	WHERE Customer =@Customer and SSMonth =@SysMonth and SSYear = @SysYear
GO
