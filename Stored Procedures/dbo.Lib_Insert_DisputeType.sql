SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Insert_DisputeType]
(
      @DisputeTypeId   int output,
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


insert into dbo.DisputeType
(

      [CODE],
      [PROOFREQUIRED],
      [DESCRIPTION],
      [CREATEDWHEN],
      [CREATEDBY],
      [MODIFIEDWHEN],
      [MODIFIEDBY]
)
values
(
      @CODE,
      @PROOFREQUIRED,
      @DESCRIPTION,
      @CREATEDWHEN,
      @CREATEDBY,
      @MODIFIEDWHEN,
      @MODIFIEDBY
)

select @DisputeTypeId = SCOPE_IDENTITY()
end

GO
