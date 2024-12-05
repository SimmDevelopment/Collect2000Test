SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Update_FinancialHardship]
(
      @FINANCIALHARDSHIPID   int,
      @CODE   varchar (20),
      @DESCRIPTION   varchar (8000),
      @PROOFREQUIRED   bit,
      @ONHOLDDAYS   int,
      @CREATEDWHEN   datetime,
      @CREATEDBY   varchar (255),
      @MODIFIEDWHEN   datetime,
      @MODIFIEDBY   varchar (255)
)
as
begin


update dbo.FinancialHardship set
      [CODE] = @CODE,
      [DESCRIPTION] = @DESCRIPTION,
      [PROOFREQUIRED] = @PROOFREQUIRED,
      [ONHOLDDAYS] = @ONHOLDDAYS,
      [CREATEDWHEN] = @CREATEDWHEN,
      [CREATEDBY] = @CREATEDBY,
      [MODIFIEDWHEN] = @MODIFIEDWHEN,
      [MODIFIEDBY] = @MODIFIEDBY
where [FINANCIALHARDSHIPID] = @FINANCIALHARDSHIPID

end


GO
