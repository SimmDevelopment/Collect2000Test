SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  User Defined Function dbo.StringToNumSet    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE FUNCTION [dbo].[StringToNumSet] (
 @TargetString  varchar(8000),
 @SearchChar varchar(1)
 )
RETURNS @Set TABLE (
 num int not null
 )
AS
BEGIN
 DECLARE @SearchCharPos  smallint,  @LastSearchCharPos smallint
 SET @SearchCharPos = 0
 WHILE 1=1
 BEGIN
  SET @LastSearchCharPos = @SearchCharPos
  SET @SearchCharPos = CHARINDEX( @SearchChar, @TargetString, @SearchCharPos + 1 )
  IF @SearchCharPos = 0
  BEGIN
   INSERT @Set( num ) VALUES ( SUBSTRING( @TargetString, @LastSearchCharPos + 1, DATALENGTH( @TargetString ) ) )
   BREAK
  END
  ELSE
   INSERT @Set( num ) VALUES ( SUBSTRING( @TargetString, @LastSearchCharPos + 1, @SearchCharPos - @LastSearchCharPos - 1 ) )
 END
 RETURN
END
GO
