SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Goals_GetDeskFeesOnDate](@Desk VARCHAR(10), @Date DATETIME) RETURNS MONEY
AS
BEGIN

    DECLARE @fee1 MONEY,@fee2 MONEY,@fee3 MONEY,@fee4 MONEY,@fee5 MONEY,@fee6 MONEY,@fee7 MONEY,@fee8 MONEY,@fee9 MONEY,@fee10 MONEY
    DECLARE @dccFee MONEY, @pdcFee MONEY

    SELECT @fee1 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee1 ELSE fee1 END) ELSE 0 END), 0)
        ,@fee2 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee2 ELSE fee2 END) ELSE 0 END), 0)
        ,@fee3 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee3 ELSE fee3 END) ELSE 0 END), 0)
        ,@fee4 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee4 ELSE fee4 END) ELSE 0 END), 0)
        ,@fee5 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee5 ELSE fee5 END) ELSE 0 END), 0)
        ,@fee6 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee6 ELSE fee6 END) ELSE 0 END), 0)
        ,@fee7 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee7 ELSE fee7 END) ELSE 0 END), 0)
        ,@fee8 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee8 ELSE fee8 END) ELSE 0 END), 0)
        ,@fee9 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee9 ELSE fee9 END) ELSE 0 END), 0)
        ,@fee10 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee10 ELSE fee10 END) ELSE 0 END), 0)
    FROM payhistory WITH(NOLOCK) 	
    WHERE entered <= @Date
      -- jjh: switch from entered to systemyear
      and systemyear=year(@date) -- AND YEAR(entered) = Year(@Date)
      and systemmonth=month(@date) -- AND MONTH(entered) = MONTH(@Date)
      AND desk = @Desk	  

    SELECT
    @dccFee = ISNULL(SUM(projectedfee),0)
    FROM DebtorCreditCards DCC WITH (NOLOCK) 
    JOIN [Master] M WITH (NOLOCK) ON DCC.Number = M.Number
    WHERE YEAR(DepositDate) = YEAR(@Date) 
      AND MONTH(DepositDate) = MONTH(@Date) 
      AND Desk = @Desk
      AND IsActive = 1

    SELECT
    @pdcFee = ISNULL(SUM(projectedfee),0)
    FROM PDC WITH (NOLOCK) 
    WHERE YEAR(Deposit) = YEAR(@Date) 
      AND MONTH(Deposit) = MONTH(@Date) 
      AND Desk = @Desk
      AND Active = 1

    RETURN (@fee1 + @fee2 + @fee3 + @fee4 + @fee5 + @fee6 + @fee7 + @fee8 + @fee9 + @fee10 + @pdcFee + @dccFee)
END

GO
