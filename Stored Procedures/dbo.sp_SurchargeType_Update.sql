SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_SurchargeType_Update]
	@UID INTEGER,
	@Description VARCHAR(40),
	@SurchargeAmount MONEY = 0,
	@SurchargePercent REAL = 0,
	@AdditionalAmount MONEY = 0,
	@AdditionalPercent REAL = 0,
	@LatitudeUser VARCHAR(255) = NULL
AS
SET NOCOUNT ON;

IF @LatitudeUser IS NULL BEGIN
	SELECT @LatitudeUser = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();
END;

UPDATE [dbo].[SurchargeType]
SET [Description] = @Description,
	[SurchargeAmount] = @SurchargeAmount,
	[SurchargePercent] = @SurchargePercent,
	[AdditionalAmount] = @AdditionalAmount,
	[AdditionalPercent] = @AdditionalPercent,
	[LastUpdated] = GETDATE(),
	[LastUpdatedBy] = @LatitudeUser
WHERE [UID] = @UID;

RETURN 0;


GO
