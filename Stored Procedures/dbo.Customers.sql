SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Customers]

AS
BEGIN

	Select distinct Customer, Name
	From Customer with (nolock)
	Order by Customer
	
END

GO
