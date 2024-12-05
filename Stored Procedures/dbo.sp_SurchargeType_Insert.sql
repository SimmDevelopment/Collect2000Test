SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_SurchargeType_Insert]
	@Description VARCHAR(40),
	@SurchargeAmount MONEY = 0,
	@SurchargePercent REAL = 0,
	@AdditionalAmount MONEY = 0,
	@AdditionalPercent REAL = 0,
	@LatitudeUser VARCHAR(255) = NULL,
	@UID INTEGER OUTPUT
AS
SET NOCOUNT ON;

IF @LatitudeUser IS NULL BEGIN
	SELECT @LatitudeUser = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();
END;

INSERT INTO [dbo].[SurchargeType] (
	[Description],
	[SurchargeAmount],
	[SurchargePercent],
	[AdditionalAmount],
	[AdditionalPercent],
	[Active],
	[DTE],
	[CreatedBy],
	[LastUpdated],
	[LastUpdatedBy]
)
VALUES (
	@Description,
	@SurchargeAmount,
	@SurchargePercent,
	@AdditionalAmount,
	@AdditionalPercent,
	1,
	GETDATE(),
	@LatitudeUser,
	GETDATE(),
	@LatitudeUser
);

SET @UID = SCOPE_IDENTITY();

RETURN 0;


GO
