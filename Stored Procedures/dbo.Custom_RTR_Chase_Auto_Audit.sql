SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Brian Meehan, Simm Associates, Inc.
-- Create date: 4/20/2013
-- Description:	Prepares Audit information to send to client
-- =============================================


/*
declare @customer varchar(8000)

set @customer='255001|255002|255003|255004|256001|256002'
exec Custom_RTR_Chase_Auto_Audit @customer=@customer
*/
CREATE    PROCEDURE [dbo].[Custom_RTR_Chase_Auto_Audit]
	 @customer varchar(8000)
AS
BEGIN

DECLARE @id2 VARCHAR(50)
declare cur cursor for 
	
	--load the cursor with the information from the servicehistory table and parse the xmlinforeturned field
	SELECT DISTINCT AlphaCode FROM customer WITH (NOLOCK) WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	
open cur

--get the information from the cursor and into the variables
fetch from cur into @id2
while @@fetch_status = 0 begin


	SELECT DISTINCT--Audit Header Record
		'*' AS [RecordCode],
		c.AlphaCode AS [AgencyCode],
        'Real Time Resolutions' AS [AgencyName],
		--Filler--
		count(m.number) AS [NumAccounts],--(select count(distinct t.number) from @tmpcms_audit t JOIN master m2 with (nolock) ON m2.number=t.number WHERE m2.customer=m.customer) AS [NumAccounts],
		getdate() as [Date],
		SUM(m.current0) AS [TotalBalance]--(select SUM(m2.current0) FROM master m2 with (nolock) JOIN @tmpcms_audit t ON m2.Number=t.number WHERE m2.customer=m.customer) AS [TotalBalance]

	FROM master m with (nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.Customer
	WHERE m.returned is NULL AND c.AlphaCode = @id2
	GROUP BY c.AlphaCode


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
	FROM master m with (nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	WHERE m.returned is NULL AND c.AlphaCode = @id2
	
fetch from cur into @id2
	
end
--close and free up all the resources.
close cur
deallocate cur
END
GO
