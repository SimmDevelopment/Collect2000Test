SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
SELECT top 1 *
FROM dbo.CustomPhoneCallsView WITH (NOLOCK)
WHERE phonenumber = '7858243226'
order by phonetype
*/

/****** Object:  View dbo.PayhistoryView    Script Date: 10/13/2002 8:40:41 PM ******/
create VIEW [dbo].[Braxtel_ContactQ_CustomPhoneCallsView]
AS
		SELECT pm.phonenumber, d.SSN, CASE WHEN pt.PhoneTypeMapping > 2 THEN 3 ELSE pt.phonetypemapping END AS PhoneType,
		CASE WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 24) THEN 1 
		WHEN d.state = 'NY' AND d.Zipcode IN (SELECT z.ZipCode FROM dbo.Custom_NYC_Zipcodes z WITH (NOLOCK)) THEN 2 
		WHEN d.STATE = 'MA' AND m.customer <> '0001219' THEN 2  else 99 end AS MaxCalls,
		CASE WHEN d.state =  'MA' AND pt.PhoneTypeMapping <> 1 THEN ISNULL((select COUNT(*)
					from notes n with (Nolock) inner join master ma with (Nolock) on n.number = ma.number
					where ma.state = 'MA' and closed is null and (n.action in (select code from dbo.action with (nolock) where WasAttempt = 1) 
					OR n.action = ('DIAL')) and datediff(day, dbo.date(created), dbo.date(getdate())) <= 7 and n.action <> 'DT'
					AND ma.number = m.number
					), 0) WHEN d.state = 'MA' AND pt.PhoneTypeMapping = 1 THEN ISNULL((select COUNT(*)
					from notes n with (Nolock) inner join master ma with (Nolock) on n.number = ma.number
					where ma.state = 'MA' and closed is null and ((n.action in (select code from dbo.action with (nolock) where WasAttempt = 1) 
					OR n.action = ('DIAL')) or n.result = 'TTD') and datediff(day, dbo.date(created), dbo.date(getdate())) <= 30 and action in ('TE')
					AND ma.number = m.number
					), 0) WHEN d.state = 'NYC' THEN ISNULL((select COUNT(*)
					from notes n with (Nolock) inner join master ma with (Nolock) on n.number = ma.number
					where ma.state = 'NY' AND m.Zipcode IN (SELECT ZipCode FROM dbo.Custom_NYC_Zipcodes WITH (NOLOCK)) 
					and closed is null and (n.action in (select code from dbo.action with (nolock) where WasAttempt = 1) 
					OR n.action = ('DIAL')) and datediff(day, dbo.date(created), dbo.date(getdate())) <= 7 and n.action <> 'DT'
					AND ma.number = m.number
					), 0) ELSE 0 END AS CurrentCalls
		FROM dbo.Phones_Master pm WITH (NOLOCK) INNER JOIN master m ON pm.number = m.Number
		INNER JOIN dbo.Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
		INNER JOIN debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID AND d.seq = 0
		WHERE m.closed IS NULL AND (pm.PhoneStatusID = 2 OR pm.PhoneStatusID IS NULL)
		



GO
