SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SystemMonth]

AS
BEGIN

	Select distinct Case When Len(ph.systemMonth) = 1 then '0' + Convert(varchar, ph.systemMonth)
						 Else Convert(varchar,ph.SystemMonth) End as SystemMonth
	From Payhistory ph with (nolock)
	Order by SystemMonth
	
END

GO
