SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_MiscExtra_Get*/
CREATE Procedure [dbo].[sp_MiscExtra_Get]
	@KeyID int
AS

SELECT *
FROM MiscExtra
--WHERE /*no key selected*/ = @KeyID

GO
