SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[StairStepPopulateHeader]
AS
BEGIN
      WITH  CTE_DateDimension
              AS (SELECT DISTINCT
                    FiscalYear,
                    FiscalMonth,
                    FiscalFirstDayOfMonth
                  FROM
                    dbo.DateDimension)
           INSERT INTO dbo.StairStepHeader
                    (
                     customer,
                     PlacementDate,
                     PlacementNumber,
                     DollarsPlacedAmount
                    )
           SELECT
            M.customer,
            DD.FiscalFirstDayOfMonth AS PlacementDate,
            COUNT(1) AS PlacementNumber,
            SUM(M.original) AS DollarsPlacedAmount
           FROM
            dbo.master AS M
            INNER JOIN dbo.status AS S
                ON M.status = S.code
            INNER JOIN CTE_DateDimension AS DD
                ON M.sysmonth = DD.FiscalMonth AND
                   M.SysYear = DD.FiscalYear
           WHERE
            NOT EXISTS ( SELECT
                            1
                         FROM
                            dbo.StairStepHeader AS SH
                         WHERE
                            M.customer = SH.Customer AND
                            DD.FiscalFirstDayOfMonth = SH.PlacementDate )
           GROUP BY
            M.customer,
            DD.FiscalFirstDayOfMonth;
END;
GO
