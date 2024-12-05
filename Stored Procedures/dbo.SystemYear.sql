SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SystemYear]

AS
BEGIN

	Select distinct Convert(varchar, ph.SystemYear) as SystemYear
	From Payhistory ph with (nolock)
	Order by systemyear
	
END

GO
