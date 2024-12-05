SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetDebtorCallPreferences]
	@DebtorID INT
AS
BEGIN

	SELECT pm.MasterPhoneID, pm.PhoneNumber, pt.PhoneTypeDescription As PhoneType FROM Phones_Master pm
	INNER JOIN Phones_Types pt ON pt.PhoneTypeID = pm.PhoneTypeID
	WHERE pm.DebtorID = @DebtorID AND pm.OnHold <> 1 AND pm.PhoneStatusID <> 1

	DECLARE @MasterPhoneID VARCHAR(10), @PhoneNumber VARCHAR(20), @PhoneType VARCHAR(10);
	DECLARE phone_cur CURSOR FOR
	SELECT pm.MasterPhoneID, pm.PhoneNumber, pt.PhoneTypeDescription FROM Phones_Master pm
	INNER JOIN Phones_Types pt ON pt.PhoneTypeID = pm.PhoneTypeID
	WHERE pm.DebtorID = @DebtorID AND pm.OnHold <> 1 AND pm.PhoneStatusID <> 1;
	OPEN phone_cur
	FETCH NEXT FROM phone_cur INTO @MasterPhoneID, @PhoneNumber, @PhoneType
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE @callPreferences TABLE (DayNum INT, WeekName varchar(20), CallPreference varchar(500));
		DELETE FROM @callPreferences;
		insert into @callPreferences(DayNum, weekname) values(1,'Monday'),(2,'Tuesday'),(3,'Wednesday'),(4,'Thursday'),(5,'Friday'),(6,'Saturday'),(7,'Sunday');

		DECLARE @DayNum INT = 1;
		WHILE @DayNum < 8
		BEGIN

			DECLARE @Day VARCHAR(10);

			SELECT @Day = WeekName FROM @callPreferences WHERE DayNum = @DayNum;

			DECLARE @SQL NVARCHAR(MAX);

			DECLARE @DoNotCall BIT = 0;
			DECLARE @CallWindowStart VARCHAR(10) = '';
			DECLARE @CallWindowEnd VARCHAR(10) = '';
			DECLARE @NoCallWindowStart VARCHAR(10) = '';
			DECLARE @NoCallWindowEnd VARCHAR(10) = '';

			SET @SQL = 'SELECT TOP 1 @DoNotCall=ISNULL(' + @Day + 'DoNotCall,0), @CallWindowStart=' + @Day + 'CallWindowStart, 
			@CallWindowEnd=' + @Day + 'CallWindowEnd, @NoCallWindowStart=' + @Day + 'NoCallWindowStart, 
			@NoCallWindowEnd=' + @Day + 'NoCallWindowEnd FROM Phones_Preferences WHERE MasterPhoneID = ' + @MasterPhoneID + ' ORDER BY PhonesPreferencesID DESC';

			EXECUTE sp_executesql @SQL, N'@DoNotCall BIT OUTPUT,@CallWindowStart VARCHAR(2) OUTPUT,@CallWindowEnd VARCHAR(2) OUTPUT,
			@NoCallWindowStart VARCHAR(2) OUTPUT,@NoCallWindowEnd VARCHAR(2) OUTPUT', 
			@DoNotCall=@DoNotCall OUTPUT,@CallWindowStart=@CallWindowStart OUTPUT,@CallWindowEnd=@CallWindowEnd OUTPUT,
			@NoCallWindowStart=@NoCallWindowStart OUTPUT,@NoCallWindowEnd=@NoCallWindowEnd OUTPUT;

			SET @CallWindowStart = ISNULL(@CallWindowStart, '');
			SET @CallWindowEnd = ISNULL(@CallWindowEnd, '');
			SET @NoCallWindowStart = ISNULL(@NoCallWindowStart, '');
			SET @NoCallWindowEnd = ISNULL(@NoCallWindowEnd, '');

			IF @DoNotCall = 0
			BEGIN
				IF @CallWindowStart <> ''
				SET @CallWindowStart = CASE
										WHEN CONVERT(INT, @CallWindowStart) > 12 THEN CONVERT(VARCHAR(10), CONVERT(INT, @CallWindowStart) - 12) + ':00 PM'
										WHEN CONVERT(INT, @CallWindowStart) = 12 THEN '12:00 PM'
										WHEN CONVERT(INT, @CallWindowStart) = 0 THEN '12:00 AM'
										WHEN CONVERT(INT, @CallWindowStart) < 12 THEN @CallWindowStart + ':00 AM' END;
				IF @CallWindowEnd <> ''
				SET @CallWindowEnd = CASE
										WHEN CONVERT(INT, @CallWindowEnd) > 12 THEN CONVERT(VARCHAR(10), CONVERT(INT, @CallWindowEnd) - 12) + ':00 PM'
										WHEN CONVERT(INT, @CallWindowEnd) = 12 THEN '12:00 PM'
										WHEN CONVERT(INT, @CallWindowEnd) = 0 THEN '12:00 AM'
										WHEN CONVERT(INT, @CallWindowEnd) < 12 THEN @CallWindowEnd + ':00 AM' END;
				IF @NoCallWindowStart <> ''
				SET @NoCallWindowStart = CASE
										WHEN CONVERT(INT, @NoCallWindowStart) > 12 THEN CONVERT(VARCHAR(10), CONVERT(INT, @NoCallWindowStart) - 12) + ':00 PM'
										WHEN CONVERT(INT, @NoCallWindowStart) = 12 THEN '12:00 PM'
										WHEN CONVERT(INT, @NoCallWindowStart) = 0 THEN '12:00 AM'
										WHEN CONVERT(INT, @NoCallWindowStart) < 12 THEN @NoCallWindowStart + ':00 AM' END;
				IF @NoCallWindowEnd <> ''
				SET @NoCallWindowEnd = CASE
										WHEN CONVERT(INT, @NoCallWindowEnd) > 12 THEN CONVERT(VARCHAR(10), CONVERT(INT, @NoCallWindowEnd) - 12) + ':00 PM'
										WHEN CONVERT(INT, @NoCallWindowEnd) = 12 THEN '12:00 PM'
										WHEN CONVERT(INT, @NoCallWindowEnd) = 0 THEN '12:00 AM'
										WHEN CONVERT(INT, @NoCallWindowEnd) < 12 THEN @NoCallWindowEnd + ':00 AM' END;
			END

			DECLARE @Statement VARCHAR(500) = 'This debtor';

			IF @DoNotCall = 0 AND @CallWindowStart = '' AND @CallWindowEnd = '' AND @NoCallWindowStart = '' AND @NoCallWindowEnd = ''
			BEGIN
				SET @Statement = @Statement + '''s preference is not set for ';
			END
			ELSE IF @DoNotCall = 1 OR (@CallWindowStart = '' AND @CallWindowEnd = '' AND @NoCallWindowStart = '' AND @NoCallWindowEnd = '')
			BEGIN
				SET @Statement = @Statement + ' prefers not to be called at all on ';
			END
			ELSE
			BEGIN
				IF @CallWindowStart <> '' AND @CallWindowEnd <> ''
				BEGIN
					SET @Statement = @Statement + ' prefers to be called between ' + @CallWindowStart + ' - ' + @CallWindowEnd + ' ';
					IF @NoCallWindowStart <> '' AND @NoCallWindowEnd <> ''
					BEGIN
						SET @Statement = @Statement + 'and';
					END
					ELSE
					BEGIN
						SET @Statement = @Statement + 'on ';
					END
				END
				IF @NoCallWindowStart <> '' AND @NoCallWindowEnd <> ''
				BEGIN
					SET @Statement = @Statement + ' prefers not to be called between ' + @NoCallWindowStart + ' - ' + @NoCallWindowEnd + ' on ';
				END

				IF LEN(@CallWindowStart + @CallWindowEnd) < 10 AND LEN(@NoCallWindowStart + @NoCallWindowEnd) < 10
				BEGIN
					SET @Statement = @Statement + '''s preference is not set for ';
				END
			END

			UPDATE @callPreferences SET CallPreference = @Statement + @Day + 's.' WHERE DayNum = @DayNum;

		SET @DayNum = @DayNum + 1;
		END

		SELECT * FROM @callPreferences;

	FETCH NEXT FROM phone_cur INTO @MasterPhoneID, @PhoneNumber, @PhoneType
	END
	CLOSE phone_cur;  
	DEALLOCATE phone_cur;  

END
GO
