SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[DetermineInvoicedAmount] (@InvoiceFlags CHAR(10), @Amount1 MONEY, @Amount2 MONEY, @Amount3 MONEY, @Amount4 MONEY, @Amount5 MONEY, @Amount6 MONEY, @Amount7 MONEY, @Amount8 MONEY, @Amount9 MONEY, @Amount10 MONEY)
RETURNS MONEY
WITH SCHEMABINDING
AS BEGIN

 DECLARE @Temp MONEY;
 SET @Temp = 0;

 IF @InvoiceFlags IS NULL OR LEN(LTRIM(RTRIM(@InvoiceFlags))) = 0 BEGIN
  RETURN 0;
 END;

 IF LEN(@InvoiceFlags) >= 1 AND SUBSTRING(@InvoiceFlags, 1, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount1;
 END;

 IF LEN(@InvoiceFlags) >= 2 AND SUBSTRING(@InvoiceFlags, 2, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount2;
 END;

 IF LEN(@InvoiceFlags) >= 3 AND SUBSTRING(@InvoiceFlags, 3, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount3;
 END;

 IF LEN(@InvoiceFlags) >= 4 AND SUBSTRING(@InvoiceFlags, 4, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount4;
 END;

 IF LEN(@InvoiceFlags) >= 5 AND SUBSTRING(@InvoiceFlags, 5, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount5;
 END;

 IF LEN(@InvoiceFlags) >= 6 AND SUBSTRING(@InvoiceFlags, 6, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount6;
 END;

 IF LEN(@InvoiceFlags) >= 7 AND SUBSTRING(@InvoiceFlags, 7, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount7;
 END;

 IF LEN(@InvoiceFlags) >= 8 AND SUBSTRING(@InvoiceFlags, 8, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount8;
 END;

 IF LEN(@InvoiceFlags) >= 9 AND SUBSTRING(@InvoiceFlags, 9, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount9;
 END;

 IF LEN(@InvoiceFlags) >= 10 AND SUBSTRING(@InvoiceFlags, 10, 1) <> '0' BEGIN
  SET @Temp = @Temp + @Amount10;
 END;
 RETURN @Temp;
END



GO
