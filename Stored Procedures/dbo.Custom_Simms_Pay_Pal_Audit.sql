SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--AGYAUDIT.UL
/*
declare @customer varchar(8000)

set @customer='0000905|'
exec Custom_Simms_First_Audit @customer=@customer
*/
CREATE    PROCEDURE [dbo].[Custom_Simms_Pay_Pal_Audit]
	 @customer varchar(8000)
AS
BEGIN

	SELECT DISTINCT--Audit Header Record
		'*' AS [RecordCode],
		m.customer AS [Customer],
		--(select m.customer FROM master m with (nolock) RIGHT JOIN @tmpcms_audit t ON m.number=t.number) AS [Customer],
		CASE m.customer WHEN '0001220' THEN 'SIMMDC' 
			WHEN '0001256' THEN 'SIMPRI'
			WHEN '0001257' THEN 'SIMTER'
			WHEN '0001258' THEN 'SIMBKP'
			END AS [AgencyCode],
			
		 'SIMM Associates' AS [AgencyName],
		--Filler--
		count(m.number) AS [NumAccounts],--(select count(distinct t.number) from @tmpcms_audit t JOIN master m2 with (nolock) ON m2.number=t.number WHERE m2.customer=m.customer) AS [NumAccounts],
		getdate() as [Date],
		SUM(m.current1 + current2) AS [TotalBalance]--(select SUM(m2.current0) FROM master m2 with (nolock) JOIN @tmpcms_audit t ON m2.Number=t.number WHERE m2.customer=m.customer) AS [TotalBalance]

	FROM (select string as customer from dbo.CustomStringToSet(@customer, '|')) ic
	inner join master m with (nolock) on m.customer = ic.customer
	WHERE m.status in (select code from status where statustype like '%ACTIVE%')
	AND m.returned is null
	GROUP BY m.customer


	SELECT
		m.account AS [Account],
		m.Name AS [Name],
		m.SSN AS [SSN],
		m.current1 + current2 AS [Balance],
		m.Street1 AS [Street1],
		m.Street2 AS [Street2],
		m.homephone AS [Phone],
		m.city AS [City],
		m.state AS [State],
		m.zipcode AS [Zipcode]
		--Fill 13
	FROM (select string as customer from dbo.CustomStringToSet(@customer, '|')) ic
	inner join master m with (nolock) on m.customer = ic.customer
	WHERE m.status in (select code from status where statustype like '%ACTIVE%')
	AND m.returned is null
	

END
GO
