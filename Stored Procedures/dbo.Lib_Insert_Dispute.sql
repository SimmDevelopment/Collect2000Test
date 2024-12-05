SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Lib_Insert_Dispute]
(
      @DisputeId   int output,
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


insert into dbo.Dispute
(

      [NUMBER],
	  [DEBTORID],
      [DOCUMENTATIONID],
      [TYPE],
      [DATERECEIVED],
      [REFERREDBY],
      [DETAILS],
      [CATEGORY],
      [AGAINST],
      [DATECLOSED],
      [RECOURSEDATE],
      [JUSTIFIED],
      [OUTCOME],
      [DELETED],
      [PROOFREQUIRED],
      [PROOFREQUESTED],
      [INSUFFICIENTPROOFRECEIVED],
      [PROOFRECEIVED],
      [CREATEDWHEN],
      [CREATEDBY],
      [MODIFIEDWHEN],
      [MODIFIEDBY]
)
values
(
      @NUMBER,
	  @DEBTORID,
      @DOCUMENTATIONID,
      @TYPE,
      @DATERECEIVED,
      @REFERREDBY,
      @DETAILS,
      @CATEGORY,
      @AGAINST,
      @DATECLOSED,
      @RECOURSEDATE,
      @JUSTIFIED,
      @OUTCOME,
      @DELETED,
      @PROOFREQUIRED,
      @PROOFREQUESTED,
      @INSUFFICIENTPROOFRECEIVED,
      @PROOFRECEIVED,
      @CREATEDWHEN,
      @CREATEDBY,
      @MODIFIEDWHEN,
      @MODIFIEDBY
)

select @DisputeId = SCOPE_IDENTITY()
end
GO
