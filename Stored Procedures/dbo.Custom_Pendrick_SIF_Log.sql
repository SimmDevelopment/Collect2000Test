SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 10/30/2023
-- Description:	Export Return File to Pendrick
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Pendrick_SIF_Log]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
    @endDate DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT
     m.id1 AS [Unique_Account_Id]
   , m.account AS [Client_Account_Number]
   , 'TEST01' AS [Client_Code]
   , REPLACE(CONVERT(VARCHAR(10), m.closed, 112),'/','') AS [Date_of_Settlement_Payment]
   , m.lastpaidamt AS [Amount_of_Last_Settlement_Payment]
   , abs(m.paid1 + m.paid2) as [Total_Payments_Collected]
	FROM master m WITH (NOLOCK) 
	WHERE m.customer IN ('0003099')
	AND status IN ('SIF')
	and dbo.date(closed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
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
