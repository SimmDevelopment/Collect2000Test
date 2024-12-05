SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetEliteCollectors]
   @Top INT = NULL,
   @Date DATETIME = NULL,
   @IncludeUserID INT = NULL,
   @UseGross BIT = 0,
   @RestrictByTeam BIT = 0 --jjh
AS
BEGIN

   DECLARE @DateYear INT
   DECLARE @DateMonth INT
   
   DECLARE @Front TABLE (
      Desk VARCHAR(10) NOT NULL,
      Front_Fee MONEY NOT NULL,
      Front_Gross MONEY NOT NULL
   );

   DECLARE @PDC TABLE (
      Desk VARCHAR(10) NOT NULL,
      PDC_Fee MONEY NOT NULL,
      PDC_Gross MONEY NOT NULL
   );

   DECLARE @DCC TABLE (
      Desk VARCHAR(10) NOT NULL,
      DCC_Fee MONEY NOT NULL,
      DCC_Gross MONEY NOT NULL
   );
        
   DECLARE @TeamID INT
   SELECT @TeamID = Desk.TeamID
   FROM Users
   INNER JOIN Desk
   ON Desk.Code = Users.DeskCode
   INNER JOIN Teams
   ON Teams.ID = Desk.TeamID
   WHERE Users.ID = @IncludeUserId
   

   IF @Date IS NULL
   BEGIN
      SET @DATE = {fn Curdate()}
   END
   
   SET @DateYear = YEAR(@Date)
   SET @DateMonth = MONTH(@Date)
   
   --jjh - Added: option to restrict by team
  
   IF @RestrictByTeam=1 -- Team
   BEGIN 
         INSERT INTO @Front
         SELECT Users.DeskCode, 
              ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalFee(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalFee(uid) END),0),
              ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalPaid(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalPaid(uid) END),0)
         FROM Payhistory WITH (NOLOCK)
         JOIN Users ON Users.DeskCode = Payhistory.Desk
       JOIN Desk  ON Payhistory.Desk = desk.code
       JOIN Teams ON Teams.ID=desk.TeamID
         WHERE SystemYear = @DateYear
            AND SystemMonth = @DateMonth
            AND Users.Active = 1
         AND TeamID = @TeamID
         GROUP BY Users.DeskCode


         INSERT INTO @PDC
         SELECT Users.DeskCode, 
              ISNULL(SUM(projectedfee),0),
              ISNULL(SUM(amount),0)
         FROM PDC WITH (NOLOCK)
         JOIN Users ON Users.DeskCode = PDC.Desk
         JOIN Desk  ON PDC.Desk = desk.code
         JOIN Teams ON Teams.ID=desk.TeamID
         WHERE YEAR(Deposit) = @DateYear
              AND MONTH(Deposit) = @DateMonth
              AND PDC.Active = 1
              AND Users.Active = 1
              AND PDC.OnHold is null
              AND TeamID = @TeamID
         GROUP BY Users.DeskCode

         INSERT INTO @DCC
         SELECT U.DeskCode,
              ISNULL(SUM(projectedfee),0),
              ISNULL(SUM(amount),0)
         FROM DebtorCreditCards DCC WITH (NOLOCK) 
         JOIN [master] m WITH (NOLOCK) ON DCC.Number = m.Number
         JOIN Users U ON U.DeskCode = m.Desk
         JOIN Desk  ON m.Desk = desk.code
         JOIN Teams ON Teams.ID=desk.TeamID
         WHERE YEAR(DepositDate) = @DateYear
              AND MONTH(DepositDate) = @DateMonth
              AND DCC.IsActive = 1
              AND DCC.OnHoldDate IS NULL
              AND U.Active = 1              
              AND TeamID = @TeamID
         GROUP BY U.DeskCode
    END   
    ELSE BEGIN 
       INSERT INTO @Front
         SELECT Users.DeskCode, 
              ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalFee(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalFee(uid) END),0),
              ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalPaid(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalPaid(uid) END),0)
         FROM Payhistory WITH (NOLOCK)
         JOIN Users ON Users.DeskCode = Payhistory.Desk
         WHERE SystemYear = @DateYear
            AND SystemMonth = @DateMonth
            AND Users.Active = 1
         GROUP BY Users.DeskCode

         INSERT INTO @PDC
         SELECT Users.DeskCode, 
              ISNULL(SUM(projectedfee),0),
              ISNULL(SUM(amount),0)
         FROM PDC WITH (NOLOCK)
         JOIN Users ON Users.DeskCode = PDC.Desk
         WHERE YEAR(Deposit) = @DateYear
              AND MONTH(Deposit) = @DateMonth
              AND PDC.Active = 1
              AND Users.Active = 1
              AND PDC.OnHold is null
         GROUP BY Users.DeskCode

         INSERT INTO @DCC
         SELECT U.DeskCode,
              ISNULL(SUM(projectedfee),0),
              ISNULL(SUM(amount),0)
         FROM DebtorCreditCards DCC WITH (NOLOCK) 
         JOIN [master] m WITH (NOLOCK) ON DCC.Number = m.Number
         JOIN Users U ON U.DeskCode = m.Desk
         WHERE YEAR(DepositDate) = @DateYear
              AND MONTH(DepositDate) = @DateMonth
              AND DCC.OnHoldDate IS NULL
              AND DCC.IsActive = 1
              AND U.Active = 1
         GROUP BY U.DeskCode
   END

   IF @Top IS NOT NULL
   BEGIN
      SET ROWCOUNT @Top
   END
    
   IF @UseGross = 0
   BEGIN 
      IF @RestrictByTeam=1
              SELECT u.ID, 
                   --d.Name,
                  u.UserName as Name,
                  d.Branch,
                  gd.Fee AS [Monthly Goal],
                  ISNULL(Front_Fee,0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee, 0) AS [MTD Amount], 
                   CASE WHEN gd.Fee > 0 THEN ((ISNULL(Front_Fee,0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee, 0)) / gd.Fee) ELSE 0 END AS [Monthly Percent]
                  ,ISNULL(Front_Fee, 0) AS [Posted], --jjh
                  ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee, 0) AS [PDC], --jjh
                  d.TeamID
              FROM Goals_Desk gd
              JOIN Desk d ON d.Code = gd.Desk
              JOIN Users u ON u.DeskCode = gd.Desk
              LEFT JOIN @Front f ON f.Desk = gd.Desk
              LEFT JOIN @PDC pdc ON pdc.Desk = gd.Desk
              LEFT JOIN @DCC dcc ON dcc.Desk = gd.Desk
              LEFT JOIN Teams ON Teams.ID=d.TeamID
              WHERE YEAR([Month]) = @DateYear
                  AND MONTH([Month]) = @DateMonth
                  AND u.Active = 1 AND TeamID = @TeamID
              ORDER BY [Monthly Percent] DESC, [MTD Amount] DESC, [Monthly Goal] DESC
      ELSE
          SELECT u.ID, 
                   --d.Name,
                  u.UserName as Name,
                  d.Branch,
                  gd.Fee AS [Monthly Goal],
                  ISNULL(Front_Fee,0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee, 0) AS [MTD Amount], 
                   CASE WHEN gd.Fee > 0 THEN ((ISNULL(Front_Fee,0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee, 0)) / gd.Fee) ELSE 0 END AS [Monthly Percent]
                  ,ISNULL(Front_Fee, 0) AS [Posted], --jjh
                  ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee, 0) AS [PDC], --jjh
                  d.TeamID
              FROM Goals_Desk gd
              JOIN Desk d ON d.Code = gd.Desk
              JOIN Users u ON u.DeskCode = gd.Desk
              LEFT JOIN @Front f ON f.Desk = gd.Desk
              LEFT JOIN @PDC pdc ON pdc.Desk = gd.Desk
              LEFT JOIN @DCC dcc ON dcc.Desk = gd.Desk
              WHERE YEAR([Month]) = @DateYear
                  AND MONTH([Month]) = @DateMonth
                  AND u.Active = 1
              ORDER BY [Monthly Percent] DESC, [MTD Amount] DESC, [Monthly Goal] DESC
   END
   ELSE
   BEGIN 
      IF @RestrictByTeam=1
              SELECT u.ID, 
                   --d.Name,
                  u.UserName as Name,
                  d.Branch,
                  gd.Gross AS [Monthly Goal],
                  ISNULL(Front_Gross,0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross,0) AS [MTD Amount],
                  CASE WHEN gd.Gross > 0 THEN ((ISNULL(Front_Gross,0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross, 0)) / gd.Gross) ELSE 0 END AS [Monthly Percent]
                  ,ISNULL(Front_Gross, 0) AS [Posted], --jjh
                  ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross, 0) AS [PDC], --jjh
                  d.TeamID --jjh
              FROM Goals_Desk gd
              JOIN Desk d ON d.Code = gd.Desk
              JOIN Users u ON u.DeskCode = gd.Desk
              LEFT JOIN @Front f ON f.Desk = gd.Desk
              LEFT JOIN @PDC pdc ON pdc.Desk = gd.Desk
              LEFT JOIN @DCC dcc ON dcc.Desk = gd.Desk
              LEFT JOIN Teams ON Teams.ID=d.TeamID
              WHERE YEAR([Month]) = @DateYear
                  AND MONTH([Month]) = @DateMonth
                  AND u.Active = 1 AND TeamID = @TeamID
              ORDER BY [Monthly Percent] DESC, [MTD Amount] DESC, [Monthly Goal] DESC
      ELSE
              SELECT u.ID, 
                   --d.Name,
                  u.UserName as Name,
                  d.Branch,
                  gd.Gross AS [Monthly Goal],
                  ISNULL(Front_Gross,0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross,0) AS [MTD Amount],
                  CASE WHEN gd.Gross > 0 THEN ((ISNULL(Front_Gross,0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross, 0)) / gd.Gross) ELSE 0 END AS [Monthly Percent]
                  ,ISNULL(Front_Gross, 0) AS [Posted], --jjh
                  ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross, 0) AS [PDC], --jjh
                  d.TeamID --jjh
              FROM Goals_Desk gd
              JOIN Desk d ON d.Code = gd.Desk
              JOIN Users u ON u.DeskCode = gd.Desk
              LEFT JOIN @Front f ON f.Desk = gd.Desk
              LEFT JOIN @PDC pdc ON pdc.Desk = gd.Desk
              LEFT JOIN @DCC dcc ON dcc.Desk = gd.Desk
              WHERE YEAR([Month]) = @DateYear
                  AND MONTH([Month]) = @DateMonth
                  AND u.Active = 1
              ORDER BY [Monthly Percent] DESC, [MTD Amount] DESC, [Monthly Goal] DESC
   END

    --TODO: Include Specific Collector
    
    SET ROWCOUNT 0
END

GO
