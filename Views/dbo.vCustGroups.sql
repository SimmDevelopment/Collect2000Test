SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View dbo.vCustGroups    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE VIEW [dbo].[vCustGroups]
AS
SELECT     customer, LOWER(Name) AS Name
FROM         dbo.Customer
WHERE     (CustGroup IS NULL) OR
                      (CustGroup = customer)

GO
