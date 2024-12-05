SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Custom_ReversePaymentSign](@amount money, @batchType varchar(5))
RETURNS money
AS

BEGIN

	RETURN CASE RIGHT(@batchType, 1) WHEN 'R' THEN -@amount ELSE @amount END

END
GO
