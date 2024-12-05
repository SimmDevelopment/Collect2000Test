SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Goals_GetTeamGrossOnDate](@SupervisorID INT, @Date DATETIME) RETURNS MONEY
AS
BEGIN

    DECLARE @fee1 MONEY,@fee2 MONEY,@fee3 MONEY,@fee4 MONEY,@fee5 MONEY,@fee6 MONEY,@fee7 MONEY,@fee8 MONEY,@fee9 MONEY,@fee10 MONEY
    DECLARE @dccFee MONEY, @pdcFee MONEY
    DECLARE @DateYear INT, @DateMonth INT
    
    SET @DateYear = YEAR(@Date)
    SET @DateMonth = MONTH(@Date)

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
    JOIN desk on desk.code = payhistory.desk
    JOIN teams on teams.ID = desk.TeamID	
    WHERE entered <= @Date
      -- jjh: switch from entered to systemyear
      and systemyear=year(@date) -- AND YEAR(entered) = Year(@Date)
      and systemmonth=month(@date) -- AND MONTH(entered) = MONTH(@Date)
      AND SupervisorID = @SupervisorID

    SELECT @dccFee = ISNULL(SUM(dcc.ProjectedFee), 0)
    FROM desk
    JOIN [master] M WITH(NOLOCK) ON M.desk = desk.code
    JOIN DebtorCreditCards DCC WITH(NOLOCK) ON DCC.number = M.number
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(DepositDate) = @DateYear
      AND MONTH(DepositDate) = @DateMonth
      AND IsActive = 1
      AND SupervisorID = @SupervisorID

    SELECT @pdcFee = ISNULL(SUM(pdc.ProjectedFee), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(Deposit) = @DateYear
      AND MONTH(Deposit) = @DateMonth
      AND Active = 1
      AND SupervisorID = @SupervisorID

    RETURN (@fee1 + @fee2 + @fee3 + @fee4 + @fee5 + @fee6 + @fee7 + @fee8 + @fee9 + @fee10 + @dccFee + @pdcFee)
END

GO
