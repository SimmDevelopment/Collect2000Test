SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Propensio_Profile_PhoneAdded]
    @AccountId VARCHAR(50),
    @UserId VARCHAR(50),
    @Username VARCHAR(50),
    @IPAddress VARCHAR(50),
    @ContactId UNIQUEIDENTIFIER,
    @PhoneNumber VARCHAR(50),
    @PhoneNumberNormalized VARCHAR(50),
    @PhoneNumberFormatted VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        --DECLARE VARIABLES
        DECLARE @seq INT = 0;
        DECLARE @phonetype INT = 1;
        DECLARE @PhoneExists BIT = 0;
        DECLARE @phone10digits VARCHAR(10) = RIGHT(dbo.StripNonDigits(@PhoneNumber), 10);
        DECLARE @masterNumber INT;
        DECLARE @debtorID INT;
        DECLARE @OldPhoneNumber VARCHAR(10);
        DECLARE @statusmessage VARCHAR(500);
        DECLARE @masterphoneid INT;
        DECLARE @dateupdated DATETIME = GETDATE();

        --@accountid may be pipe delimited - number is before the pipe
        SET @masterNumber = CASE
                                WHEN CHARINDEX('|', @AccountId) > 0 THEN
                                    LEFT(@AccountId, CHARINDEX('|', @AccountId) - 1)
                                ELSE
                                    @AccountId
                            END;
        SET @debtorID =
        (
            SELECT DebtorID
            FROM Debtors WITH (NOLOCK)
            WHERE Number = @masterNumber
                  AND Seq = @seq
        );

        --grab old homephone for phonehistory
        SELECT @OldPhoneNumber =
        (
            SELECT TOP 1
                   PhoneNumber
            FROM Phones_Master pm WITH (NOLOCK)
            WHERE Number = @masterphoneid
                  AND DebtorID = @debtorID
                  AND pm.PhoneTypeID = 1
                  AND
                  (
                      pm.PhoneStatusID IN ( 0, 2 )
                      OR pm.PhoneStatusID IS NULL
                  )
            ORDER BY pm.DateAdded DESC
        );
        IF @OldPhoneNumber IS NULL
        BEGIN
            SET @OldPhoneNumber = '';
        END;

        --VALIDATE DATA
        IF (@masterNumber IS NULL)
        BEGIN
            RAISERROR('Invalid @accountid entry.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        --If phone already exists and is good - do not add
        IF EXISTS
        (
            SELECT *
            FROM Phones_Master pm WITH (NOLOCK)
            WHERE Number = @masterNumber
                  AND pm.DebtorID = @debtorID
                  AND dbo.StripNonDigits(pm.PhoneNumber) = @phone10digits
                  AND
                  (
                      pm.PhoneStatusID IN ( 0, 2 )
                      OR pm.PhoneStatusID IS NULL
                  )
        )
        BEGIN
            SET @statusmessage = 'Phone Number already exists, not added.';
            GOTO ExitProcedure;
        END;

        --If phone already exists and is bad then mark as good
        IF EXISTS
        (
            SELECT *
            FROM Phones_Master pm WITH (NOLOCK)
            WHERE Number = @masterNumber
                  AND pm.DebtorID = @debtorID
                  AND dbo.StripNonDigits(pm.PhoneNumber) = @phone10digits
                  AND pm.PhoneStatusID IN ( 1, 3 )
        )
        BEGIN
            SELECT @masterphoneid =
            (
                SELECT TOP 1
                       MasterPhoneID
                FROM Phones_Master pm WITH (NOLOCK)
                WHERE Number = @masterNumber
                      AND pm.DebtorID = @debtorID
                      AND dbo.StripNonDigits(pm.PhoneNumber) = @phone10digits
                      AND pm.PhoneStatusID IN ( 1, 3 )
                ORDER BY pm.DateAdded DESC
            );
            UPDATE Phones_Master
            SET PhoneStatusID = 2,
                LastUpdated = @dateupdated
            WHERE MasterPhoneID = @masterphoneid;
            SET @PhoneExists = 1;
        END;
        IF @PhoneExists = 1
        BEGIN
            SET @statusmessage = 'Phone existed but was marked Bad or Do Not Call - Updated to Marked as Good';
            INSERT INTO notes
            (
                number,
                created,
                user0,
                action,
                result,
                comment,
                IsPrivate
            )
            VALUES
            (@masterNumber, @dateupdated, 'PAYWEB', '+++++', '+++++',
             'Phone information has been updated from PAYWEB Portal. Bad Phone Marked Good - '
             + CAST(@PhoneNumber AS VARCHAR(20)), 0);
            GOTO exitprocedure;
        END;
        ELSE
        BEGIN
            INSERT INTO notes
            (
                number,
                created,
                user0,
                action,
                result,
                comment,
                IsPrivate
            )
            VALUES
            (@masterNumber, @dateupdated, 'PAYWEB', '+++++', '+++++',
             'Phone information has been updated from PAYWEB Portal. Phone Added - '
             + CAST(@PhoneNumber AS VARCHAR(20)), 0);
        END;
        IF (
               @phone10digits IS NOT NULL
               AND @phone10digits <> ''
               AND @PhoneExists = 0
           )
        BEGIN
            IF (@phonetype = 1)
            BEGIN
                UPDATE Debtors
                SET HomePhone = @phone10digits,
                    DateUpdated = @dateupdated
                WHERE DebtorID = @debtorID;
                UPDATE master
                SET homephone = @phone10digits
                WHERE number = @masterNumber;
            END;
            INSERT INTO notes
            (
                number,
                created,
                user0,
                action,
                result,
                comment,
                IsPrivate
            )
            VALUES
            (@masterNumber, @dateupdated, 'PAYWEB', '+++++', '+++++', 'Home Phone ' + @phone10digits + ' added', 0);
        END;
        IF @PhoneExists = 0
        BEGIN
            INSERT INTO PhoneHistory
            (
                AccountID,
                DebtorID,
                DateChanged,
                UserChanged,
                Phonetype,
                OldNumber,
                NewNumber,
                TransmittedDate
            )
            VALUES
            (@masterNumber, @debtorID, @dateupdated, 'PAYWEB', @phonetype, ISNULL(@OldPhoneNumber, ''),
             ISNULL(@phone10digits, ''), NULL);
        END;
        ExitProcedure:
        INSERT INTO Custom_Propensio_Portfolio_Log
        (
            StoredProcedure,
            AccountId,
            UserId,
            Username,
            IPAddress,
            ContactId,
            PhoneNumber,
            PhoneNumberNormalized,
            PhoneNumberFormatted,
            StatusMessage
        )
        VALUES
        ('[Propensio_Profile_PhoneAdded]', @AccountId, @UserId, @Username, @IPAddress, @ContactId, @PhoneNumber,
         @PhoneNumberNormalized, @PhoneNumberFormatted, @statusmessage);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        SET @statusmessage = 'Transaction Rolled Back : ' + @ErrorMessage;
        INSERT INTO Custom_Propensio_Portfolio_Log
        (
            StoredProcedure,
            AccountId,
            UserId,
            Username,
            IPAddress,
            ContactId,
            PhoneNumber,
            PhoneNumberNormalized,
            PhoneNumberFormatted,
            StatusMessage
        )
        VALUES
        ('[Propensio_Profile_PhoneAdded]', @AccountId, @UserId, @Username, @IPAddress, @ContactId, @PhoneNumber,
         @PhoneNumberNormalized, @PhoneNumberFormatted, @statusmessage);
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
