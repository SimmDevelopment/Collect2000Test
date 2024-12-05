SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ItemizationBalance_Add]
@AccountID INTEGER,
@ItemizationDateType VARCHAR(500) = NULL,
@ItemizationDate DATETIME,
@ItemizationBalance0 MONEY,
@ItemizationBalance1 MONEY,
@ItemizationBalance2 MONEY,
@ItemizationBalance3 MONEY,
@ItemizationBalance4 MONEY,
@ItemizationBalance5 MONEY
AS
BEGIN      
DECLARE @Count INTEGER;
SET @Count = (SELECT COUNT(*) FROM ItemizationBalance WHERE AccountID = @AccountID);
	IF(@Count > 0)
		BEGIN
			UPDATE ItemizationBalance SET
			ItemizationDateType = @ItemizationDateType, 
			ItemizationDate = @ItemizationDate,
			ItemizationBalance0 = @ItemizationBalance0,
			ItemizationBalance1 = @ItemizationBalance1,
			ItemizationBalance2 = @ItemizationBalance2,
			ItemizationBalance3 = @ItemizationBalance3,
			ItemizationBalance4 = @ItemizationBalance4,
			ItemizationBalance5 = @ItemizationBalance5
			WHERE AccountID = @AccountID			 
		END
	ELSE
		BEGIN
			INSERT INTO ItemizationBalance
			 (
				AccountID, 
				ItemizationDateType, 
				ItemizationDate,
				ItemizationBalance0,
				ItemizationBalance1,
				ItemizationBalance2,
				ItemizationBalance3,
				ItemizationBalance4,
				ItemizationBalance5
			)
			VALUES
			(
				@AccountID, 
				@ItemizationDateType, 
				@ItemizationDate,
				@ItemizationBalance0,
				@ItemizationBalance1,
				@ItemizationBalance2,
				@ItemizationBalance3,
				@ItemizationBalance4,
				@ItemizationBalance5	
			)
		END
END
GO
