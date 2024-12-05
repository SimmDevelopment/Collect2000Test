SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessDispute]
    @client_id INT ,
    @file_number INT ,
    @debtor_number INT ,
    @source VARCHAR(20) ,
    @id INT ,
    @receiver_dispute_id INT ,
    @type_code VARCHAR(10) ,
    @type VARCHAR(255) ,
    @date_received DATETIME ,
    @referred_by_code VARCHAR(10) ,
    @referred_by VARCHAR(255) ,
    @details VARCHAR(MAX) ,
    @category_code VARCHAR(10) ,
    @category VARCHAR(255) ,
    @against_code VARCHAR(10) ,
    @against VARCHAR(255) ,
    @date_closed DATETIME ,
    @recourse_date DATETIME ,
    @justified VARCHAR(10) ,
    @outcome_code VARCHAR(10) ,
    @outcome VARCHAR(255) ,
    @deleted NVARCHAR(1) ,
    @proof_required NVARCHAR(1) ,
    @proof_requested NVARCHAR(1) ,
    @insufficient_proof_received NVARCHAR(1) ,
    @proof_received NVARCHAR(1)
AS
    BEGIN
		DECLARE @DisputeId INT;
        DECLARE @receiverNumber INT;
        DECLARE @newDisputeId INT;
        SELECT @receiverNumber = MAX(ReceiverNumber)
        FROM   Receiver_Reference WITH ( NOLOCK )
        WHERE  SenderNumber = @file_number
               AND ClientId = @client_id;
        IF ( @receiverNumber IS NULL )
            BEGIN
                RAISERROR('15001', 16, 1);
                RETURN;
            END;

        DECLARE @dnumber INT;
        SELECT @dnumber = MAX(ReceiverDebtorId)
        FROM   Receiver_DebtorReference rd WITH ( NOLOCK )
               JOIN Debtors d WITH ( NOLOCK ) ON rd.ReceiverDebtorId = d.DebtorID
               JOIN master m WITH ( NOLOCK ) ON d.Number = m.number
        WHERE  SenderDebtorId = @debtor_number
               AND ClientId = @client_id;

        IF ( @dnumber IS NULL )
            BEGIN
                RAISERROR('15001', 16, 1); -- TODO Which error to raise here?
                RETURN;
            END;

        IF (   RTRIM(LTRIM(ISNULL(@type_code, ''))) != ''
               AND @type IS NOT NULL
           )
            BEGIN
                IF NOT EXISTS (   SELECT *
                                  FROM   [dbo].[DisputeType]
                                  WHERE  [Code] = @type_code
                              )
                    BEGIN
                        INSERT INTO [dbo].[DisputeType] (   [Code] ,
                                                            [ProofRequired] ,
                                                            [Description] ,
                                                            [CreatedWhen] ,
                                                            [CreatedBy] ,
                                                            [ModifiedWhen] ,
                                                            [ModifiedBy]
                                                        )
                        VALUES (   @type_code ,        -- Code - varchar(10)
                                   NULL ,      -- ProofRequired - bit
                                   @type ,        -- Description - varchar(max)
                                   GETDATE() , -- CreatedWhen - datetime
                                   'RECEIVER' ,        -- CreatedBy - varchar(255)
                                   GETDATE() , -- ModifiedWhen - datetime
                                   'RECEIVER'          -- ModifiedBy - varchar(255)
                               )
                    END;
            END;

        IF (   RTRIM(LTRIM(ISNULL(@referred_by_code, ''))) != ''
               AND @referred_by IS NOT NULL
           )
            BEGIN
                IF NOT EXISTS (   SELECT *
                                  FROM   [dbo].[Custom_ListData]
                                  WHERE  [ListCode] = 'DISPUTEREF'
                                         AND [Code] = @referred_by_code
                              )
                    BEGIN
                        INSERT INTO [dbo].[Custom_ListData] (   [ListCode] ,
                                                                [Code] ,
                                                                [Description] ,
                                                                [SysCode] ,
                                                                [CreatedBy] ,
                                                                [UpdatedBy] ,
                                                                [CreatedWhen] ,
                                                                [UpdatedWhen] ,
                                                                [Enabled]
                                                            )
                                    SELECT 'DISPUTEREF' ,
                                           @referred_by_code ,
                                           @referred_by ,
                                           1 ,
                                           'RECEIVER' ,
                                           'RECEIVER' ,
                                           GETDATE() ,
                                           GETDATE() ,
                                           1;
                    END;
            END;

        IF (   RTRIM(LTRIM(ISNULL(@outcome_code, ''))) != ''
               AND @outcome IS NOT NULL
           )
            BEGIN
                IF NOT EXISTS (   SELECT *
                                  FROM   [dbo].[Custom_ListData]
                                  WHERE  [ListCode] = 'DISPUTEOUT'
                                         AND [Code] = @outcome_code
                              )
                    BEGIN
                        INSERT INTO [dbo].[Custom_ListData] (   [ListCode] ,
                                                                [Code] ,
                                                                [Description] ,
                                                                [SysCode] ,
                                                                [CreatedBy] ,
                                                                [UpdatedBy] ,
                                                                [CreatedWhen] ,
                                                                [UpdatedWhen] ,
                                                                [Enabled]
                                                            )
                                    SELECT 'DISPUTEOUT' ,
                                           @outcome_code ,
                                           @outcome ,
                                           1 ,
                                           'RECEIVER' ,
                                           'RECEIVER' ,
                                           GETDATE() ,
                                           GETDATE() ,
                                           1;
                    END;
            END;

        IF (   RTRIM(LTRIM(ISNULL(@category_code, ''))) != ''
               AND @category IS NOT NULL
           )
            BEGIN
                IF NOT EXISTS (   SELECT *
                                  FROM   [dbo].[Custom_ListData]
                                  WHERE  [ListCode] = 'DISPUTECAT'
                                         AND [Code] = @category_code
                              )
                    BEGIN
                        INSERT INTO [dbo].[Custom_ListData] (   [ListCode] ,
                                                                [Code] ,
                                                                [Description] ,
                                                                [SysCode] ,
                                                                [CreatedBy] ,
                                                                [UpdatedBy] ,
                                                                [CreatedWhen] ,
                                                                [UpdatedWhen] ,
                                                                [Enabled]
                                                            )
                                    SELECT 'DISPUTECAT' ,
                                           @category_code ,
                                           @category ,
                                           1 ,
                                           'RECEIVER' ,
                                           'RECEIVER' ,
                                           GETDATE() ,
                                           GETDATE() ,
                                           1;
                    END;
            END;


        IF (   RTRIM(LTRIM(ISNULL(@against_code, ''))) != ''
               AND @against IS NOT NULL
           )
            BEGIN
                IF NOT EXISTS (   SELECT *
                                  FROM   [dbo].[Custom_ListData]
                                  WHERE  [ListCode] = 'DISPUTEAGT'
                                         AND [Code] = @against_code
                              )
                    BEGIN
                        INSERT INTO [dbo].[Custom_ListData] (   [ListCode] ,
                                                                [Code] ,
                                                                [Description] ,
                                                                [SysCode] ,
                                                                [CreatedBy] ,
                                                                [UpdatedBy] ,
                                                                [CreatedWhen] ,
                                                                [UpdatedWhen] ,
                                                                [Enabled]
                                                            )
                                    SELECT 'DISPUTEAGT' ,
                                           @against_code ,
                                           @against ,
                                           1 ,
                                           'RECEIVER' ,
                                           'RECEIVER' ,
                                           GETDATE() ,
                                           GETDATE() ,
                                           1;
                    END;
            END;

        -- Was the source AIM?
        IF ( RTRIM(LTRIM(@source)) = 'AIM' )
            BEGIN

                IF EXISTS (   SELECT *
                              FROM   [dbo].[Receiver_Dispute]
                              WHERE  [AIMDisputeID] = @id
                                     AND [ClientID] = @client_id
                                     AND [Source] = 'AIM'
                          )
                    BEGIN
                        SELECT @DisputeId = [DisputeID]
                        FROM   [dbo].[Receiver_Dispute]
                        WHERE  [AIMDisputeID] = @id
                               AND [ClientID] = @client_id
                               AND [Source] = 'AIM';

                        UPDATE [dbo].[Dispute]
                        SET    [Type] = @type_code ,
                               [ReferredBy] = @referred_by_code ,
                               [Details] = @details ,
                               [Category] = @category_code ,
                               [Against] = @against_code ,
                               [DateClosed] = @date_closed ,
                               [Outcome] = @outcome_code ,
                               [Justified] = @justified ,
                               [RecourseDate] = @recourse_date ,
                               [Deleted] = CASE @deleted
                                                WHEN 'Y' THEN 1
                                                ELSE 0
                                           END ,
                               [ProofRequired] = CASE WHEN @proof_required = 'Y' THEN
                                                          1
                                                      ELSE 0
                                                 END ,
                               [ProofRequested] = CASE WHEN @proof_requested = 'Y' THEN
                                                           1
                                                       ELSE 0
                                                  END ,
                               [InsufficientProofReceived] = CASE WHEN @insufficient_proof_received = 'Y' THEN
                                                                      1
                                                                  ELSE 0
                                                             END ,
                               [ProofReceived] = CASE WHEN @proof_received = 'Y' THEN
                                                          1
                                                      ELSE 0
                                                 END ,
                               [ModifiedWhen] = GETDATE() ,
                               [ModifiedBy] = 'AIM'
                        WHERE  [DisputeId] = @DisputeId;
                    END;
                -- Otherwise this is a new complaint that we have not received from AIM yet.
                ELSE
                    BEGIN

                        INSERT INTO [dbo].[Dispute] (   [Number] ,
                                                        [DebtorId] ,
                                                        [DocumentationId] ,
                                                        [Type] ,
                                                        [DateReceived] ,
                                                        [ReferredBy] ,
                                                        [Details] ,
                                                        [Category] ,
                                                        [Against] ,
                                                        [DateClosed] ,
                                                        [RecourseDate] ,
                                                        [Justified] ,
                                                        [Outcome] ,
                                                        [Deleted] ,
                                                        [ProofRequired] ,
                                                        [ProofRequested] ,
                                                        [InsufficientProofReceived] ,
                                                        [ProofReceived] ,
                                                        [CreatedWhen] ,
                                                        [CreatedBy] ,
                                                        [ModifiedWhen] ,
                                                        [ModifiedBy]
                                                    )
                        VALUES (   @receiverNumber ,   -- Number - int
                                   @dnumber ,          -- DebtorId - int
                                   NULL ,              -- DocumentationId - uniqueidentifier
                                   @type_code ,        -- Type - varchar(10)
                                   GETDATE() ,         -- DateReceived - datetime
                                   @referred_by_code , -- ReferredBy - varchar(10)
                                   @details ,          -- Details - varchar(max)
                                   @category_code ,    -- Category - varchar(10)
                                   @against_code ,     -- Against - varchar(10)
                                   @date_closed ,      -- DateClosed - datetime
                                   @recourse_date ,    -- RecourseDate - datetime
                                   @justified ,        -- Justified - varchar(10)
                                   @outcome_code ,     -- Outcome - varchar(255)
                                   CASE @deleted
                                        WHEN 'Y' THEN 1
                                        ELSE 0
                                   END ,               -- Deleted - bit
                                   CASE @proof_required
                                        WHEN 'Y' THEN 1
                                        ELSE 0
                                   END ,               -- ProofRequired - bit
                                   CASE @proof_requested
                                        WHEN 'Y' THEN 1
                                        ELSE 0
                                   END ,               -- ProofRequested - bit
                                   CASE @insufficient_proof_received
                                        WHEN 'Y' THEN 1
                                        ELSE 0
                                   END ,               -- InsufficientProofReceived - bit
                                   CASE @proof_received
                                        WHEN 'Y' THEN 1
                                        ELSE 0
                                   END ,               -- ProofReceived - bit
                                   GETDATE() ,         -- CreatedWhen - datetime
                                   'RECEIVER' ,        -- CreatedBy - varchar(255)
                                   GETDATE() ,         -- ModifiedWhen - datetime
                                   'RECEIVER'          -- ModifiedBy - varchar(255)
                               );

                        SET @newDisputeId = SCOPE_IDENTITY();

                        INSERT INTO [dbo].[Receiver_Dispute] (   [Source] ,
                                                                 [AccountID] ,
                                                                 [ClientID] ,
                                                                 [DisputeID] ,
                                                                 [AIMDisputeID]
                                                             )
                                    SELECT 'AIM' ,
                                           @receiverNumber ,
                                           @client_id ,
                                           @newDisputeId ,
                                           @id;
                    END;
            END;
			ELSE
			BEGIN
				SELECT @DisputeId = [DisputeID] FROM [dbo].[Receiver_Dispute] WHERE [DisputeID] = @receiver_dispute_id AND [ClientID] = @client_id AND [Source] = 'RECEIVER'

				UPDATE [dbo].[Dispute]
                SET    [Type] = @type_code ,
                        [ReferredBy] = @referred_by_code ,
                        [Details] = @details ,
                        [Category] = @category_code ,
                        [Against] = @against_code ,
                        [DateClosed] = @date_closed ,
                        [Outcome] = @outcome_code ,
                        [Justified] = @justified ,
                        [RecourseDate] = @recourse_date ,
                        [Deleted] = CASE @deleted
                                        WHEN 'Y' THEN 1
                                        ELSE 0
                                    END ,
                        [ProofRequired] = CASE WHEN @proof_required = 'Y' THEN
                                                    1
                                                ELSE 0
                                            END ,
                        [ProofRequested] = CASE WHEN @proof_requested = 'Y' THEN
                                                    1
                                                ELSE 0
                                            END ,
                        [InsufficientProofReceived] = CASE WHEN @insufficient_proof_received = 'Y' THEN
                                                                1
                                                            ELSE 0
                                                        END ,
                        [ProofReceived] = CASE WHEN @proof_received = 'Y' THEN
                                                    1
                                                ELSE 0
                                            END ,
                        [ModifiedWhen] = GETDATE() ,
                        [ModifiedBy] = 'AIM'
                WHERE  [DisputeId] = @DisputeId;
			END
    END;
GO
