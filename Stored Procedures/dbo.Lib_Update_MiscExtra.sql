SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_MiscExtra]
(
      @NUMBER   int,
      @TITLE   varchar (30),
      @THEDATA   varchar (100),
      @ID   int
)
as
begin


update dbo.MiscExtra set
      TITLE = @TITLE,
      THEDATA = @THEDATA
where id=@id
--      ID = @ID
--where NUMBER = @NUMBER

end

GO
