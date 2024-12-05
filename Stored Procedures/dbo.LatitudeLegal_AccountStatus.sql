SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[LatitudeLegal_AccountStatus]
AS


SELECT 
'Agency' as [Account Status],
count(*) as [Count],
cast(sum(current1) as decimal(15,2)) as [Current Balance]
FROM
master WITH (NOLOCK) WHERE AIMAgency is not null and AIMagency <> 0

UNION
SELECT 
attorneystatus as [Account Status],
count(*) as [Count],
cast(sum(current1) as decimal(15,2)) as [Current Balance]
FROM
master WITH (NOLOCK) WHERE attorneystatus in ('Placed','Placing','Recalling')
GROUP BY attorneystatus

UNION 
SELECT 
'In-House' as [Account Status],
count(*) as [Count],
cast(sum(current1) as decimal(15,2)) as [Current Balance]
FROM
master WITH (NOLOCK) WHERE attorneystatus in ( 'Recalled','In-House') 
GROUP BY  attorneystatus

SELECT
attorneystatus as [Account Status],
isnull(a.name,'Not Assigned') as [Location],
--assignedattorney as [Date Assigned],
count(*) as [Count],
cast(sum(current1) as decimal(15,2)) as [Current Balance]
FROM

master m WITH (NOLOCK) LEFT OUTER JOIN attorney a WITH (NOLOCK) ON m.attorneyid = a.attorneyid

WHERE 
attorneystatus in ('Placed','Placing','Recalling')
GROUP BY attorneystatus,a.name--,assignedattorney


UNION 
SELECT 
'Agency' as [Account Status],
isnull(a.name,'Not Assigned') as [Location],
--AIMAssigned as [Date Assigned],
count(*) as [Count],
cast(sum(current1) as decimal(15,2)) as [Current Balance]



FROM

master m WITH (NOLOCK) LEFT OUTER JOIN AIM_Agency a WITH (NOLOCK) ON m.AIMAgency = a.AgencyId

WHERE 
AIMAgency is not null and AIMAgency <> 0
GROUP BY a.name--,AIMAssigned




GO
