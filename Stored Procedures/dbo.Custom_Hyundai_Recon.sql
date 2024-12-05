SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_Recon]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select m.account as [HCA Account #], d.Name as [Customer Name], m.received as [Placement Date], (m.current1 + m.current2 + m.current3 + m.current4) AS [Current Balance], '' AS [HCA Comments]
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where customer in (select customerid from fact with (nolock) where customgroupid = 135)
and closed is null and returned is null

END
GO
