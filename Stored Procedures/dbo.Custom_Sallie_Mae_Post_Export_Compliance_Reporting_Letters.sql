SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Post_Export_Compliance_Reporting_Letters]
	-- Add the parameters for the stored procedure here
@productionDate AS DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT L.type AS [Letter Type], D.Name AS Customer, FORMAT(lr.DateProcessed, 'HH:mm:ss tt') AS [Time Stamp], D.ssn AS SSN, FORMAT(lr.DateProcessed, 'MM/dd/yyyy') AS [Date], D.Street1 + ' ' + D.City + ', ' + D.State + ' ' + D.Zipcode AS Address, 
m.account AS [SMB -Account Number], m.status AS [Account Status]
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN letter l	WITH (NOLOCK) ON lr.LetterCode = l.code INNER JOIN debtors d WITH (NOLOCK) ON lr.RecipientDebtorID = d.DebtorID
INNER JOIN master m WITH (NOLOCK) ON lr.AccountID = m.number
WHERE lr.CustomerCode = '0002877' AND CAST(lr.DateProcessed AS DATE) = @productionDate
END
GO
