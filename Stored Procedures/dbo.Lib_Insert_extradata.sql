SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Insert_extradata]
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


insert into dbo.extradata
(
      NUMBER,
      CTL,
      EXTRACODE,
      LINE1,
      LINE2,
      LINE3,
      LINE4,
      LINE5
)
values
(
      @NUMBER,
      @CTL,
      @EXTRACODE,
      @LINE1,
      @LINE2,
      @LINE3,
      @LINE4,
      @LINE5
)

end
GO
