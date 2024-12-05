SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Exchange_PrepareCustomerReference]
AS
BEGIN
	SET NOCOUNT ON;

	delete from Custom_CustomerReference where CCustomerID is null and Configuration is null and TreePath is null

END
GO
