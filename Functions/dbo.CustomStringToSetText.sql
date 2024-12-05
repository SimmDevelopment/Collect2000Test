SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*   User Defined Function dbo.AIM_CalculatePortfolioValue    */
CREATE FUNCTION [dbo].[CustomStringToSetText] (
 @TargetString  varchar(8000),
 @SearchChar varchar(1)
 )
RETURNS @Set TABLE (
 --idPos  smallint not null identity,
 string int null
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
   INSERT @Set( string ) VALUES (CAST(SUBSTRING( @TargetString, @LastSearchCharPos + 1, DATALENGTH( @TargetString ) ) as int))
   BREAK
  END
  ELSE
   INSERT @Set( string) VALUES (CAST( SUBSTRING( @TargetString, @LastSearchCharPos + 1, @SearchCharPos - @LastSearchCharPos - 1 ) as int))
 END
 RETURN
END
GO
