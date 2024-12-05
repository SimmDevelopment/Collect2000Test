SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Update_CareType]
(
      @CARETYPEID   int,
      @CODE   varchar (20),
      @ONHOLDDAYS   int,
      @SEVERITY   int,
      @PROOFREQUIRED   bit,
      @DESCRIPTION   varchar (8000),
      @CONSENTREQUIRED   bit,
      @CREATEDWHEN   datetime,
      @CREATEDBY   varchar (255),
      @MODIFIEDWHEN   datetime,
      @MODIFIEDBY   varchar (255)
)
as
begin


update dbo.CareType set
      [CODE] = @CODE,
      [ONHOLDDAYS] = @ONHOLDDAYS,
      [SEVERITY] = @SEVERITY,
      [PROOFREQUIRED] = @PROOFREQUIRED,
      [DESCRIPTION] = @DESCRIPTION,
      [CONSENTREQUIRED] = @CONSENTREQUIRED,
      [CREATEDWHEN] = @CREATEDWHEN,
      [CREATEDBY] = @CREATEDBY,
      [MODIFIEDWHEN] = @MODIFIEDWHEN,
      [MODIFIEDBY] = @MODIFIEDBY
where [CARETYPEID] = @CARETYPEID

end


GO
