SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 12/16/2020
-- Description:	Export Union Bank Inventory for open accounts and closed accounts for the date range.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_UnionBank_Post_Inventory]
	-- Add the parameters for the stored procedure here
	@startdate DATETIME,
	@enddate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	

SELECT m.number AS [Agency Ref#], m.account AS [Account Number], m.Name, m.received AS [Placed Date], m.original AS [Placed Balance], 
m.current0 AS [Current Balance], m.lastpaid AS [Last Pay Date], s.Description AS [Status]
FROM dbo.master m WITH (NOLOCK) INNER JOIN dbo.status s WITH (NOLOCK) ON m.status = s.code
WHERE customer = '0001118' AND (closed IS NULL OR closed BETWEEN @startdate AND @enddate)	

END
GO
