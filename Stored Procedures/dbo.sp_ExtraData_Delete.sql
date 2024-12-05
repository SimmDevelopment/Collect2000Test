SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_ExtraData_Delete*/
CREATE Procedure [dbo].[sp_ExtraData_Delete]
@Number INT,
@ExtraCode varchar(2)
AS

DELETE FROM extradata
WHERE Number = @Number AND ExtraCode = @ExtraCode

GO
