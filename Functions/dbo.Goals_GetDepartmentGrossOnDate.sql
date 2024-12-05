SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Goals_GetDepartmentGrossOnDate](@ManagerID INT, @Date DATETIME) RETURNS MONEY
AS
BEGIN

    DECLARE @paid1 MONEY,@paid2 MONEY,@paid3 MONEY,@paid4 MONEY,@paid5 MONEY,@paid6 MONEY,@paid7 MONEY,@paid8 MONEY,@paid9 MONEY,@paid10 MONEY
    DECLARE @dccPaid MONEY, @pdcPaid MONEY
    DECLARE @DateYear INT, @DateMonth INT
    
    SET @DateYear = YEAR(@Date)
    SET @DateMonth = MONTH(@Date)

    SELECT @paid1 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid1 ELSE paid1 END) ELSE 0 END), 0)
        ,@paid2 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid2 ELSE paid2 END) ELSE 0 END), 0)
        ,@paid3 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid3 ELSE paid3 END) ELSE 0 END), 0)
        ,@paid4 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid4 ELSE paid4 END) ELSE 0 END), 0)
        ,@paid5 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid5 ELSE paid5 END) ELSE 0 END), 0)
        ,@paid6 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid6 ELSE paid6 END) ELSE 0 END), 0)
        ,@paid7 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid7 ELSE paid7 END) ELSE 0 END), 0)
        ,@paid8 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid8 ELSE paid8 END) ELSE 0 END), 0)
        ,@paid9 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid9 ELSE paid9 END) ELSE 0 END), 0)
        ,@paid10 = ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid10 ELSE paid10 END) ELSE 0 END), 0)
    FROM payhistory  WITH(NOLOCK)
    JOIN desk on desk.code = payhistory.desk
    JOIN teams on teams.ID = desk.TeamID
    JOIN departments dpt ON dpt.ID = teams.DepartmentID
    WHERE entered <= @Date
      -- jjh: switch from entered to systemyear
      and systemyear=year(@date) -- AND YEAR(entered) = Year(@Date)
      and systemmonth=month(@date) -- AND MONTH(entered) = MONTH(@Date)
      AND ManagerID = @ManagerID	
    
    SELECT @dccPaid = ISNULL(SUM(dcc.Amount), 0)
    FROM desk
    JOIN [master] M WITH(NOLOCK) ON M.desk = desk.code
    JOIN DebtorCreditCards DCC WITH(NOLOCK) ON DCC.number = M.number
    JOIN Teams ON Teams.ID = desk.TeamID
    JOIN Departments dpt ON dpt.ID = Teams.DepartmentID
    WHERE YEAR(DepositDate) = @DateYear
      AND MONTH(DepositDate) = @DateMonth
      AND IsActive = 1
      AND ManagerID = @ManagerID

    SELECT @pdcPaid = ISNULL(SUM(pdc.Amount), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    JOIN Departments dpt ON dpt.ID = Teams.DepartmentID
    WHERE YEAR(Deposit) = YEAR(@Date) 
      AND MONTH(Deposit) = MONTH(@Date) 
      AND Active = 1
      AND ManagerID = @ManagerID
    
    RETURN (@paid1 + @paid2 + @paid3 + @paid4 + @paid5 + @paid6 + @paid7 + @paid8 + @paid9 + @paid10 + @dccPaid + @pdcPaid)
END

GO