SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO




CREATE     PROCEDURE [dbo].[Custom_SBBT_Report_GetPayments_Adjustment]
@customer varchar(8000),
@startDate datetime,
@endDate datetime
AS

/*
SELECT account, YEAR(contractdate) Year, totalpaid, comment
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
	ON p.Number = m.Number
WHERE (m.customer IN (SELECT string FROM dbo.StringToSet(@customer, '|')) 
	OR (@customer = '2005' AND YEAR(contractdate) = 2005) AND 
		m.customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 26))  
	AND batchtype = 'PU' AND entered BETWEEN @startDate AND @endDate 
*/


--Added 2006 to the query Brian Meehan 8/6/2007
--changed total paid to paid1 so fees are not included in the payment file.  BGM 9/24/2007
if @customer = '2005'

begin

	SELECT account, 'Year' =  case when m.customer in ('0000942', '0000949') then YEAR(contractdate) + 1 else YEAR(contractdate) end, (totalpaid - p.paid1) as paid1
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
		ON p.Number = m.Number
	WHERE (m.customer IN (SELECT string FROM dbo.StringToSet(@customer, '|')) 
		OR (@customer = '2005' AND YEAR(contractdate) = 2005 and m.customer <> '0000949') AND 
			m.customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 26))  
		AND batchtype = 'PU' AND entered BETWEEN @startDate AND @endDate and (totalpaid - p.paid1) > 0
union
	SELECT account, 'Year' =  case when m.customer in ('0000942', '0000949') then YEAR(contractdate) + 1 else YEAR(contractdate) end, (totalpaid - p.paid1) as paid1
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
		ON p.Number = m.Number
	WHERE (m.customer IN (SELECT string FROM dbo.StringToSet(@customer, '|')) 
		OR (m.customer = '0000942' AND YEAR(contractdate) = 2004) AND 
			m.customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 26))  
		AND batchtype = 'PU' AND entered BETWEEN @startDate AND @endDate and (totalpaid - p.paid1) > 0
end
else 
	if @customer = '2006'
begin
	SELECT account, 'Year' =  case when m.customer in ('0000942', '0000949') then YEAR(contractdate) + 1 else YEAR(contractdate) end, (totalpaid - p.paid1) as paid1
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
		ON p.Number = m.Number
	WHERE (m.customer IN (SELECT string FROM dbo.StringToSet(@customer, '|')) 
		OR (@customer = '2006' AND YEAR(contractdate) = 2006 and m.customer <> '0000942')  AND 
			m.customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 26))  
		AND batchtype = 'PU' AND entered BETWEEN @startDate AND @endDate and (totalpaid - p.paid1) > 0
union

SELECT account, 'Year' =  case when m.customer in ('0000942', '0000949') then YEAR(contractdate) + 1 else YEAR(contractdate) end, (totalpaid - p.paid1) as paid1
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
		ON p.Number = m.Number
	WHERE (m.customer IN (SELECT string FROM dbo.StringToSet(@customer, '|')) 
		OR (m.customer = '0000949' AND YEAR(contractdate) = 2005)  AND 
			m.customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 26))  
		AND batchtype = 'PU' AND entered BETWEEN @startDate AND @endDate and (totalpaid - p.paid1) > 0


end
else

	SELECT account, 'Year' =  case when m.customer in ('0000942', '0000949') then YEAR(contractdate) + 1 else YEAR(contractdate) end, (totalpaid - p.paid1) as paid1
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
		ON p.Number = m.Number
	WHERE (m.customer IN (SELECT string FROM dbo.StringToSet(@customer, '|')) 
		AND m.customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 26))  
		AND batchtype = 'PU' AND entered BETWEEN @startDate AND @endDate and (totalpaid - p.paid1) > 0
GO