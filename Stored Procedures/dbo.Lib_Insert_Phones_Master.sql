SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Insert_Phones_Master]
(
      @MasterPhoneID   int output,
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
SET @PhoneStatusID=ISNULL(@PhoneStatusID,0)

--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
insert into dbo.Phones_Master
(
      [NUMBER],
      [PHONETYPEID],
      [RELATIONSHIP],
      [PHONESTATUSID],
      [ONHOLD],
      [PHONENUMBER],
      [PHONEEXT],
      [DEBTORID],
      [DATEADDED],
      [REQUESTID],
      [PHONENAME],
      [LOGINNAME],
      [NEARBYCONTACTID],
	  [LASTUPDATED],
	  [UPDATEDBY]
)
values
(
      @NUMBER,
      @PHONETYPEID,
      @RELATIONSHIP,
      @PHONESTATUSID,
      @ONHOLD,
      @PHONENUMBER,
      @PHONEEXT,
      @DEBTORID,
      @DATEADDED,
      @REQUESTID,
      @PHONENAME,
      @LOGINNAME,
      @NEARBYCONTACTID,
	  null,
	  null
)

select @MasterPhoneID = SCOPE_IDENTITY()

INSERT INTO Notes (number,ctl,created,user0,action,result,comment)
SELECT
@NUMBER,NULL,GETDATE(),'EXG','+++++','+++++',PhoneTypeDescription + ' ' + @PHONENUMBER + 
CASE WHEN @PHONEEXT IS NOT NULL AND @PHONEEXT <> '' THEN 'x. ' + @PHONEEXT ELSE '' END + ' added'
FROM Phones_Types WITH (NOLOCK) WHERE PhoneTypeID = @PHONETYPEID

end
GO
