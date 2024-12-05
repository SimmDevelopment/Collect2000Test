SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** Object:  User Defined Function dbo.ProperCase    Script Date: 4/11/2002 5:04:16 PM ******/
CREATE FUNCTION [dbo].[ProperCase]
(
--The string to be converted to proper case
@input varchar(8000)
)
--This function returns the proper case string of varchar type
RETURNS varchar(8000)
AS
BEGIN
 IF @input IS NULL
 BEGIN
  --Just return NULL if input string is NULL
  RETURN NULL
 END

 --Character variable declarations
 DECLARE @output varchar(8000)
 --Integer variable declarations
 DECLARE @ctr int, @len int, @found_at int
 --Constant declarations
 DECLARE @LOWER_CASE_a int, @LOWER_CASE_z int, @WHITE_SPACE char

 --Variable/Constant initializations
 SET @ctr = 1
 SET @len = LEN(@input)
 SET @output = ''
 SET @LOWER_CASE_a = 97
 SET @LOWER_CASE_z = 122
 SET @WHITE_SPACE = ' '
 SET @input = LOWER(@input)

 WHILE @ctr <= @len
 BEGIN
  --This loop will take care of reccuring white spaces
  WHILE SUBSTRING(@input,@ctr,1) = @WHITE_SPACE
  BEGIN
   SET @output = @output + SUBSTRING(@input,@ctr,1)
   SET @ctr = @ctr + 1
  END

  IF ASCII(SUBSTRING(@input,@ctr,1)) BETWEEN @LOWER_CASE_a AND @LOWER_CASE_z
  BEGIN
   --Converting the first character to upper case
   SET @output = @output + UPPER(SUBSTRING(@input,@ctr,1))
  END
  ELSE
  BEGIN
   SET @output = @output + SUBSTRING(@input,@ctr,1)
  END

  SET @ctr = @ctr + 1

  --Jumping to the beginning of next word
  SET @found_at = CHARINDEX(@WHITE_SPACE,@input,@ctr)
  IF @found_at <> 0
  BEGIN
   SET @output = @output + SUBSTRING(@input,@ctr,@found_at - @ctr)
   SET @ctr = @found_at
  END
  ELSE
  BEGIN
   SET @output = @output + SUBSTRING(@input,@ctr,(@len-@ctr) + 1)
   SET @ctr = @len + 1
  END


 END
RETURN @output
END
GO
