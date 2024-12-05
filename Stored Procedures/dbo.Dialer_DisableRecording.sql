SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dialer_DisableRecording] @AccountID INTEGER, @Seq INTEGER, @Phone VARCHAR(20), @DisableRecording BIT OUTPUT
AS
SET NOCOUNT ON;

DECLARE @State VARCHAR(3);

IF @Phone IS NOT NULL AND LEN(@Phone) >= 3 BEGIN
		DECLARE @AreaCode CHAR(3);
		IF SUBSTRING(@Phone, 1, 1) = '1' AND LEN(@Phone) >= 4
			SET @AreaCode = SUBSTRING(@Phone, 2, 3);
		ELSE
			SET @AreaCode = SUBSTRING(@Phone, 1, 3);

		SELECT TOP 1 @State = [STATE]
		FROM [dbo].[ZIPCODES] WITH (NOLOCK)
		WHERE [AREACODE] LIKE '%' + @AreaCode + '%';

		IF @State = 'CA' BEGIN
			SET @DisableRecording = 1;
			RETURN 1;
		END;
END;

IF @AccountID IS NOT NULL AND @AccountID != -1 BEGIN
	IF @Seq IS NULL
		SET @Seq = 0;

	SELECT TOP 1 @State = [State]
	FROM [dbo].[Debtors] WITH (NOLOCK)
	WHERE [number] = @AccountID
	AND [seq] = @Seq;

	IF @State = 'CA' BEGIN
		SET @DisableRecording = 1;
		RETURN 1;
	END;
END;

SET @DisableRecording = 0;
RETURN 0;

GO
