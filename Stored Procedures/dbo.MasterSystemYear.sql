SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[MasterSystemYear]

AS
BEGIN

	Select distinct Convert(varchar, m.SysYear) as SystemYear
	From Master m with (nolock)
	Order by SystemYear
	
END

GO
