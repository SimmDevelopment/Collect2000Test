SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Update_Custom_Lists]
(
      @LISTCODE   varchar (10),
      @DESCRIPTION   varchar (255),
      @DISPLAYNAME   varchar (50),
      @CODELENGTHMAX   int,
      @DESCLENGTHMAX   int,
      @CODEISNUMERIC   bit,
      @CREATEDWHEN   datetime,
      @NAMESPACE   varchar (25)
)
as
begin


update dbo.Custom_Lists set
      [DESCRIPTION] = @DESCRIPTION,
      [DISPLAYNAME] = @DISPLAYNAME,
      [CODELENGTHMAX] = @CODELENGTHMAX,
      [DESCLENGTHMAX] = @DESCLENGTHMAX,
      [CODEISNUMERIC] = @CODEISNUMERIC,
      [CREATEDWHEN] = @CREATEDWHEN,
      [NAMESPACE] = @NAMESPACE
where [LISTCODE] = @LISTCODE

end


GO
