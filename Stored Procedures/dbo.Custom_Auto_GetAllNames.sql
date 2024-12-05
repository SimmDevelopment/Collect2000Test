SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_GetAllNames]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select [name] as [Name] from Custom_ExchangeAuto
END

GO
