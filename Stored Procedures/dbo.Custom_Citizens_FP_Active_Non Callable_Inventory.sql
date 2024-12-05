SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Active_Non Callable_Inventory] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT number AS [Lat#],account AS [Citizens Account#],name AS [Debtor Name], current0 AS [Balance],status as [Current Status],contacted as [Last Contact Date]
From master with (nolock)
WHERE customer IN ('0002226')AND status in ('CAD','CND','DSP','DIS','FRD','HLD','LCP','MHD','NHD','PPA','UBA','UBD','UBF','UBI','UBK','UHD','WHD','WHL')
		
END
GO
