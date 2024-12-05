SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Report_AccountsByDesk]
AS

SELECT m.Desk, d.Name, COUNT(*) Active, 
	(SELECT COUNT(*) Promise 
	FROM master WITH (NOLOCK)
	WHERE status IN ('PPA', 'PDC', 'REF', 'STL', 'PCC') AND desk = m.desk) Promise
FROM master m WITH (NOLOCK) INNER JOIN status s
	ON m.status = s.code INNER JOIN desk d
	ON m.desk = d.code
WHERE statustype = '0 - Active'
GROUP BY m.Desk, d.Name
ORDER BY m.Desk

GO
