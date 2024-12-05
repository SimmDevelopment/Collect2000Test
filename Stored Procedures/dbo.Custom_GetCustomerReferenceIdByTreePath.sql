SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/16/2005
-- Description:	Will locate the Custom_CustomerReference rows with the specified treepath
-- =============================================
/*
exec Custom_GetCustomerReferenceIdByTreePath @TreePath='Clients\Development\PCI'
*/
CREATE PROCEDURE [dbo].[Custom_GetCustomerReferenceIdByTreePath]
	@TreePath varchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select CustomerReferenceId as [CustomerReferenceId]
	From Custom_CustomerReference
	Where TreePath = @TreePath

END

GO
