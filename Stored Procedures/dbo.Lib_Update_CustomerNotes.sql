SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Lib_Update_CustomerNotes]
(
      @NUMBER   int,
      @SEQ   int,
      @NOTEDATE   datetime,
      @NOTETEXT   char (255)
)
as
begin


update dbo.CustomerNotes set
      SEQ = @SEQ,
      NOTEDATE = @NOTEDATE,
      NOTETEXT = @NOTETEXT
where NUMBER = @NUMBER

end
GO
