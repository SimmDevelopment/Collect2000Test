SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_NameIdsByOwnerInterfacePath]
	@OwnerInterfacePath varchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Select	id as	[Id],
		name as	[Name]
From Custom_ExchangeAuto
Where OwnerInterfacePath=@OwnerInterfacePath

END


GO
