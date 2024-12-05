SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Insert_CustomerNotes]
(
      @NUMBER   int,
      @SEQ   int,
      @NOTEDATE   datetime,
      @NOTETEXT   char (255)
)
as
begin


insert into dbo.CustomerNotes
(
      NUMBER,
      SEQ,
      NOTEDATE,
      NOTETEXT
)
values
(
      @NUMBER,
      @SEQ,
      @NOTEDATE,
      @NOTETEXT
)

end

GO
