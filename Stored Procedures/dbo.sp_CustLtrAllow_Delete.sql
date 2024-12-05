SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_CustLtrAllow_Delete*/
CREATE Procedure [dbo].[sp_CustLtrAllow_Delete]
@CustCode varchar(7),
@LtrCode varchar(5)
AS

DELETE FROM CustLtrAllow
WHERE CustCode = @CustCode AND LtrCode = @LtrCode

GO
