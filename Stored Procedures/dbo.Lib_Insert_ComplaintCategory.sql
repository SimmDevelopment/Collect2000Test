SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Insert_ComplaintCategory]
(
      @ComplaintCategoryId   int output,
      @CODE   varchar (20),
      @DESCRIPTION   varchar (8000),
      @SLADAYS   int,
      @PRIORITY   int,
      @CREATEDWHEN   datetime,
      @CREATEDBY   varchar (255),
      @MODIFIEDWHEN   datetime,
      @MODIFIEDBY   varchar (255)
)
as
begin


insert into dbo.ComplaintCategory
(

      [CODE],
      [DESCRIPTION],
      [SLADAYS],
      [PRIORITY],
      [CREATEDWHEN],
      [CREATEDBY],
      [MODIFIEDWHEN],
      [MODIFIEDBY]
)
values
(
      @CODE,
      @DESCRIPTION,
      @SLADAYS,
      @PRIORITY,
      @CREATEDWHEN,
      @CREATEDBY,
      @MODIFIEDWHEN,
      @MODIFIEDBY
)

select @ComplaintCategoryId = SCOPE_IDENTITY()
end

GO
