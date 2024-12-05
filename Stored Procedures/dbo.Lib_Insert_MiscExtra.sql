SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE  procedure [dbo].[Lib_Insert_MiscExtra]
(
      @ID   int output,
      @NUMBER   int,
      @TITLE   varchar (30),
      @THEDATA   varchar (100)
)
as
begin


insert into dbo.MiscExtra
(
      NUMBER,
      TITLE,
      THEDATA
)
values
(
      @NUMBER,
      @TITLE,
      @THEDATA
)

select @ID = SCOPE_IDENTITY()
end


GO
