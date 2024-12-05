SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Propensio_Profile_EmailSubscribed]
    @AccountId VARCHAR(50),
    @UserId VARCHAR(50),
    @Username VARCHAR(50),
    @IPAddress VARCHAR(50),
    @ContactId UNIQUEIDENTIFIER,
    @EmailAddress VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        --DECLARE VARIABLES
        DECLARE @seq INT = 0;
        DECLARE @masterNumber INT;
        DECLARE @debtorID INT;
        DECLARE @statusmessage VARCHAR(500);
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

        --Email CHANGE Logic
        --See if email exists in debtors, email, and emaildebtorshistory table - grab email and emaildebtorshistory ids for updates.
        --Insert/Update data into debtor,email, and amildebtorshistory table based on if record exists or not.
        DECLARE @debtors_email VARCHAR(255) =
                (
                    SELECT TOP 1 ISNULL(Email, '')FROM Debtors WHERE DebtorID = @debtorID
                );
        DECLARE @email_email VARCHAR(255) =
                (
                    SELECT TOP 1
                           ISNULL(Email, '')
                    FROM Email
                    WHERE DebtorId = @debtorID
                          AND Active = 1
                          AND [Primary] = 1
                    ORDER BY CreatedWhen DESC
                );
        DECLARE @emaildebtorshistory_email VARCHAR(255) =
                (
                    SELECT TOP 1
                           ISNULL(Email, '')
                    FROM EmailDebtorsHistory
                    WHERE DebtorId = @debtorID
                          AND Active = 1
                          AND [Primary] = 1
                    ORDER BY CreatedWhen DESC
                );

        --DEBTORS Table Updates
        --change debtors email regardless		
        UPDATE Debtors
        SET Email = @EmailAddress,
            contactmethod = 'Email' --Set Preffered conact to email
        WHERE DebtorID = @debtorID;
        --write note
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
         'Email information has been updated from PAYWEB - Email Subscribed - ' + @EmailAddress, 0);
        --write history for debtors change
        INSERT INTO dbo.EmailHistory
        (
            AccountID,
            DebtorID,
            DateChanged,
            UserChanged,
            OldEmail,
            NewEmail,
            TransmittedDate
        )
        VALUES
        (@masterNumber, @debtorID, @dateupdated, 'PAYWEB-Debtors.email', @debtors_email, @EmailAddress, NULL);

        --EMAIL Table Updates
        --if email entry exists update old entries and insert new entries.
        IF (@email_email IS NOT NULL OR LEN(@debtors_email) > 0)
        BEGIN
            UPDATE Email
            SET [Primary] = 0
            WHERE DebtorId = @debtorID;
        END;
        --Remove old emails with same address
        DELETE FROM Email
        WHERE @debtorID = @debtorID
              AND Email = @EmailAddress;
        --Insert new email
        INSERT INTO Email
        (
            DebtorAssociationId,
            DebtorId,
            Email,
            TypeCd,
            StatusCd,
            Active,
            [Primary],
            ConsentGiven,
            WrittenConsent,
            ConsentSource,
            ConsentBy,
            ConsentDate,
            CreatedWhen,
            CreatedBy,
            ModifiedWhen,
            ModifiedBy,
            comment
        )
        VALUES
        (@debtorID, @debtorID, @EmailAddress, 'Home', 'Good', 1, 1, 1, 0, 'PAYWEB', 'PAYWEB', @dateupdated,
         @dateupdated, 'PAYWEB', @dateupdated, 'PAYWEB', '');
        --Update history
        INSERT INTO dbo.EmailHistory
        (
            AccountID,
            DebtorID,
            DateChanged,
            UserChanged,
            OldEmail,
            NewEmail,
            TransmittedDate
        )
        VALUES
        (@masterNumber, @debtorID, @dateupdated, 'PAYWEB-Email.email', @debtors_email, @EmailAddress, NULL);

        --EMAILDEBTORSHISTORY Table Updates
        --if email entry exists update old entries and insert new entries.
        IF (@emaildebtorshistory_email IS NOT NULL OR LEN(@debtors_email) > 0)
        BEGIN
            UPDATE dbo.EmailDebtorsHistory
            SET [Primary] = 0
            WHERE DebtorId = @debtorID;
        END;

        --remove old emails if the exist
        DELETE FROM dbo.EmailDebtorsHistory
        WHERE DebtorId = @debtorID
              AND Email = @EmailAddress;
        --Insert new email
        INSERT INTO EmailDebtorsHistory
        (
            DebtorId,
            Email,
            TypeCd,
            StatusCd,
            Active,
            [Primary],
            ConsentGiven,
            WrittenConsent,
            ConsentSource,
            ConsentBy,
            ConsentDate,
            CreatedWhen,
            CreatedBy,
            ModifiedWhen,
            ModifiedBy,
            comment
        )
        VALUES
        (@debtorID, @EmailAddress, 'Home', 'Good', 1, 1, 1, 0, 'PAYWEB', 'PAYWEB', @dateupdated, @dateupdated,
         'PAYWEB', @dateupdated, 'PAYWEB', '');
        --Write History
        INSERT INTO dbo.EmailHistory
        (
            AccountID,
            DebtorID,
            DateChanged,
            UserChanged,
            OldEmail,
            NewEmail,
            TransmittedDate
        )
        VALUES
        (@masterNumber, @debtorID, @dateupdated, 'PAYWEB-EmailDebtorsHistory.email', @debtors_email, @EmailAddress,
         NULL);


        ExitProcedure:
        INSERT INTO Custom_Propensio_Portfolio_Log
        (
            StoredProcedure,
            AccountId,
            UserId,
            Username,
            IPAddress,
            ContactId,
            EmailAddress,
            StatusMessage
        )
        VALUES
        ('[Propensio_Profile_EmailSubscribed]', @AccountId, @UserId, @Username, @IPAddress, @ContactId, @EmailAddress,
         @statusmessage);
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
            EmailAddress,
            StatusMessage
        )
        VALUES
        ('[Propensio_Profile_EmailSubscribed]', @AccountId, @UserId, @Username, @IPAddress, @ContactId, @EmailAddress,
         @statusmessage);
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
