SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_DataById]
	@ID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
Select	[ID]					as	[ID],
			[Name]					as	[Name],
			[Description]			as	[Description],
			[StopAllOnError]		as	[StopAllOnError],
			[ImportConfigXml]		as	[ImportConfigXml],
			[OwnerInterfacePath]	as	[OwnerInterfacePath],
			[AutoProcessAllowed]	as	[AutoProcessAllowed],
			[ProcessType],[ProtectionID],[TransferID]
	From	Custom_ExchangeAuto
	Where	ID=@ID
END


GO
