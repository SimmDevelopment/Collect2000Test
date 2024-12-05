SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[StairStepPopulateReductionDetail]
AS
BEGIN

      WITH  CTE_DateDimension
              AS (SELECT DISTINCT
                    FiscalYear,
                    FiscalMonth,
                    FiscalFirstDayOfMonth
                  FROM
                    dbo.DateDimension),
            CTE_PayHistory
              AS (SELECT
                    PH.number,
                    DD.FiscalFirstDayOfMonth AS TransactionDate,
                    SUM(CASE WHEN PH.batchtype LIKE 'P%'
                             THEN CASE WHEN PH.batchtype LIKE '%r'
                                       THEN -((PH.paid1 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 1, 1))) +
                                              (PH.paid2 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 2, 1))) +
                                              (PH.paid3 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 3, 1))) +
                                              (PH.paid4 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 4, 1))) +
                                              (PH.paid5 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 5, 1))) +
                                              (PH.paid6 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 6, 1))) +
                                              (PH.paid7 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 7, 1))) +
                                              (PH.paid8 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 8, 1))) +
                                              (PH.paid9 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 9, 1))) +
                                              (PH.paid10 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 10, 1))))
                                       ELSE ((PH.paid1 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 1, 1))) + (PH.paid2 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        2, 1))) +
                                             (PH.paid3 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 3, 1))) + (PH.paid4 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        4, 1))) +
                                             (PH.paid5 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 5, 1))) + (PH.paid6 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        6, 1))) +
                                             (PH.paid7 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 7, 1))) + (PH.paid8 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        8, 1))) +
                                             (PH.paid9 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 9, 1))) +
                                             (PH.paid10 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 10, 1))))
                                  END
                             ELSE 0
                        END) AS InvoiceableTotalPaidAmount,
                    SUM(CASE WHEN PH.batchtype LIKE 'P%' THEN CASE WHEN PH.batchtype LIKE '%r' THEN -PH.totalpaid
                                                                   ELSE PH.totalpaid
                                                              END
                             ELSE 0
                        END) AS TotalPaidAmount,
                    SUM(CASE WHEN PH.batchtype LIKE 'P%'
                             THEN CASE WHEN PH.batchtype LIKE '%r'
                                       THEN -((PH.fee1 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 1, 1))) + (PH.fee2 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        2, 1))) +
                                              (PH.fee3 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 3, 1))) + (PH.fee4 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        4, 1))) +
                                              (PH.fee5 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 5, 1))) + (PH.fee6 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        6, 1))) +
                                              (PH.fee7 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 7, 1))) + (PH.fee8 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        8, 1))) +
                                              (PH.fee9 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 9, 1))) + (PH.fee10 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        10, 1))))
                                       ELSE ((PH.fee1 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 1, 1))) + (PH.fee2 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        2, 1))) +
                                             (PH.fee3 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 3, 1))) + (PH.fee4 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        4, 1))) +
                                             (PH.fee5 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 5, 1))) + (PH.fee6 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        6, 1))) +
                                             (PH.fee7 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 7, 1))) + (PH.fee8 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        8, 1))) +
                                             (PH.fee9 * CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags, 9, 1))) + (PH.fee10 *
                                                                                                        CONVERT(TINYINT, SUBSTRING(PH.InvoiceFlags,
                                                                                                        10, 1))))
                                  END
                             ELSE 0
                        END) AS InvoiceableTotalFeeAmount,
                    SUM(CASE WHEN PH.batchtype LIKE 'P%'
                             THEN CASE WHEN PH.batchtype LIKE '%r'
                                       THEN -(PH.fee1 + PH.fee2 + PH.fee3 + PH.fee4 + PH.fee5 + PH.fee6 + PH.fee7 +
                                              PH.fee8 + PH.fee9 + PH.fee10)
                                       ELSE (PH.fee1 + PH.fee2 + PH.fee3 + PH.fee4 + PH.fee5 + PH.fee6 + PH.fee7 +
                                             PH.fee8 + PH.fee9 + PH.fee10)
                                  END
                             ELSE 0
                        END) AS TotalFeeAmount,
                    SUM(CASE WHEN PH.batchtype LIKE 'D%' THEN CASE WHEN PH.batchtype LIKE '%r' THEN PH.totalpaid
                                                                   ELSE -PH.totalpaid
                                                              END
                             ELSE 0
                        END) AS TotalAdjustmentAmount
                  FROM
                    dbo.payhistory AS PH
                    INNER JOIN CTE_DateDimension AS DD
                        ON PH.systemmonth = DD.FiscalMonth AND
                           PH.systemyear = DD.FiscalYear
                  GROUP BY
                    PH.number,
                    DD.FiscalFirstDayOfMonth)
           MERGE dbo.StairStepReductionDetail AS SSD
           USING
            (SELECT
                SH.ID,
                PH.TransactionDate AS FiscalDate,
                SUM(COALESCE(PH.TotalPaidAmount, 0)) AS TotalCollectedAmount,
                SUM(COALESCE(PH.TotalFeeAmount, 0)) AS TotalFeeAmount,
                SUM(COALESCE(PH.InvoiceableTotalPaidAmount, 0)) AS InvoiceableCollectedAmount,
                SUM(COALESCE(PH.InvoiceableTotalFeeAmount, 0)) AS InvoiceableFeeAmount,
                SUM(COALESCE(PH.TotalAdjustmentAmount, 0)) AS AdjustmentAmount
             FROM
                dbo.master AS M
                INNER JOIN dbo.status AS S
                    ON M.status = S.code
                INNER JOIN CTE_DateDimension AS DD
                    ON M.sysmonth = DD.FiscalMonth AND
                       M.SysYear = DD.FiscalYear
                INNER JOIN CTE_PayHistory AS PH
                    ON M.number = PH.number
                INNER JOIN dbo.StairStepReductionHeader AS SH
                    ON M.customer = SH.customer AND
                       SH.PlacementDate = DD.FiscalFirstDayOfMonth
             WHERE
                S.ReduceStats = 1
             GROUP BY
                SH.ID,
                PH.TransactionDate) AS NEW
           ON (
               SSD.StairStepReductionHeaderID = NEW.ID AND
               SSD.FiscalDate = NEW.FiscalDate
              )
           WHEN NOT MATCHED BY TARGET THEN
            INSERT
                   (
                    StairStepReductionHeaderID,
                    FiscalDate,
                    TotalCollectedAmount,
                    TotalFeeAmount,
                    InvoiceableCollectedAmount,
                    InvoiceableFeeAmount,
                    AdjustmentAmount
                   )
            VALUES (
                    NEW.ID,
                    NEW.FiscalDate,
                    NEW.TotalCollectedAmount,
                    NEW.TotalFeeAmount,
                    NEW.InvoiceableCollectedAmount,
                    NEW.InvoiceableFeeAmount,
                    NEW.AdjustmentAmount
                   )
           WHEN MATCHED AND (
                             SSD.TotalCollectedAmount != NEW.TotalCollectedAmount OR
                             SSD.TotalFeeAmount != NEW.TotalFeeAmount OR
                             SSD.InvoiceableCollectedAmount != NEW.InvoiceableCollectedAmount OR
                             SSD.InvoiceableFeeAmount != NEW.InvoiceableFeeAmount OR
                             SSD.AdjustmentAmount != NEW.AdjustmentAmount
                            ) THEN
            UPDATE SET
                    SSD.TotalCollectedAmount = NEW.TotalCollectedAmount,
                    SSD.TotalFeeAmount = NEW.TotalFeeAmount,
                    SSD.InvoiceableCollectedAmount = NEW.InvoiceableCollectedAmount,
                    SSD.InvoiceableFeeAmount = NEW.InvoiceableFeeAmount,
                    SSD.AdjustmentAmount = NEW.AdjustmentAmount
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE;
END;
GO
