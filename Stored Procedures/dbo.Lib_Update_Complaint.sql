SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Update_Complaint]
(
      @COMPLAINTID   int,
	  @ACCOUNTID   int,
      @DEBTORID   int,
      @DOCUMENTATIONID   uniqueidentifier,
      @DATEINADMIN   datetime,
      @DATERECEIVED   datetime,
      @SLADAYS   int,
      @OWNER   varchar (10),
      @REFERREDBY   varchar (10),
      @DETAILS   varchar (8000),
      @STATUS   varchar (10),
      @CATEGORY   varchar (20),
      @TYPE   varchar (10),
      @AGAINSTTYPE   varchar (255),
      @AGAINST   varchar (255),
      @INVESTIGATIONCOMMENTSTODATE   varchar (8000),
      @CONCLUSION   varchar (8000),
      @DATECLOSED   datetime,
      @OUTCOME   varchar (10),
      @JUSTIFIED   varchar (10),
      @COMPENSATIONAMOUNT   money,
      @ROOTCAUSE   varchar (10),
      @RECOURSEDATE   datetime,
      @DISSATISFACTION   bit,
      @DISSATISFACTIONDATE   datetime,
      @GRIEVANCES   varchar (8000),
      @DELETED   bit,
      @CREATEDWHEN   datetime,
      @CREATEDBY   varchar (255),
      @MODIFIEDWHEN   datetime,
      @MODIFIEDBY   varchar (255)
)
as
begin


update dbo.Complaint set
	  [ACCOUNTID] = @ACCOUNTID,
      [DEBTORID] = @DEBTORID,
      [DOCUMENTATIONID] = @DOCUMENTATIONID,
      [DATEINADMIN] = @DATEINADMIN,
      [DATERECEIVED] = @DATERECEIVED,
      [SLADAYS] = @SLADAYS,
      [OWNER] = @OWNER,
      [REFERREDBY] = @REFERREDBY,
      [DETAILS] = @DETAILS,
      [STATUS] = @STATUS,
      [CATEGORY] = @CATEGORY,
      [TYPE] = @TYPE,
      [AGAINSTTYPE] = @AGAINSTTYPE,
      [AGAINST] = @AGAINST,
      [INVESTIGATIONCOMMENTSTODATE] = @INVESTIGATIONCOMMENTSTODATE,
      [CONCLUSION] = @CONCLUSION,
      [DATECLOSED] = @DATECLOSED,
      [OUTCOME] = @OUTCOME,
      [JUSTIFIED] = @JUSTIFIED,
      [COMPENSATIONAMOUNT] = @COMPENSATIONAMOUNT,
      [ROOTCAUSE] = @ROOTCAUSE,
      [RECOURSEDATE] = @RECOURSEDATE,
      [DISSATISFACTION] = @DISSATISFACTION,
      [DISSATISFACTIONDATE] = @DISSATISFACTIONDATE,
      [GRIEVANCES] = @GRIEVANCES,
      [DELETED] = @DELETED,
      [CREATEDWHEN] = @CREATEDWHEN,
      [CREATEDBY] = @CREATEDBY,
      [MODIFIEDWHEN] = @MODIFIEDWHEN,
      [MODIFIEDBY] = @MODIFIEDBY
where [COMPLAINTID] = @COMPLAINTID

end
GO
