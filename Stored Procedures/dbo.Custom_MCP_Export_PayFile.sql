SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_MCP_Export_PayFile]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
SELECT TOP 100    DebtorCreditCards.ID, DebtorCreditCards.IsActive AS Active, Master.number AS [Account ID], Master.account AS [Original Account Number], DebtorCreditCards.Name, DebtorCreditCards.Street1, 
                      DebtorCreditCards.Street2, DebtorCreditCards.City, DebtorCreditCards.State, DebtorCreditCards.Zipcode, Master.desk, Master.Branch, DebtorCreditCards.Name AS CreditCardName, 
                      DebtorCreditCards.Code AS SecurityCode, DebtorCreditCards.PrintedDate AS [Printed Date], CAST(DebtorCreditCards.Surcharge AS decimal(9, 2)) AS Surcharge, DebtorCreditCards.NSFCount, 
                      '' AS Cleared, CONVERT(datetime, DebtorCreditCards.DepositDate, 101) AS [Payment Date], 'CREDIT CARD' AS [Pay Method], 
                      CAST(DebtorCreditCards.Amount + DebtorCreditCards.Surcharge AS decimal(9, 2)) AS Amount, CASE WHEN [DebtorCreditCards].[onholddate] IS NULL THEN CAST(0 AS bit) ELSE CAST(1 AS bit) 
                      END AS [On Hold], CreditCardTypes.DESCRIPTION, DebtorCreditCards.CardNumber AS [Check / Card Number], LTRIM(RTRIM(DebtorCreditCards.CardNumber)) AS CheckCardNumber, 
                      DebtorCreditCards.EXPMonth + DebtorCreditCards.EXPYear AS expdate, CASE WHEN [DebtorCreditCards].[approvedby] IS NOT NULL AND [DebtorCreditCards].[Printed] IN ('0', 'N') 
                      THEN 'Approved' WHEN [DebtorCreditCards].[approvedby] IS NOT NULL AND [DebtorCreditCards].[Printed] IN ('1', 'Y') THEN 'Printed' WHEN [DebtorCreditCards].[approvedby] IS NULL 
                      THEN 'Unapproved' END AS Status, Master.customer
FROM         dbo.DebtorCreditCards AS DebtorCreditCards WITH (NOLOCK) INNER JOIN
                      dbo.master AS Master WITH (NOLOCK) ON Master.number = DebtorCreditCards.Number AND DebtorCreditCards.IsActive = 1 INNER JOIN
                      dbo.CreditCardTypes AS CreditCardTypes WITH (NOLOCK) ON CreditCardTypes.Code = DebtorCreditCards.CreditCard
END
GO
