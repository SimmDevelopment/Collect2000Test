SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Lib_Delete_PaymentBatchItems] @UID INTEGER
AS
SET NOCOUNT ON;
DECLARE @Err int;
DECLARE @Count int;
DECLARE @PaymentLinkUID int;
DECLARE @BatchSubType char(3);
DECLARE @PostDateUID int;
DECLARE @FileNumber int;

-- First lets capture any useful information...
SELECT TOP 1 @PaymentLinkUID = ISNULL([PaymentLinkUID], -1)
	, @PostDateUID = ISNULL([PostDateUID], -1)
	, @BatchSubType = ISNULL([SubBatchType],'')
	, @FileNumber = [FileNum]
FROM [PaymentBatchItems] WHERE [uid] = @UID;

SELECT @Err = @@ERROR, @Count = @@ROWCOUNT
IF @Err <> 0 RETURN @Err;

-- If there was no batchitem record, then we are done...this should never happen.
IF @Count = 0 RETURN 0


-- Next lets clean up any child records...
DELETE FROM [dbo].[PODPmtBatchDetail]
WHERE [BatchItemsId] = @UID;
SET @Err = @@ERROR;
-- Referential integrity requires that if the delete of these child records fail then we should not delete the parent record...
IF @Err <> 0 RETURN @Err;


-- OK so far, so lets go ahead and remove the batchitem record...
DELETE FROM [dbo].[PaymentBatchItems]
WHERE [uid] = @UID;
SET @Err = @@ERROR;
-- If we couldn't delete the batchitem record then we may as well stop here...
IF @Err <> 0 RETURN @Err;


-- Now we need to update any postdate records effected...
IF @PaymentLinkUID > 0 
BEGIN
	UPDATE [dbo].[Promises]
	set [PaymentLinkUID] = NULL
	where
	[PaymentLinkUID] = @PaymentLinkUID

	SET @Err = @@ERROR;
	IF @Err <> 0 RETURN @Err;

	-- lets try to link using the PaymentLinkUID value...
	UPDATE [dbo].[DebtorCreditCards]
	SET [IsActive] = 1, [IsBatched] = 0
	WHERE [PaymentLinkUID] = @PaymentLinkUID

	SELECT @Err = @@ERROR, @Count = @@ROWCOUNT
	IF @Err <> 0 RETURN @Err;
	
	-- Are we done?
	IF @Count > 0 RETURN 0

	-- if not a cc then check for pdc
	UPDATE [dbo].[pdc]
	SET [Active] = 1, [IsBatched] = 0
	WHERE [PaymentLinkUID] = @PaymentLinkUID

	SELECT @Err = @@ERROR, @Count = @@ROWCOUNT
	IF @Err <> 0 RETURN @Err;

	-- Are we done?
	IF @Count > 0 RETURN 0
	
END

-- so far we didn't find a match so try with PostDateUID value...
-- Check the batchsubtype value...
IF @PostDateUID > 0 
BEGIN
	IF @BatchSubType = 'PCC'
	BEGIN
		UPDATE [dbo].[DebtorCreditCards]
		SET [IsActive] = 1, [IsBatched] = 0
		WHERE [ID] = @PostDateUID

		SELECT @Err = @@ERROR, @Count = @@ROWCOUNT
		IF @Err <> 0 RETURN @Err;

		-- Are we done?
		IF @Count > 0 RETURN 0
	END

	IF @BatchSubType = 'PDC'
	BEGIN
		UPDATE [dbo].[pdc]
		SET [Active] = 1, [IsBatched] = 0
		WHERE [UID] = @PostDateUID

		SELECT @Err = @@ERROR, @Count = @@ROWCOUNT
		IF @Err <> 0 RETURN @Err;

		-- Are we done?
		IF @Count > 0 RETURN 0
			
	END
END

-- we got to here so apparenty there were no errors...
RETURN 0;
GO
