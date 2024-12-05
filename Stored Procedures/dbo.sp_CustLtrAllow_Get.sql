SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustLtrAllow_Get*/
CREATE Procedure [dbo].[sp_CustLtrAllow_Get]
	@CustomerCode varchar(7)
AS

SELECT *
FROM CustLtrAllow
WHERE CustCode = @CustomerCode

GO
