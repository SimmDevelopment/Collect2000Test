SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Propensio_Profile_AddressUpdated]
    @AccountId VARCHAR(50),
    @UserId VARCHAR(50),
    @Username VARCHAR(50),
    @IPAddress VARCHAR(50),
    @ContactId UNIQUEIDENTIFIER,
    @Street1 VARCHAR(50),
    @Street2 VARCHAR(50) = NULL,
    @City VARCHAR(50),
    @State VARCHAR(3),
    @Zip VARCHAR(50),
    @OldStreet1 VARCHAR(50) = NULL,
    @OldStreet2 VARCHAR(50) = NULL,
    @OldCity VARCHAR(50) = NULL,
    @OldState VARCHAR(3) = NULL,
    @OldZip VARCHAR(10) = NULL
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

        DECLARE @new_street1 VARCHAR(30),
                @new_street2 VARCHAR(30),
                @new_city VARCHAR(30),
                @new_state VARCHAR(3),
                @new_zip VARCHAR(10);
        SELECT @new_street1 = LEFT(@Street1, 30),
               @new_street2 = CASE
                                  WHEN LEN(@Street1) > 30 THEN
                                      LEFT(SUBSTRING(@Street1, 30, LEN(@Street1)) + ' ' + @Street2, 30)
                                  ELSE
                                      @Street2
                              END,
               @new_city = LEFT(@City, 30),
               @new_state = LEFT(@State, 3),
               @new_zip = LEFT(@Zip, 10);

        DECLARE @old_street1 VARCHAR(30),
                @old_street2 VARCHAR(30),
                @old_city VARCHAR(30),
                @old_state VARCHAR(3),
                @old_zipcode VARCHAR(10);
        SELECT @old_street1 = LEFT(@OldStreet1, 30),
               @old_street2 = LEFT(@OldStreet2, 30),
               @old_city = LEFT(@OldCity, 30),
               @old_state = LEFT(@OldState, 3),
               @old_zipcode = LEFT(@OldZip, 10);



        --UPDATE DEBTOR RECORD
        UPDATE Debtors
        SET Street1 = @new_street1,
            Street2 = @new_street2,
            City = @new_city,
            State = @new_state,
            Zipcode = @new_zip,
            DateUpdated = @dateupdated
        WHERE DebtorID = @debtorID;

        --UPDATE MASTER 
        UPDATE master
        SET Street1 = @new_street1,
            Street2 = @new_street2,
            City = @new_city,
            State = @new_state,
            Zipcode = @new_zip
        WHERE number = @masterNumber;

        --ADD NOTES
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
        (@masterNumber, GETDATE(), 'PAYWEB', 'ADDR', 'CHNG',
         'Address information has been updated from PAYWEB - Previous Debtor(1) info was: ' + ISNULL(@OldStreet1, '')
         + ' ' + ISNULL(@OldStreet2, '') + ISNULL(@OldCity, '') + ', ' + ISNULL(@OldState, '') + ' '
         + ISNULL(@OldZip, ''), 0);
        INSERT INTO AddressHistory
        (
            AccountID,
            DebtorID,
            DateChanged,
            UserChanged,
            OldStreet1,
            OldStreet2,
            OldCity,
            OldState,
            OldZipcode,
            NewStreet1,
            NewStreet2,
            NewCity,
            NewState,
            NewZipcode,
            TransmittedDate
        )
        VALUES
        (@masterNumber, @debtorID, @dateupdated, 'PAYWEB', ISNULL(@OldStreet1, ''), ISNULL(@OldStreet2, ''),
         ISNULL(@OldCity, ''), ISNULL(@OldState, ''), ISNULL(@OldZip, ''), ISNULL(@new_street1, ''), ISNULL(@new_street2, ''),
         ISNULL(@new_city, ''), ISNULL(@new_state, ''), ISNULL(@new_zip, ''), @dateupdated);
        ExitProcedure:
        INSERT INTO Custom_Propensio_Portfolio_Log
        (
            StoredProcedure,
            AccountId,
            UserId,
            Username,
            IPAddress,
            ContactId,
            Street1,
            Street2,
            City,
            State,
            Zip,
            OldStreet1,
            OldStreet2,
            OldCity,
            OldState,
            OldZip,
            StatusMessage
        )
        VALUES
        ('[Propensio_Profile_AddressUpdated]', @AccountId, @UserId, @Username, @IPAddress, @ContactId, @Street1,
         @Street2, @City, @State, @Zip, @OldStreet1, @OldStreet2, @OldCity, @OldState, @OldZip, @statusmessage);
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
            Street1,
            Street2,
            City,
            State,
            Zip,
            OldStreet1,
            OldStreet2,
            OldCity,
            OldState,
            OldZip,
            StatusMessage
        )
        VALUES
        ('[Propensio_Profile_AddressUpdated]', @AccountId, @UserId, @Username, @IPAddress, @ContactId, @Street1,
         @Street2, @City, @State, @Zip, @OldStreet1, @OldStreet2, @OldCity, @OldState, @OldZip, @statusmessage);
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
