SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Insert_Custom_Lists]
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


insert into dbo.Custom_Lists
(
      [LISTCODE],
      [DESCRIPTION],
      [DISPLAYNAME],
      [CODELENGTHMAX],
      [DESCLENGTHMAX],
      [CODEISNUMERIC],
      [CREATEDWHEN],
      [NAMESPACE]
)
values
(
      @LISTCODE,
      @DESCRIPTION,
      @DISPLAYNAME,
      @CODELENGTHMAX,
      @DESCLENGTHMAX,
      @CODEISNUMERIC,
      @CREATEDWHEN,
      @NAMESPACE
)

end


GO
