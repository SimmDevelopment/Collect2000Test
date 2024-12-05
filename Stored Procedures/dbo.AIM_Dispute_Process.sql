SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Dispute_Process]
    (
        @debtor_number INT ,
        @file_number INT ,
        @agencyId INT ,
        @source [VARCHAR](20) ,
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
    )
AS
    BEGIN
        DECLARE @DisputeId INT;
        DECLARE @masterNumber INT ,
                @currentAgencyId INT;
        DECLARE @agencyTier INT;
        DECLARE @agencyname VARCHAR(50);
        SELECT @masterNumber = ReferenceNumber ,
               @currentAgencyId = CurrentlyPlacedAgencyId
        FROM   AIM_AccountReference
        WHERE  ReferenceNumber = @file_number;

        IF ( @masterNumber IS NULL )
            BEGIN
                RAISERROR('15001', 16, 1);
                RETURN;
            END;
        IF ( @masterNumber <> @file_number )
            BEGIN
                RAISERROR('15008', 16, 1);
                RETURN;
            END;
        IF (   @currentAgencyId IS NULL
               OR ( @currentAgencyId <> @agencyId )
           )
            BEGIN
                RAISERROR('15004', 16, 1);
                RETURN;
            END;

        SELECT @agencyname = a.Name
        FROM   AIM_AccountReference ar WITH ( NOLOCK )
               INNER JOIN AIM_Agency a WITH ( NOLOCK ) ON ar.CurrentlyPlacedAgencyId = a.AgencyId
        WHERE  ar.ReferenceNumber = @file_number;

			-- run actions configured at agency level if agency does not keep deceased
 		DECLARE @keepsDispute BIT
 		SELECT @keepsDispute = ISNULL([KeepsDispute],0) FROM [dbo].[AIM_Agency] WHERE [agencyid] = @agencyid

        -- We need to check if we have all lookup type codes. If we don't have them we need to add.
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
                                   'AIM' ,        -- CreatedBy - varchar(255)
                                   GETDATE() , -- ModifiedWhen - datetime
                                   'AIM'          -- ModifiedBy - varchar(255)
                               )
                    END;
            END;

        IF (   RTRIM(LTRIM(ISNULL(@referred_by_code, ''))) != ''
               AND @referred_by_code IS NOT NULL
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
                              FROM   [dbo].[AIM_Dispute]
                              WHERE  [ID] = @id
                                     AND [AgencyID] = @agencyId
                                     AND [Source] = 'AIM'
                          )
                    BEGIN
                        SELECT @DisputeId = [DisputeID]
                        FROM   [dbo].[AIM_Dispute]
                        WHERE  [ID] = @id
                               AND [AgencyID] = @agencyId
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
            END;
        ELSE
            BEGIN

                ---- Need to determine if we have an existing dispute using the id given.
                IF EXISTS (   SELECT *
                              FROM   [dbo].[AIM_Dispute]
                              WHERE  [ReceiverDisputeID] = @receiver_dispute_id
                                     AND [AgencyID] = @agencyId
                                     AND [Source] = 'RECEIVER'
							OR
							EXISTS(SELECT 1 FROM [dbo].[AIM_Dispute] WHERE [DisputeID] = @id AND [AgencyID] = @agencyId)
                          )
                    BEGIN
                        SELECT @DisputeId = [DisputeID]
                        FROM   [dbo].[AIM_Dispute]
                        WHERE  [ReceiverDisputeID] = @receiver_dispute_id
                               AND [AgencyID] = @agencyId
                               AND [Source] = 'RECEIVER';
						IF @DisputeId IS NULL
						BEGIN
							SELECT @DisputeId = [DisputeID] FROM [dbo].[AIM_Dispute] WHERE [DisputeID] = @id AND [AgencyID] = @agencyId
						END

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
                -- Otherwise a new record to insert.
                ELSE
                    BEGIN
                        DECLARE @debtorId INT;
						SELECT @debtorId = [DebtorId] FROM [dbo].[Debtors] WHERE [Number] = @file_number AND [SEQ] = 0
                        DECLARE @newDisputeId INT;
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
                        VALUES (   @file_number ,      -- Number - int
                                   @debtorId ,         -- DebtorId - int
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
                                   END,
                                   CASE WHEN @proof_required = 'Y' THEN 1
                                        ELSE 0
                                   END,
                                   CASE WHEN @proof_requested = 'Y' THEN 1
                                        ELSE 0
                                   END,
                                   CASE WHEN @insufficient_proof_received = 'Y' THEN
                                            1
                                        ELSE 0
                                   END,
                                   CASE WHEN @proof_received = 'Y' THEN 1
                                        ELSE 0
                                   END ,               -- ProofReceived - bit
                                   GETDATE() ,         -- CreatedWhen - datetime
                                   'RECEIVER' ,        -- CreatedBy - varchar(255)
                                   GETDATE() ,         -- ModifiedWhen - datetime
                                   'RECEIVER'          -- ModifiedBy - varchar(255)
                               );
                        SET @newDisputeId = SCOPE_IDENTITY();

                        INSERT INTO [dbo].[AIM_Dispute] (   [Source] ,
                                                            [AccountID] ,
                                                            [AgencyID] ,
                                                            [DisputeID] ,
                                                            [ReceiverDisputeID]
                                                        )
                                    SELECT 'RECEIVER' ,
                                           @masterNumber ,
                                           @agencyId ,
                                           @newDisputeId ,
                                           @receiver_dispute_id;

						IF (@keepsDispute = 0)
 						BEGIN
 							-- recall account
 							update  AIM_accountreference set 
 									lastrecalldate = null,expectedpendingrecalldate = null,
 									expectedfinalrecalldate = getdate(),numdaysplacedbeforepending = null,
 									ObjectionFlag = 0
 							from	AIM_accountreference ar with (nolock)
 							where	referencenumber = @masterNumber
 							-- flag master as recalled
 							update	master
 							set 	aimagency = null, aimassigned = null	,feecode = null
 							where	number = @masterNumber
 						END
                    END;
            END;
    END;
GO
