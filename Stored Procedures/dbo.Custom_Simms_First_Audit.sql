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
CREATE    PROCEDURE [dbo].[Custom_Simms_First_Audit]
	 @customer varchar(8000)
AS
BEGIN

	SELECT DISTINCT--Audit Header Record
		'*' AS [RecordCode],
		m.customer AS [Customer],
		--(select m.customer FROM master m with (nolock) RIGHT JOIN @tmpcms_audit t ON m.number=t.number) AS [Customer],
		case 
			when m.customer='0000511' then 'al0125'
			when m.customer='0000627' then 'al0204'
			when m.customer='0000591' then 'al0171'
			when m.customer='0000619' then 'al0200'
			when m.customer='0000633' then 'al0217'
			when m.customer='0000676' then 'al0283'
			when m.customer='0000644' then 'al0225'
			when m.customer='0000677' then 'al0284'
			when m.customer='0000896' then 'al0349'
			when m.customer='0000905' then 'SIM'
	--		when m.customer='0000001' then 'latitude'
			else ''
		end AS [AgencyCode],
		case
			when m.customer='0000511' then 'Merr Primes'
			when m.customer='0000627' then 'Merr Tert'
			when m.customer='0000591' then 'Prov Primes'
			when m.customer='0000619' then 'Prov Decsd'
			when m.customer='0000633' then 'Prov Sec'
			when m.customer='0000676' then 'Prov Quads'
			when m.customer='0000644' then 'FCNB Primes'
			when m.customer='0000677' then 'FCNB Seconds'
			when m.customer='0000896' then ''
			when m.customer='0000950' then ''
	--		when m.customer='0000001' then 'xml'
			else ''
		end AS [AgencyName],
		--Filler--
		count(m.number) AS [NumAccounts],--(select count(distinct t.number) from @tmpcms_audit t JOIN master m2 with (nolock) ON m2.number=t.number WHERE m2.customer=m.customer) AS [NumAccounts],
		getdate() as [Date],
		SUM(m.current0) AS [TotalBalance]--(select SUM(m2.current0) FROM master m2 with (nolock) JOIN @tmpcms_audit t ON m2.Number=t.number WHERE m2.customer=m.customer) AS [TotalBalance]

	FROM (select string as customer from dbo.CustomStringToSet(@customer, '|')) ic
	inner join master m with (nolock) on m.customer = ic.customer
	WHERE m.status in (select code from status where statustype like '%ACTIVE%')
	AND m.returned is null
	GROUP BY m.customer


	SELECT
		m.account AS [Account],
		m.Name AS [Name],
		m.SSN AS [SSN],
		m.current0 AS [Balance],
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
