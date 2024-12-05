SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Update_DisputeType]
(
      @DISPUTETYPEID   int,
      @CODE   varchar (10),
      @PROOFREQUIRED   bit,
      @DESCRIPTION   varchar (8000),
      @CREATEDWHEN   datetime,
      @CREATEDBY   varchar (255),
      @MODIFIEDWHEN   datetime,
      @MODIFIEDBY   varchar (255)
)
as
begin


update dbo.DisputeType set
      [CODE] = @CODE,
      [PROOFREQUIRED] = @PROOFREQUIRED,
      [DESCRIPTION] = @DESCRIPTION,
      [CREATEDWHEN] = @CREATEDWHEN,
      [CREATEDBY] = @CREATEDBY,
      [MODIFIEDWHEN] = @MODIFIEDWHEN,
      [MODIFIEDBY] = @MODIFIEDBY
where [DISPUTETYPEID] = @DISPUTETYPEID

end


GO
