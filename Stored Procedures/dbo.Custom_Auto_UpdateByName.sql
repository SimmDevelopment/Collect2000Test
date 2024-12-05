SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_UpdateByName]
	@Name varchar(200),
	@Description varchar(500),
	@StopAllOnError bit,
	@ImportConfigXml text,
	@OwnerInterfacePath varchar(500),
	@AutoProcessAllowed bit,
	@ProcessType varchar(10),
	@ProtectionID int,
	@TransferID int
AS
BEGIN
	SET NOCOUNT ON;
    Update Custom_ExchangeAuto
			set [Description]=@Description,
				[StopAllOnError]=@StopAllOnError,
				[ImportConfigXml]=@ImportConfigXml,
				[OwnerInterfacePath]=@OwnerInterfacePath,
				[AutoProcessAllowed]=@AutoProcessAllowed,
				ProcessType = @ProcessType,
				ProtectionID = case when @ProtectionID = -1 then null else @ProtectionID end,TransferID = case when @TransferID  = -1 then null  else TransferID end
	Where	name=@Name
END
GO
