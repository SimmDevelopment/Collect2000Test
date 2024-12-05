SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_MiscExtra_GetByID*/
CREATE Procedure [dbo].[sp_MiscExtra_GetByID]
--@MiscExtraID INT
AS

SELECT *
FROM MiscExtra
--WHERE MiscExtraID = @MiscExtraID

--PROC NOT USED--

GO
