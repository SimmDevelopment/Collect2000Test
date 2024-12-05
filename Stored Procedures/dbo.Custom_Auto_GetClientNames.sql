SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_GetClientNames]
	
AS
BEGIN
	SET NOCOUNT ON;

	select	[TreePath]	as	[Name]
	From	Custom_CustomerReference

END

/*
select top 4 * from Custom_CustomerReference
*/
GO
