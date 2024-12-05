SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CreditOne_Deceased]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select right(m.account, 6) as Acct, m.name as Name, d.dod as DOD, d.executor as Executor, d.executorphone as ExecutorPhone
from deceased d with (nolock) inner join master m with (Nolock) on d.accountid = m.number
where m.customer = '0001038'
END
GO
