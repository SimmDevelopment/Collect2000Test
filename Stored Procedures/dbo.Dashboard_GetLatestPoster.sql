SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetLatestPoster]
   @UserId INT,
   @MinThreshold money = 0,
   @MinPayhistoryUID INT = 0,
   @MinPDCUID INT = 0,
   @MinDCCUID INT = 0
AS
BEGIN
   DECLARE @DateYear INT
   DECLARE @DateMonth INT
   DECLARE @Date DATETIME   

   SET @DATE = {fn Curdate()}
   
   SET @DateYear = YEAR(@Date)
   SET @DateMonth = MONTH(@Date)
   
   SELECT TOP 1 * FROM
	   (SELECT TOP 1
	      Users.ID,
		  Users.UserName,
		  Entered,
		  dbo.Custom_CalculatePaymentTotalPaid(uid) as Amount,
		  0 as PaymentType
	   FROM Payhistory WITH (NOLOCK)
	   JOIN Users ON Users.DeskCode = Payhistory.Desk
	   WHERE SystemYear = @DateYear
		 AND SystemMonth = @DateMonth
		 AND Users.Active = 1
		 AND Uid > @MinPayhistoryUID
		 AND dbo.Custom_CalculatePaymentTotalPaid(uid) >= @MinThreshold
		 AND BatchType = 'PU'
	   ORDER BY entered,uid DESC
       UNION   
	   SELECT TOP 1
	      Users.ID,
		  Users.UserName,
		  Entered,
		  ISNULL(amount,0),
		  1 as PaymentType
	   FROM PDC WITH (NOLOCK)
	   JOIN Users ON Users.DeskCode = PDC.Desk
	   WHERE YEAR(Entered) = @DateYear
		  AND MONTH(Entered) = @DateMonth
		  AND PDC.Active = 1
		  AND Users.Active = 1
		  AND onhold is null
		  AND Uid > @MinPDCUID
		  AND ISNULL(amount,0) >= @MinThreshold
	   ORDER BY DateCreated DESC
       UNION
	   SELECT TOP 1
	      U.ID,
		  U.UserName,
		  DateEntered,
		  ISNULL(amount,0),
		  2 as PaymentType
	   FROM DebtorCreditCards DCC WITH (NOLOCK) 
	   JOIN [master] m WITH (NOLOCK) ON DCC.Number = m.Number
	   JOIN Users U ON U.DeskCode = m.Desk
	   WHERE YEAR(DepositDate) = @DateYear
		  AND MONTH(DepositDate) = @DateMonth
		  AND DCC.IsActive = 1
		  AND DCC.OnHoldDate IS NULL
		  AND U.Active = 1
		  AND dcc.id > @MinDCCUID
		  AND ISNULL(amount,0) >= @MinThreshold
	   ORDER BY DateCreated DESC) x
	   ORDER BY Entered DESC
END

GO
