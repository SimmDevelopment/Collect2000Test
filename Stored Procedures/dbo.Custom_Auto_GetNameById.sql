SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_GetNameById]
	@ID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

    Select	Name	as [Name]
	From Custom_ExchangeAuto
	Where	id=@ID
END


GO
