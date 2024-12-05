SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CreditOne_Bankruptcy]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select right(m.account, 6) as [Acct], m.name as [Name], b.casenumber as [Case], da.name as [AttyName], da.phone as [AttyPhone], b.chapter as [Chapter]
from bankruptcy b with (nolock) inner join master m with (nolock) on b.accountid = m.number inner join debtorattorneys da with (nolock) on m.number = da.accountid
where m.customer = '0001038'

END
GO
