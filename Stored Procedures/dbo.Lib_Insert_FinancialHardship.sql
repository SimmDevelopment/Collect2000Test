SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Insert_FinancialHardship]
(
      @FinancialHardshipId   int output,
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


insert into dbo.FinancialHardship
(
      [CODE],
      [DESCRIPTION],
      [PROOFREQUIRED],
      [ONHOLDDAYS],
      [CREATEDWHEN],
      [CREATEDBY],
      [MODIFIEDWHEN],
      [MODIFIEDBY]
)
values
(
      @CODE,
      @DESCRIPTION,
      @PROOFREQUIRED,
      @ONHOLDDAYS,
      @CREATEDWHEN,
      @CREATEDBY,
      @MODIFIEDWHEN,
      @MODIFIEDBY
)

select @FinancialHardshipId = SCOPE_IDENTITY()
end


GO
