SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustLtrAllow_Update*/
CREATE Procedure [dbo].[sp_CustLtrAllow_Update]
@CustCode varchar(7),
@LtrCode varchar(5),
@CopyCustomer bit,
@SaveImage bit
AS

UPDATE CustLtrAllow
SET
CopyCustomer = @CopyCustomer,
SaveImage = @SaveImage
WHERE CustCode = @CustCode AND LtrCode = @LtrCode

GO
