SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Update_Phones_Master]
(
      @MASTERPHONEID   int,
      @NUMBER   int,
      @PHONETYPEID   int,
      @RELATIONSHIP   varchar (50),
      @PHONESTATUSID   int,
      @ONHOLD   bit,
      @PHONENUMBER   varchar (30),
      @PHONEEXT   varchar (10),
      @DEBTORID   int,
      @DATEADDED   datetime,
      @REQUESTID   int,
      @PHONENAME   varchar (50),
      @LOGINNAME   varchar (10),
      @NEARBYCONTACTID   int
)
as
begin


DECLARE @oldstatusid INT,@oldtypeid INT,@oldonhold BIT
SELECT
@oldstatusid = PhoneStatusID,
@oldtypeid = PhoneTypeID,
@oldonhold = OnHold
FROM Phones_Master WITH (NOLOCK) WHERE MasterPhoneID = @MASTERPHONEID
SET @PhoneStatusID=ISNULL(@PhoneStatusID,0)
--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
update dbo.Phones_Master set
      [NUMBER] = @NUMBER,
      [PHONETYPEID] = @PHONETYPEID,
      [RELATIONSHIP] = @RELATIONSHIP,
      [PHONESTATUSID] = @PHONESTATUSID,
      [ONHOLD] = @ONHOLD,
      [PHONENUMBER] = @PHONENUMBER,
      [PHONEEXT] = @PHONEEXT,
      [DEBTORID] = @DEBTORID,
      [DATEADDED] = @DATEADDED,
      [REQUESTID] = @REQUESTID,
      [PHONENAME] = @PHONENAME,
      [LOGINNAME] = @LOGINNAME,
      [NEARBYCONTACTID] = @NEARBYCONTACTID,
	  [LASTUPDATED] = GETDATE(),
	  [UPDATEDBY] ='EXG'
where [MASTERPHONEID] = @MASTERPHONEID

IF(@oldtypeid <> @PHONETYPEID)
BEGIN
	INSERT INTO NOTES (NUMBER,CREATED,USER0,[ACTION],RESULT,COMMENT)
	SELECT TOP 1
	@NUMBER,GETDATE(),'EXG','+++++','+++++',o.PhoneTypeDescription + ' ' + @PHONENUMBER + CASE WHEN @PHONEEXT IS NOT NULL AND @PHONEEXT <> '' THEN ' x. ' + @PHONEEXT ELSE '' END + ' changed to ' + n.PhoneTypeDescription
	FROM Phones_Types o WITH (NOLOCK), Phones_Types n WITH (NOLOCK)
	WHERE o.PhoneTypeID = @oldtypeid AND n.PhoneTypeID = @PHONETYPEID
END
IF(isnull(@oldstatusid,0) <> isnull(@PHONESTATUSID,0))
BEGIN
	DECLARE @newstatus varchar(50),@oldstatus varchar(50)
	SELECT @newstatus = PhoneStatusDescription FROM Phones_Statuses WHERE PhoneStatusID = @PHONESTATUSID
	SELECT @oldstatus = isnull(PhoneStatusDescription,'Unknown') FROM Phones_Statuses WHERE PhoneStatusID = @oldstatusid
	INSERT INTO NOTES (NUMBER,CREATED,USER0,[ACTION],RESULT,COMMENT)
	SELECT TOP 1
	@NUMBER,GETDATE(),'EXG','+++++','+++++',pt.PhoneTypeDescription + ' ' + @PHONENUMBER + CASE WHEN @PHONEEXT IS NOT NULL AND @PHONEEXT <> '' THEN ' x. ' + @PHONEEXT ELSE '' END + ' status changed from ' + isnull(@oldstatus,'Unknown') + ' to ' + isnull(@newstatus,'Unknown')
	FROM Phones_Types pt WITH (NOLOCK)
	WHERE pt.PhoneTypeID = @PHONETYPEID 
END
IF(ISNULL(@oldonhold,0) <> ISNULL(@ONHOLD,0))
BEGIN
	INSERT INTO NOTES (NUMBER,CREATED,USER0,[ACTION],RESULT,COMMENT)
	SELECT TOP 1
	@NUMBER,GETDATE(),'EXG','+++++','+++++',o.PhoneTypeDescription + ' ' + @PHONENUMBER + 
	CASE WHEN @PHONEEXT IS NOT NULL AND @PHONEEXT <> '' THEN ' x. ' + @PHONEEXT ELSE '' END + ' ' + CASE @ONHOLD WHEN 0 THEN ' on hold cleared' WHEN 1 THEN ' set on hold' END
	FROM Phones_Types o WITH (NOLOCK)
	WHERE o.PhoneTypeID = @PhoneTypeID
END
end
GO
