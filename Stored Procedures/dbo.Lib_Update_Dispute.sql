SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Update_Dispute]
(
      @DISPUTEID   int,
      @NUMBER   int,
	  @DEBTORID   int,
      @DOCUMENTATIONID   uniqueidentifier,
      @TYPE   varchar (10),
      @DATERECEIVED   datetime,
      @REFERREDBY   varchar (10),
      @DETAILS   varchar (8000),
      @CATEGORY   varchar (10),
      @AGAINST   varchar (10),
      @DATECLOSED   datetime,
      @RECOURSEDATE   datetime,
      @JUSTIFIED   varchar (10),
      @OUTCOME   varchar (255),
      @DELETED   bit,
      @PROOFREQUIRED   bit,
      @PROOFREQUESTED   bit,
      @INSUFFICIENTPROOFRECEIVED   bit,
      @PROOFRECEIVED   bit,
      @CREATEDWHEN   datetime,
      @CREATEDBY   varchar (255),
      @MODIFIEDWHEN   datetime,
      @MODIFIEDBY   varchar (255)
)
as
begin


update dbo.Dispute set
      [NUMBER] = @NUMBER,
	  [DEBTORID] = @DEBTORID,
      [DOCUMENTATIONID] = @DOCUMENTATIONID,
      [TYPE] = @TYPE,
      [DATERECEIVED] = @DATERECEIVED,
      [REFERREDBY] = @REFERREDBY,
      [DETAILS] = @DETAILS,
      [CATEGORY] = @CATEGORY,
      [AGAINST] = @AGAINST,
      [DATECLOSED] = @DATECLOSED,
      [RECOURSEDATE] = @RECOURSEDATE,
      [JUSTIFIED] = @JUSTIFIED,
      [OUTCOME] = @OUTCOME,
      [DELETED] = @DELETED,
      [PROOFREQUIRED] = @PROOFREQUIRED,
      [PROOFREQUESTED] = @PROOFREQUESTED,
      [INSUFFICIENTPROOFRECEIVED] = @INSUFFICIENTPROOFRECEIVED,
      [PROOFRECEIVED] = @PROOFRECEIVED,
      [CREATEDWHEN] = @CREATEDWHEN,
      [CREATEDBY] = @CREATEDBY,
      [MODIFIEDWHEN] = @MODIFIEDWHEN,
      [MODIFIEDBY] = @MODIFIEDBY
where [DISPUTEID] = @DISPUTEID

end
GO
