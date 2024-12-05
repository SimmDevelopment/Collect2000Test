SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[SP_ImportExtraData]
	@BatchNumber int,
	@AcctUID int,
	@ExtraCode varchar (2),
	@Field1 varchar (30),
	@Field2 varchar (30),
	@Field3 varchar (30),
	@Field4 varchar (30),
	@Field5 varchar (30)


 AS

	Insert into ImportExtraData (BatchID, ImportAcctID, ExtraCode, Line1, Line2, Line3, Line4, Line5)
	Values (@BatchNumber, @AcctUID, @ExtraCode, @Field1, @Field2, @Field3, @Field4, @Field5)







GO
