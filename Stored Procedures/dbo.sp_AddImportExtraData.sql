SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_AddImportExtraData]
	@BatchID int,
	@ImportAcctID int,
	@ExtraCode varchar (2),
	@Field1 varchar (30),
	@Field2 varchar (30),
	@Field3 varchar (30),
	@Field4 varchar (30),
	@Field5 varchar (30)


 AS

	Insert into ImportExtraData (BatchID, ImportAcctID, ExtraCode, Line1, Line2, Line3, Line4, Line5)
	Values (@BatchID, @ImportAcctID, @ExtraCode, @Field1, @Field2, @Field3, @Field4, @Field5)
GO
