SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetAllowedCustomers    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/27/2006
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionGetAllowedCustomers]
	-- Add the parameters for the stored procedure here
	@lionUserId int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT customer, status, SelectedFlag, Name, Street1, Street2, phone, CustomerGroup, company, IsPODCust, DateCreated, DateUpdated, City, State, Zipcode 
	FROM dbo.LionCustomerView with (nolock)
	where customer in (select customer from LionAllowedCustomers(@lionUserId))

END

GO
