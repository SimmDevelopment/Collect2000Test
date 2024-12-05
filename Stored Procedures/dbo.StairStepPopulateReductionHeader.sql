SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[StairStepPopulateReductionHeader]
AS
BEGIN
      WITH  CTE_DateDimension
              AS (SELECT DISTINCT
                    FiscalYear,
                    FiscalMonth,
                    FiscalFirstDayOfMonth
                  FROM
                    dbo.DateDimension)
           MERGE dbo.StairStepReductionHeader AS RH
           USING
            (SELECT
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
                S.ReduceStats = 1 AND
                NOT EXISTS ( SELECT
                                1
                             FROM
                                dbo.StairStepReductionHeader AS SH
                             WHERE
                                M.customer = SH.Customer AND
                                DD.FiscalFirstDayOfMonth = SH.PlacementDate )
             GROUP BY
                M.customer,
                DD.FiscalFirstDayOfMonth) AS NEW
           ON (
               RH.Customer = NEW.customer AND
               RH.PlacementDate = NEW.PlacementDate
              )
           WHEN NOT MATCHED BY TARGET THEN
            INSERT
                   (
                    customer,
                    PlacementDate,
                    PlacementNumber,
                    DollarsPlacedAmount
                   )
            VALUES (
                    NEW.customer,
                    NEW.PlacementDate,
                    NEW.PlacementNumber,
                    NEW.DollarsPlacedAmount
                   )
           WHEN MATCHED AND (
                             RH.PlacementNumber != NEW.PlacementNumber OR
                             RH.DollarsPlacedAmount != NEW.DollarsPlacedAmount
                            ) THEN
            UPDATE SET
                    RH.PlacementNumber = NEW.PlacementNumber,
                    RH.DollarsPlacedAmount = NEW.DollarsPlacedAmount
					
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE;
END;
GO
