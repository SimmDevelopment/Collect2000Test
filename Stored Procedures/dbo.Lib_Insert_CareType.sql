SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Insert_CareType]
(
      @CareTypeId   int output,
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


insert into dbo.CareType
(

      [CODE],
      [ONHOLDDAYS],
      [SEVERITY],
      [PROOFREQUIRED],
      [DESCRIPTION],
      [CONSENTREQUIRED],
      [CREATEDWHEN],
      [CREATEDBY],
      [MODIFIEDWHEN],
      [MODIFIEDBY]
)
values
(
      @CODE,
      @ONHOLDDAYS,
      @SEVERITY,
      @PROOFREQUIRED,
      @DESCRIPTION,
      @CONSENTREQUIRED,
      @CREATEDWHEN,
      @CREATEDBY,
      @MODIFIEDWHEN,
      @MODIFIEDBY
)

select @CareTypeId = SCOPE_IDENTITY()
end

GO
