SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CrescentBank_Remittance]  
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS Account, CONVERT(VARCHAR(10), p.datepaid, 101) AS [PaymentDate], 
	CASE batchtype WHEN 'pur' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) WHEN 'PU' then (p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE 0.00 END AS [AmountofPayment],
	CASE batchtype WHEN 'PCR' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) WHEN 'PC' then (p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE 0.00 END AS [DirectPayment] ,
    CASE WHEN batchtype LIKE '%r' THEN -p.CollectorFee ELSE p.CollectorFee END AS [CommisionAmount],
	CASE WHEN batchtype LIKE '%r' THEN -((p.paid1 + p.paid2 + p.paid3 + p.paid4) - p.CollectorFee) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4) - p.CollectorFee END AS [NetAmount],
	m.current1 + m.current2 + m.current3 + m.current4 + m.current5 + m.current6 + m.current7 + m.current8 + m.current9 AS [RemainingBalance], CASE batchtype WHEN 'PU' then 'PU' when 'PUR' then 'PUR' when 'PC' then 'PC' when 'PCR' then 'PCR' end AS [Status]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number INNER JOIN dbo.FeeScheduleDetails f WITH (NOLOCK) ON p.FeeSched = f.Code
WHERE p.Invoice IN (select string from dbo.CustomStringToSet(@invoice,'|') ) AND (p.paid1 + p.paid2 + p.paid3 + p.paid4) > 0
END

GO
