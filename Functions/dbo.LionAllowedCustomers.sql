SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

/****** Object:  User Defined Function dbo.LionAllowedCustomers    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/01/2006
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[LionAllowedCustomers]
(
	@lionUserId int
)
RETURNS 
@SET TABLE 
(
	-- Add the column definitions for the TABLE variable here
	Customer varchar(7)
)
AS
BEGIN
	INSERT @Set
		-- Fill the table variable with the rows for your result set
		Select CustomerID
		From Fact fact with (nolock)
		Join CustomCustGroups ccg with (nolock) on fact.CustomGroupID=ccg.id
		Join LionUsers lu with (nolock) on lu.CustomerGroupId=ccg.id
		Where lu.id=@lionUserId
	RETURN 
END

GO
