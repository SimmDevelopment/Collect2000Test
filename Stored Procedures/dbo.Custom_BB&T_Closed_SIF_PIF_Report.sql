SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 05/04/2021 BGM Added to check if original balance = to 0 then return % of balance to 1
-- =============================================
CREATE PROCEDURE [dbo].[Custom_BB&T_Closed_SIF_PIF_Report]
	-- Add the parameters for the stored procedure here
	@endDate datetime,
	@startDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.Name as [Customer Name],account AS [Client Account],m.received as [DateOfReferral], '' as [FirstPayment],m.lastpaid as [DateOfLastPay],
abs(m.paid1 + m.paid2) as [Total Paid],m.current1 as [Balance],m.original1 + m.original2 AS [BalanceAtSettlement], case when original = 0 then 1 else ABS(paid1 + paid2) / original end as [SettlePercent], 
m.status as [Status]
FROM master m WITH (NOLOCK)
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.customer IN ('0002540','0002541','0002542','0002543','0002544','0002545','0002546')
AND m.status IN ('sif','pif') AND m.closed BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


END
GO
