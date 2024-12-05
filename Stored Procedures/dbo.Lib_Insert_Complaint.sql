SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Insert_Complaint]
(
      @ComplaintId   int output,
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


insert into dbo.Complaint
(
      [ACCOUNTID],
      [DEBTORID],
      [DOCUMENTATIONID],
      [DATEINADMIN],
      [DATERECEIVED],
      [SLADAYS],
      [OWNER],
      [REFERREDBY],
      [DETAILS],
      [STATUS],
      [CATEGORY],
      [TYPE],
      [AGAINSTTYPE],
      [AGAINST],
      [INVESTIGATIONCOMMENTSTODATE],
      [CONCLUSION],
      [DATECLOSED],
      [OUTCOME],
      [JUSTIFIED],
      [COMPENSATIONAMOUNT],
      [ROOTCAUSE],
      [RECOURSEDATE],
      [DISSATISFACTION],
      [DISSATISFACTIONDATE],
      [GRIEVANCES],
      [DELETED],
      [CREATEDWHEN],
      [CREATEDBY],
      [MODIFIEDWHEN],
      [MODIFIEDBY]
)
SELECT
      @ACCOUNTID,
	  d.DebtorID,
      @DOCUMENTATIONID,
      @DATEINADMIN,
      @DATERECEIVED,
      @SLADAYS,
      @OWNER,
      @REFERREDBY,
      @DETAILS,
      @STATUS,
      @CATEGORY,
      @TYPE,
      @AGAINSTTYPE,
      @AGAINST,
      @INVESTIGATIONCOMMENTSTODATE,
      @CONCLUSION,
      @DATECLOSED,
      @OUTCOME,
      @JUSTIFIED,
      @COMPENSATIONAMOUNT,
      @ROOTCAUSE,
      @RECOURSEDATE,
      @DISSATISFACTION,
      @DISSATISFACTIONDATE,
      @GRIEVANCES,
      @DELETED,
      @CREATEDWHEN,
      @CREATEDBY,
      @MODIFIEDWHEN,
      @MODIFIEDBY
FROM Debtors d WITH (NOLOCK) WHERE d.DebtorId = @DEBTORID

select @ComplaintId = SCOPE_IDENTITY()
end
GO
