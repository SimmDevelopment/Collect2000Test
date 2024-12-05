SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [dbo].[Lib_Update_extradata]
(
      @NUMBER   int,
      @CTL   varchar (3),
      @EXTRACODE   varchar (2),
      @LINE1   varchar (128),
      @LINE2   varchar (128),
      @LINE3   varchar (128),
      @LINE4   varchar (128),
      @LINE5   varchar (128)
)
as
begin

IF NOT EXISTS (SELECT * FROM extradata where number = @NUMBER and extracode = @EXTRACODE)
	EXECUTE [dbo].[Lib_Insert_extradata] @NUMBER,@CTL,@EXTRACODE,@LINE1,@LINE2,@LINE3,@LINE4,@LINE5

ELSE

	update dbo.extradata set
		CTL = @CTL,
		EXTRACODE = @EXTRACODE,
		LINE1 = @LINE1,
		LINE2 = @LINE2,
		LINE3 = @LINE3,
		LINE4 = @LINE4,
		LINE5 = @LINE5
	where NUMBER = @NUMBER
	and extracode = @EXTRACODE

end
GO
