SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionCustomerView    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionCustomerView]
AS
SELECT     customer, status, SelectedFlag, Name, Street1, Street2, phone, CustomerGroup, company, IsPODCust, DateCreated, DateUpdated, City, State, 
                      Zipcode
FROM         dbo.Customer

GO
