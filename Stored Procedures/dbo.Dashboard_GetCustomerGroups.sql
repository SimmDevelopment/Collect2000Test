SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Dashboard_GetCustomerGroups]
AS
BEGIN
                    
    SELECT ID, [Name], [Description]
    FROM customcustgroups	
    ORDER BY [Name]

    SELECT f.CustomGroupID, c.Customer, c.[Name]
    FROM customer c
    JOIN fact f on f.customerid = c.customer
    WHERE c.[status] = 'ACTIVE'
    ORDER BY c.[Name]
END

GO
