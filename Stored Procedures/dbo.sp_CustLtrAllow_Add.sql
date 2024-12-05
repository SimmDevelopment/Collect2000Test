SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_CustLtrAllow_Add*/
CREATE   Procedure [dbo].[sp_CustLtrAllow_Add]
@CustCode varchar(7),
@LtrCode varchar(5),
@CopyCustomer bit,
@SaveImage bit
AS

IF EXISTS (SELECT * FROM CustLtrAllow WHERE CustCode = @CustCode AND LtrCode = @LtrCode) 
	UPDATE CustLtrAllow
	SET CopyCustomer = @CopyCustomer,
		SaveImage = @SaveImage
	WHERE CustCode = @CustCode
	AND LtrCode = @LtrCode;
ELSE
	INSERT INTO CustLtrAllow
	(
	CustCode,
	LtrCode,
	CopyCustomer,
	SaveImage
	)
	VALUES
	(
	@CustCode,
	@LtrCode,
	@CopyCustomer,
	@SaveImage
	);
GO
