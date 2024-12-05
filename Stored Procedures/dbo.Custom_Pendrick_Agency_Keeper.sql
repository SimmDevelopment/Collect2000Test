SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 10/30/2023
-- Description:	Export Return File to Pendrick
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Pendrick_Agency_Keeper]
	-- Add the parameters for the stored procedure here


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT
     m.id1 AS Debtor_Number
	FROM master m WITH (NOLOCK) 
	WHERE m.customer IN ('0003099') AND status IN ('hot', 'pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'bkn', 'clm')

	--UNION ALL

	--SELECT
	-- m.id1 AS [Debtor_Number]
 --  , m.current0 AS [Account_Balance]
 --  , m.status  AS [Agency_Status]
 --  , m.lastpaid AS [Date_of_Last_Payment]
 --  , m.lastpaidamt AS [Amount_of_Last_Payment]
	--FROM master m WITH (NOLOCK) inner join debtors d with(nolock) on m.number = d.Number
	--WHERE m.customer = '0003099'
	--	  --AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
	--	  --AND status NOT IN ('PIF')

END
GO
