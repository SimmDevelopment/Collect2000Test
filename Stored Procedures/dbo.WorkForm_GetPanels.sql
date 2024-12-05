SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkForm_GetPanels] @UserID INTEGER = 0
AS
SET NOCOUNT ON;

SELECT [UID], [Name], [TypeName], [ControlData]
FROM [dbo].[WorkForm_Panels]
WHERE [Enabled] = 1
ORDER BY [Name] ASC;

RETURN 0;

GO
