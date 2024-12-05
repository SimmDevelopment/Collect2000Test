SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Update_Custom_ListData]
(
      @ID   int,
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


update dbo.Custom_ListData set
      [LISTCODE] = @LISTCODE,
      [CODE] = @CODE,
      [DESCRIPTION] = @DESCRIPTION,
      [SYSCODE] = @SYSCODE,
      [CREATEDBY] = @CREATEDBY,
      [UPDATEDBY] = @UPDATEDBY,
      [CREATEDWHEN] = @CREATEDWHEN,
      [UPDATEDWHEN] = @UPDATEDWHEN,
      [ENABLED] = @ENABLED
where [ID] = @ID

end


GO
