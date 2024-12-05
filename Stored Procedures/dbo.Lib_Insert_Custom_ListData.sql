SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Insert_Custom_ListData]
(
      @ID   int output,
      @LISTCODE   varchar (10),
      @CODE   varchar (255),
      @DESCRIPTION   varchar (255),
      @SYSCODE   bit,
      @CREATEDBY   varchar (30),
      @UPDATEDBY   varchar (30),
      @CREATEDWHEN   datetime,
      @UPDATEDWHEN   datetime,
      @ENABLED   bit
)
as
begin


insert into dbo.Custom_ListData
(
      [LISTCODE],
      [CODE],
      [DESCRIPTION],
      [SYSCODE],
      [CREATEDBY],
      [UPDATEDBY],
      [CREATEDWHEN],
      [UPDATEDWHEN],
      [ENABLED]
)
values
(
      @LISTCODE,
      @CODE,
      @DESCRIPTION,
      @SYSCODE,
      @CREATEDBY,
      @UPDATEDBY,
      @CREATEDWHEN,
      @UPDATEDWHEN,
      @ENABLED
)

select @ID = SCOPE_IDENTITY()
end


GO
