SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Lib_Insert_LatitudeLegal_Messages]
(
      @ACCOUNTID   int,
      @PDATE   datetime,
      @PCODE   varchar (8),
      @PCMT   varchar (1024),
	  @Conflict bit,
	  @FORW_FILE varchar(20),
	  @MASCO_FILE varchar(15),
	  @FIRM_ID varchar(10),
	  @FORW_ID varchar(10)
)
as
begin


insert into dbo.LatitudeLegal_Messages
(
        ACCOUNTID  ,
        PDATE  ,
        PCODE  ,
        PCMT  ,
	    FORW_FILE,
	    MASCO_FILE,
		FIRM_ID,
		FORW_ID
)
values
(
      @ACCOUNTID,
      @PDATE,
      @PCODE,
      @PCMT,
	  @FORW_FILE,
	  @MASCO_FILE,
      @FIRM_ID,
	  @FORW_ID
)


--Now Workflow Account If Needed
DECLARE @desk varchar(10)
DECLARE @status varchar(5)
DECLARE @qlevel varchar(3)
DECLARE @olddesk varchar(10)
DECLARE @oldstatus varchar(5)
DECLARE @oldqlevel varchar(3)

DECLARE @recallaccount bit
DECLARE @shouldqueue bit
DECLARE @queuetype bit


SELECT @desk = CASE WHEN ltrim(rtrim(desk)) = '' THEN null ELSE desk END,
	   @status = CASE WHEN ltrim(rtrim(status)) = '' THEN null ELSE status END,
	   @qlevel = CASE WHEN ltrim(rtrim(qlevel)) = '' THEN null ELSE qlevel END,
	   @recallaccount = recallaccount
FROM LatitudeLegal_MessageMapping WITH (NOLOCK) WHERE PCODE = @PCODE


IF(((@desk is not null )
	or (@status is not null) 
	or (@qlevel is not null ))
	and @Conflict = 0)
BEGIN
IF(@Conflict = 0)
BEGIN
	SELECT @olddesk = desk,@oldstatus = status,@oldqlevel = qlevel 
	FROM master WITH (NOLOCK) WHERE number = @ACCOUNTID

	UPDATE master 
	SET 
	desk = isnull(@desk,desk),
	status = isnull(@status,status),
	qlevel = isnull(@qlevel,qlevel)
	WHERE number = @ACCOUNTID

	IF(@desk is not null)
	BEGIN
	INSERT INTO NOTES (number,action,result,created,comment)
	VALUES(@ACCOUNTID,'YGC','YGC',getdate(),'Desk was changed from ' +@olddesk+' to ' +@desk+' as a Message with code ' + @PCODE + ' was processed.')

	END
	IF(@status is not null)
	BEGIN
	INSERT INTO NOTES (number,action,result,created,comment)
	VALUES(@ACCOUNTID,'YGC','YGC',getdate(),'Status was changed from ' +@oldstatus+' to ' +@status+' as a Message with code ' + @PCODE + ' was processed.')

	END
	IF(@qlevel is not null)
	BEGIN
		INSERT INTO NOTES (number,action,result,created,comment)
		VALUES(@ACCOUNTID,'YGC','YGC',getdate(),'Qlevel was changed from ' +@oldqlevel+' to ' +@qlevel+' as a Message with code ' + @PCODE + ' was processed.')

		IF(@qlevel BETWEEN '600' AND '799')
		BEGIN
			
			IF(@oldqlevel NOT BETWEEN '600' AND '799')
				BEGIN
				SET @shouldqueue = 0
				END
			ELSE
				BEGIN
				SET @shouldqueue = 1
				END
		
			IF(@qlevel BETWEEN '600' AND '699')
				BEGIN
				SET @queuetype = 0
				END
			ELSE
				BEGIN
				SET @queuetype = 1
				END

			INSERT INTO SupportQueueItems (QueueCode,AccountID,DateAdded,DateDue,LastAccessed,ShouldQueue,UserName,QueueType,Comment)
			VALUES (@qlevel,@ACCOUNTID,getdate(),getdate(),getdate(),@shouldqueue,'YGC',@queuetype,'Qlevel changed via YGC PCODE')
	
		END
	END
END
END

IF(@recallaccount is not null and @recallaccount = 1)
BEGIN
DECLARE @AIMAgencyID INT
SET @AIMAgencyID = 0
SELECT @AIMAgencyID = AR.CurrentlyPlacedAgencyID
FROM AIM_AccountReference AR WITH (NOLOCK)
WHERE ReferenceNumber = @ACCOUNTID

IF(@AIMAgencyID > 0)
BEGIN
update  AIM_accountreference set 
			isPlaced = 0,lastrecalldate = getdate(),expectedpendingrecalldate = null,
			expectedfinalrecalldate = null,currentlyplacedagencyid = null,numdaysplacedbeforepending = null,
			numdaysplacedafterpending = null,currentcommissionpercentage = null,feeschedule = null,
			LastTier = A.AgencyTier,
            ObjectionFlag = 0
	from	AIM_accountreference ar with (nolock) JOIN AIM_Agency A WITH (NOLOCK) ON ar.CurrentlyPlacedAgencyID = A.AgencyID
	where	referencenumber = @AccountID

	--deactivate PDT transactions
	UPDATE AIM_PostDatedTransaction
	SET Active = 0
	WHERE AccountID = @AccountID
END

UPDATE master SET aimagency = null, aimassigned = null, feecode = null,attorneyid = null,assignedattorney = null,attorneystatus = 'Recalled' where number = @ACCOUNTID
INSERT INTO NOTES (number,action,result,created,comment)
VALUES(@ACCOUNTID,'YGC','YGC',getdate(),'Account was recalled as a Message with code ' + @PCODE + ' was processed.')
END

IF(@Conflict = 1)
BEGIN
	SELECT @olddesk = desk,@oldstatus = status,@oldqlevel = qlevel FROM master WITH (NOLOCK) WHERE number = @ACCOUNTID

	DECLARE @conflictQlevel varchar(3)
	SELECT @conflictQlevel = StringValue FROM GlobalSettings WHERE NameSpace = 'YGC' AND SettingName = 'YGC Conflict Queue'
	UPDATE Master SET Qlevel = @conflictQlevel WHERE number = @ACCOUNTID

	IF(@conflictQlevel BETWEEN '600' AND '799')
	BEGIN
		
		IF(@oldqlevel NOT BETWEEN '600' AND '799')
			BEGIN
			SET @shouldqueue = 0
			END
		ELSE
			BEGIN
			SET @shouldqueue = 1
			END
	
		IF(@qlevel BETWEEN '600' AND '699')
			BEGIN
			SET @queuetype = 0
			END
		ELSE
			BEGIN
			SET @queuetype = 1
			END

		INSERT INTO SupportQueueItems (QueueCode,AccountID,DateAdded,DateDue,LastAccessed,ShouldQueue,UserName,QueueType,Comment)
		VALUES (@conflictQlevel,@ACCOUNTID,getdate(),getdate(),getdate(),@shouldqueue,'YGC',@queuetype,'Qlevel changed via Conflicting YGC PCODES')

	END
END
	-- Changed by KAR on 05/19/2011 if receiving the Ack P:CODE and not a recall then Update AIM_AccountReference
	-- modify dbo.Lib_Insert_LatitudeLegal_Messages and update the AIM_AccountReference.AgencyAcknowledgement = 1 for the account if the PCODE = "*CC:S101"
	IF(@PCODE ='*CC:S101' AND (@recallaccount is null or @recallaccount = 0))
	BEGIN
		DECLARE @AIMAgencyID2 INT
		SET @AIMAgencyID2 = 0
		SELECT @AIMAgencyID2 = AR.CurrentlyPlacedAgencyID
		FROM AIM_AccountReference AR WITH (NOLOCK)
		WHERE ReferenceNumber = @ACCOUNTID
		IF(@AIMAgencyID2 > 0)
		BEGIN		
			update  AIM_accountreference 
			set AgencyAcknowledgement = 1 
			where referencenumber = @AccountID
		END
	END


END

GO
