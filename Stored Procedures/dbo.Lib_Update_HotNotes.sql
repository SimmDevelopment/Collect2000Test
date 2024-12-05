SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_HotNotes]
(
      @NUMBER   int,
      @HOTNOTE   text
)
as
begin


update dbo.HotNotes set
      HOTNOTE = @HOTNOTE
where NUMBER = @NUMBER

end
--
GO
