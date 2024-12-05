SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_notes]
(
      @UID   int,
      @NUMBER   int,
      @CTL   varchar (3),
      @CREATED   datetime,
      @USER0   varchar (10),
      @ACTION   varchar (6),
      @RESULT   varchar (6),
      @COMMENT   text,
      @SEQ   int
)
as
begin


update dbo.notes set
      NUMBER = @NUMBER,
      CTL = @CTL,
      CREATED = @CREATED,
      USER0 = @USER0,
      ACTION = @ACTION,
      RESULT = @RESULT,
      COMMENT = @COMMENT,
      SEQ = @SEQ
where UID = @UID

end


GO
