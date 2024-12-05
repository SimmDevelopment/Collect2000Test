SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Custom_ConvertIBMSignedtoDecimal](@IBMSignedValue VARCHAR(8000))
RETURNS DECIMAL(10,2)
AS
BEGIN

-- Declare and Initialize the local variable.
DECLARE @ReturnValue  DECIMAL(10,2)
SET @ReturnValue = 0

SET @IBMSignedValue = LTRIM(RTRIM(@IBMSignedValue))

IF @IBMSignedValue <> ''
BEGIN
SET @ReturnValue = CASE UPPER(SUBSTRING(@IBMSignedValue, LEN(@IBMSignedValue),1))
                        WHEN '{' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) + '0'))/100
                        WHEN 'A' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) + '1'))/100
                        WHEN 'B' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '2'))/100
                        WHEN 'C' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '3'))/100
                        WHEN 'D' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '4'))/100
                        WHEN 'E' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '5'))/100
                        WHEN 'F' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '6'))/100
                        WHEN 'G' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '7'))/100
                        WHEN 'H' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '8'))/100
                        WHEN 'I' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '9'))/100
                        WHEN '}' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '0'))/(-100) --NEGATIVE VALUES
                        WHEN 'J' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '1'))/(-100) --NEGATIVE VALUES
                        WHEN 'K' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '2'))/(-100) --NEGATIVE VALUES
                        WHEN 'L' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '3'))/(-100) --NEGATIVE VALUES
                        WHEN 'M' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '4'))/(-100) --NEGATIVE VALUES
                        WHEN 'N' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '5'))/(-100) --NEGATIVE VALUES
                        WHEN 'O' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '6'))/(-100) --NEGATIVE VALUES
                        WHEN 'P' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '7'))/(-100) --NEGATIVE VALUES
                        WHEN 'Q' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '8'))/(-100) --NEGATIVE VALUES
                        WHEN 'R' THEN CONVERT(DECIMAL(10,2),(SUBSTRING(@IBMSignedValue, 1, LEN(@IBMSignedValue)-1) +  '9'))/(-100) --NEGATIVE VALUES
                   END

END

RETURN @ReturnValue
END
GO
