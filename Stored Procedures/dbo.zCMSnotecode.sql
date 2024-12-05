SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO



CREATE PROCEDURE [dbo].[zCMSnotecode]



	
@customer varchar(8000)

as

BEGIN
SET NOCOUNT ON;
	set ansi_warnings off;

			Declare @theCustomers Table (
				[ID] [int] IDENTITY(1,1) NOT NULL,
				Customer varchar(7)
			)
			
			Insert into @theCustomers(customer)
			Select string from dbo.CustomStringToSet(@customer,'|')

			DECLARE @tmpcms_count TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL)

			INSERT INTO @tmpcms_count (number)
			SELECT DISTINCT AccountID from AddressHistory a with (nolock)
			JOIN master m with (nolock)
			ON m.Number=a.AccountId
			WHERE a.DateChanged is not null
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

			INSERT INTO @tmpcms_count (number)
			SELECT DISTINCT AccountID from PhoneHistory p with (nolock)
			JOIN master m with (nolock)
			ON m.Number=p.AccountId
			WHERE p.DateChanged is not null
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

			DECLARE @tmpcms_close TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)


			INSERT INTO @tmpcms_close (number,amount)
			SELECT m.number,(select sum(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) from payhistory p with(nolock) where p.number = m.number)
			FROM master m with(nolock)
			WHERE m.status = 'SIF'
			and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
			GROUP BY m.number,m.current0

DECLARE @tmpcms TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL
)

INSERT INTO @tmpcms (number)
	SELECT DISTINCT AccountID from AddressHistory a
	JOIN master m with (nolock)
	ON m.Number=a.AccountId
	WHERE a.DateChanged is not null
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

insert into @tmpcms (number)
	SELECT DISTINCT AccountID from PhoneHistory p
	JOIN master m with (nolock)
	ON m.Number=p.AccountId
	WHERE p.DateChanged is not null
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


SELECT DISTINCT --Header Record
	--RecordCode
	--Filler
	getdate() AS [Date],
	--Type=1
	--SourceCode=1
	m.customer,
	case 
		when m.customer='0000511' then 'AL0125'
		when m.customer='0000627' then 'AL0204'
		when m.customer='0000591' then 'AL0171'
		when m.customer='0000619' then 'AL0200'
		when m.customer='0000633' then 'AL0217'
		when m.customer='0000676' then 'AL0283'
		when m.customer='0000644' then 'AL0225'
		when m.customer='0000677' then 'AL0284'
		when m.customer='0000896' then 'AL0349'
		when m.customer='0000905' then 'AL0401'
		else ''
	end AS [AgencyCode],
	case
		when m.customer='0000511' then 'SIMM Associates Inc.'
		when m.customer='0000627' then 'SIMM Associates Inc.'
		when m.customer='0000591' then 'SIMM Associates Inc.'
		when m.customer='0000619' then 'SIMM Associates Inc.'
		when m.customer='0000633' then 'SIMM Associates Inc.'
		when m.customer='0000676' then 'SIMM Associates Inc.'
		when m.customer='0000644' then 'SIMM Associates Inc.'
		when m.customer='0000677' then 'SIMM Associates Inc.'
		when m.customer='0000896' then 'SIMM Associates Inc.'
		when m.customer='0000905' then 'SIMM Associates Inc.'
		else ''
	end AS [AgencyName],
	--Rec1
	'0' AS [NumRec1],
	'0' AS [TotalPay],
	--Rec2
	'0' AS [NumRec2],
	'0' AS [TotalCost],
	--Rec3
	'0' AS [NumRec3],
	--Rec4
	(	select count(m.number) 
		FROM @tmpcms_close t
		LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
		WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND m.status = 'SIF'
	)
		AS [NumRec4],
	--Rec5
	(
		select count(distinct m2.number) 
		FROM @tmpcms_count t 
		JOIN master m2 with (nolock) ON m2.Number=t.Number 
		left JOIN CourtCases c with (nolock) ON m2.Number=c.AccountID 
		left JOIN Courts ct with (nolock) ON c.CourtID=ct.CourtID
		where m2.customer=m.customer 
	)
		AS [NumRec5],
	--Filler
	case
		when m.customer='0000511' then '05242'
		when m.customer='0000627' then '05242'
		when m.customer='0000591' then '06070'
		when m.customer='0000619' then '06070'
		when m.customer='0000633' then '06070'
		when m.customer='0000676' then '06070'
		when m.customer='0000644' then '06488'
		when m.customer='0000677' then '06488'
		when m.customer='0000896' then '06112'
		when m.customer='0000905' then '05625'
	end AS [BankID]
	--Fills
FROM master m with (nolock)
left outer JOIN @tmpcms_count t ON m.number=t.number
left outer join @tmpcms t2 ON t2.number = m.number
left outer join @tmpcms_close t3 ON t3.number = m.number
where m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.customer is not null

(
SELECT 
	'4' AS [RecordCode],
	m.closed as [Date],--n.created as [Date],
	case 
		when m.status like 'B%' then 'BUN'
		when m.status='DEC' AND exists(select DOD from Deceased with (nolock) where AccountId=m.number) then 'DEC'
		when m.status='DEC' then 'DUN'
		when m.status='CAD' then 'DNC'
		when m.status='CCC' then 'PCC'
		when m.status='SIF' then 'SIF'
		when m.status='PIF' then 'PIF'
		ELSE ''
	END AS [NoteCode],--outgoing note code
	
	'' AS [Narrative1],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]

FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
AND m.returned is null and m.qlevel = '998'
)
union all
(SELECT 
	'4' AS [RecordCode],
	(m.closed + 30) as [Date],--n.created as [Date],
	case 
		when m.status like 'B%' then 'BKY'
		when m.status='DEC' AND exists(select DOD from Deceased with (nolock) where AccountId=m.number) then 'DEC'
		when m.status='DEC' then 'DUN'
		when m.status='CAD' then 'DNC'
		when m.status='CCC' then 'PCC'
		when m.status='SIF' then 'SIF'
		when m.status='PIF' then 'PIF'
		ELSE 'PTP'
	END AS [NoteCode],--outgoing note code
	CASE 	WHEN m.status = 'PIF' THEN 'PAID IN FULL RECEIVED'
		WHEN m.status = 'SIF' THEN ('BAL AT TIME OF SIF: '+
				rtrim(ltrim(cast(str((isnull(t.amount,0) + m.current0),9,0) as varchar(11))))+
				' SIF%: '+
				rtrim(ltrim(cast(str((100*((isnull(t.amount,0))/(isnull(t.amount,0) + m.current0))),9,0) as varchar(11))))+
				' SIF TOTAL: '+
				rtrim(ltrim(cast(str(isnull(t.amount,0),9,0) as varchar(11))))+
				' BAL AFTER SIFF: '+
				rtrim(ltrim(cast(str(m.current0,9,0) as varchar(11)))))
		ELSE ''
	END AS [Narrative1],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
WHERE m.status = 'SIF'
)

END
GO
