SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FormatAsPhoneNumber]
(
	@Number VARCHAR(30),
	@Extn VARCHAR(10)
)
RETURNS varchar(30)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @retNumber varchar(30)

	-- Add the T-SQL statements to compute the return value here
	if(len(@Number) = 7)
	begin
		set @retNumber = '(000) ' + substring(@number,1,3) + '-' + substring(@number,4,4)
	end
	else if(len(@number) = 10)
	begin
		set @retNumber = '(' + SUBSTRING(@number, 1,3) + ') ' +  substring(@number,4,3) + '-' + substring(@number,7,4)
	end
	else if(len(@number) = 11 and SUBSTRING(@number,1,1) = '1')
	begin
		set @retNumber = '(' + SUBSTRING(@number, 2,3) + ') ' +  substring(@number,5,3) + '-' + substring(@number,8,4)
	end
	else
	begin
		set @retNumber = @Number;
	end

	if(@Extn IS NOT NULL AND LTRIM(RTRIM(@Extn)) != '')
	BEGIN
		set @retNumber = @retNumber + ' x.' + LTRIM(RTRIM(@Extn))
	END

	-- Return the result of the function
	RETURN @retNumber

END

GO
