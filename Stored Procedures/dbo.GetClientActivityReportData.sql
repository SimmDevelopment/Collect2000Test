SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:        Ben Balke
-- ALTER  date: 12/14/2006
-- Description:   Returns a MARS with the data for the Client Activity Report
-- =============================================
CREATE PROCEDURE [dbo].[GetClientActivityReportData] 
      -- Add the parameters for the stored procedure here
      @month int, 
      @year int
AS
BEGIN
      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.
      SET NOCOUNT ON;
 
      SELECT      Customer,
                  Name
      FROM  Customer
 
      -- This is the This Month information
      SELECT      Customer,
                  Count(Number) NumAssigned,
                  Sum(Original) AmtAssigned,
                  IsNull((SELECT    Sum(
                                    CASE 
                                          WHEN BatchType IN ('PUR','PAR','PCR') THEN -dbo.Custom_CalculatePaymentTotalPaid(UID)
                                          WHEN BatchType IN ('PU','PA','PC') THEN dbo.Custom_CalculatePaymentTotalPaid(UID) 
                                    END)
                  FROM  PayHistory
                  WHERE Customer = Master.Customer
                  AND         SystemMonth = @month
                  AND         SystemYear = @year
                  AND         BatchType NOT IN ('DA','DAR')),0) AmtCollected,
                  (SELECT     Count(Distinct Number) 
                  FROM  PayHistory 
                  WHERE Customer = Master.Customer 
                  AND         SystemMonth = @month 
                  AND         SystemYear = @Year
                  AND         BatchType NOT IN ('DA','DAR')) NumCollected,
                  IsNull((SELECT    Sum(
                                    CASE 
                                          WHEN BatchType IN ('PUR','PAR','PCR') THEN -dbo.Custom_CalculatePaymentTotalFee(UID)
                                          WHEN BatchType IN ('PU','PA','PC') THEN dbo.Custom_CalculatePaymentTotalFee(UID) 
                                    END)
                  FROM  PayHistory
                  WHERE Customer = Master.Customer
                  AND         SystemMonth = @month
                  AND         SystemYear = @year
                  AND         BatchType NOT IN ('DA','DAR')),0) FeeCollected
      FROM  Master
      WHERE Sysmonth = @month 
      AND         SysYear = @year
      GROUP BY Customer
 
      -- This is the This Year payment information          
      SELECT      Customer,
                  Count(Number) NumAssigned,
                  Sum(Original) AmtAssigned,
                  IsNull((SELECT    Sum(
                                    CASE 
                                          WHEN BatchType IN ('PUR','PAR','PCR') THEN -dbo.Custom_CalculatePaymentTotalPaid(UID)
                                          WHEN BatchType IN ('PU','PA','PC') THEN dbo.Custom_CalculatePaymentTotalPaid(UID) 
                                    END)
                  FROM  PayHistory
                  WHERE Customer = Master.Customer
                  AND         SystemYear = @year
                  AND         BatchType NOT IN ('DA','DAR')),0) AmtCollected,
                  (SELECT     Count(Distinct Number) 
                  FROM  PayHistory 
                  WHERE Customer = Master.Customer 
                  AND         SystemYear = @Year
                  AND         BatchType NOT IN ('DA','DAR')) NumCollected,
                  IsNull((SELECT    Sum(
                                    CASE 
                                          WHEN BatchType IN ('PUR','PAR','PCR') THEN -dbo.Custom_CalculatePaymentTotalFee(UID)
                                          WHEN BatchType IN ('PU','PA','PC') THEN dbo.Custom_CalculatePaymentTotalFee(UID) 
                                    END)
                  FROM  PayHistory
                  WHERE Customer = Master.Customer
                  AND         SystemYear = @year
                  AND         BatchType NOT IN ('DA','DAR')),0) FeeCollected
      FROM  Master
      WHERE SysYear = @year
      GROUP BY Customer
 
      -- This is the Total information          
      SELECT      Customer,
                  Max(Received) LastAssigned,
                  Count(Number) NumAssigned,
                  Sum(Original) AmtAssigned,
                  IsNull((SELECT    Sum(
                                    CASE 
                                          WHEN BatchType IN ('PUR','PAR','PCR') THEN -dbo.Custom_CalculatePaymentTotalPaid(UID)
                                          WHEN BatchType IN ('PU','PA','PC') THEN dbo.Custom_CalculatePaymentTotalPaid(UID) 
                                    END)
                  FROM  PayHistory
                  WHERE Customer = Master.Customer
                  AND         BatchType NOT IN ('DA','DAR')),0) AmtCollected,
                  (SELECT     Count(Distinct Number) 
                  FROM  PayHistory 
                  WHERE Customer = Master.Customer 
                  AND         BatchType NOT IN ('DA','DAR')) NumCollected,
                  IsNull((SELECT    Sum(
                                    CASE 
                                          WHEN BatchType IN ('PUR','PAR','PCR') THEN -dbo.Custom_CalculatePaymentTotalFee(UID)
                                          WHEN BatchType IN ('PU','PA','PC') THEN dbo.Custom_CalculatePaymentTotalFee(UID) 
                                    END)
                  FROM  PayHistory
                  WHERE Customer = Master.Customer
                  AND         BatchType NOT IN ('DA','DAR')),0) FeeCollected
      FROM  Master
      GROUP BY Customer
 
END


GO
