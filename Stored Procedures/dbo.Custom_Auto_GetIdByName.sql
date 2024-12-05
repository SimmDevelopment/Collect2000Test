SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_GetIdByName]
	@Name varchar(200)
AS
BEGIN
	SET NOCOUNT ON;

    Select	ID	as [ID]
	From Custom_ExchangeAuto
	Where	name=@name
END


GO
