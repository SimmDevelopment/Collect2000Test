SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Goals_GetGoalData]
@ID  VARCHAR(50),
@Branch VARCHAR(10) = NULL,
@GoalType VARCHAR(30),
@GoalMonth DATETIME

AS

BEGIN

DECLARE @PostingDays INT
DECLARE @LastMonthPostingDays INT
DECLARE @LastMonthGrossGoal MONEY
DECLARE @LastMonthFeeGoal MONEY
DECLARE @LastMonthGrossCollections MONEY
DECLARE @LastMonthFeeCollections MONEY
DECLARE @LastYearPostingDays INT
DECLARE @LastYearGrossGoal MONEY
DECLARE @LastYearFeeGoal MONEY
DECLARE @LastYearGrossCollections MONEY
DECLARE @LastYearFeeCollections MONEY 

SELECT @PostingDays = dbo.Goals_GetCalendarMonthTotalPostingDays(@GoalMonth)
SELECT @LastMonthPostingDays = dbo.Goals_GetCalendarMonthTotalPostingDays(DATEADD(month,-1,@GoalMonth))
SELECT @LastYearPostingDays = dbo.Goals_GetCalendarMonthTotalPostingDays(DATEADD(year,-1,@GoalMonth))

IF(@GoalType = 'Desk')
BEGIN

	SELECT @LastMonthGrossGoal = ISNULL(Gross,0),@LastMonthFeeGoal = ISNULL(Fee,0) 
	FROM Goals_Desk 
	WHERE Month([Month]) = Month(DATEADD(month,-1,@GoalMonth)) 
	AND Year([Month]) = Year(DATEADD(month,-1,@GoalMonth))  
	AND Desk = @ID

	SELECT @LastYearGrossGoal = ISNULL(Gross,0),@LastYearFeeGoal = ISNULL(Fee,0) 
	FROM Goals_Desk 
	WHERE Month([Month]) = Month(DATEADD(year,-1,@GoalMonth)) 
	AND Year([Month]) = Year(DATEADD(year,-1,@GoalMonth)) 
	AND Desk = @ID

	SELECT @LastMonthGrossCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*TotalPaid ELSE TotalPaid END),
			@LastMonthFeeCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*(Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) ELSE (Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) END) 
	FROM Payhistory WITH (NOLOCK) 
	WHERE SystemMonth = Month(DATEADD(month,-1,@GoalMonth)) 
	AND SystemYear = Year(DATEADD(month,-1,@GoalMonth)) 
	AND Desk = @ID 
	AND BatchType IN ('PA','PAR','PC','PCR','PUR','PU')

	SELECT @LastYearGrossCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*TotalPaid ELSE TotalPaid END),
			@LastYearFeeCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*(Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) ELSE (Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) END) 
	FROM Payhistory WITH (NOLOCK) 
	WHERE SystemMonth = Month(DATEADD(year,-1,@GoalMonth)) 
	AND SystemYear = Year(DATEADD(year,-1,@GoalMonth)) 
	AND Desk = @ID 
	AND BatchType IN ('PA','PAR','PC','PCR','PUR','PU')

END
ELSE IF(@GoalType = 'Company')
BEGIN

	SELECT @LastMonthGrossGoal = ISNULL(Gross,0),@LastMonthFeeGoal = ISNULL(Fee,0) 
	FROM Goals_CompanyMonth
	WHERE Month([Month]) = Month(DATEADD(month,-1,@GoalMonth)) 
	AND Year([Month]) = Year(DATEADD(month,-1,@GoalMonth))  
	AND CAST(GoalsCompanyID AS VARCHAR(50)) = @ID

	SELECT @LastYearGrossGoal = ISNULL(Gross,0),@LastYearFeeGoal = ISNULL(Fee,0) 
	FROM Goals_CompanyMonth
	WHERE Month([Month]) = Month(DATEADD(year,-1,@GoalMonth)) 
	AND Year([Month]) = Year(DATEADD(year,-1,@GoalMonth)) 
	AND CAST(GoalsCompanyID AS VARCHAR(50)) = @ID

	SELECT @LastMonthGrossCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*TotalPaid ELSE TotalPaid END),
			@LastMonthFeeCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*(Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) ELSE (Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) END) 
	FROM Payhistory P WITH (NOLOCK) JOIN Goals_CompanyCustomer GCC WITH (NOLOCK)
	ON P.Customer = GCC.Customer
	WHERE SystemMonth = Month(DATEADD(month,-1,@GoalMonth)) 
	AND SystemYear = Year(DATEADD(month,-1,@GoalMonth)) 
	AND BatchType IN ('PA','PAR','PC','PCR','PUR','PU')
	AND CAST(GoalsCompanyID AS VARCHAR(50)) = @ID

	SELECT @LastYearGrossCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*TotalPaid ELSE TotalPaid END),
			@LastYearFeeCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*(Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) ELSE (Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) END) 
	FROM Payhistory P WITH (NOLOCK) JOIN Goals_CompanyCustomer GCC WITH (NOLOCK)
	ON P.Customer = GCC.Customer
	WHERE SystemMonth = Month(DATEADD(year,-1,@GoalMonth)) 
	AND SystemYear = Year(DATEADD(year,-1,@GoalMonth)) 
	AND BatchType IN ('PA','PAR','PC','PCR','PUR','PU')
	AND CAST(GoalsCompanyID AS VARCHAR(50)) = @ID

END

SELECT
CAST(ISNULL(@PostingDays,0) AS INT)				AS [Posting Days],
CAST(ISNULL(@LastMonthPostingDays,0) AS INT)       AS [Last Month Posting Days], 
CAST(ISNULL(@LastMonthGrossGoal,0) AS DECIMAL(12,2))			AS [Last Month Gross Goal],
CAST(ISNULL(@LastMonthFeeGoal,0) AS DECIMAL(12,2))			AS [Last Month Fee Goal] ,
CAST(ISNULL(@LastMonthGrossCollections,0) AS DECIMAL(12,2))	AS [Last Month Gross Collections],
CAST(ISNULL(@LastMonthFeeCollections,0) AS DECIMAL(12,2))	AS [Last Month Fee Collections] ,
CAST(ISNULL(@LastYearPostingDays,0) AS INT)		AS [Last Year Posting Days],
CAST(ISNULL(@LastYearGrossGoal,0) AS DECIMAL(12,2))			AS [Last Year Gross Goal] ,
CAST(ISNULL(@LastYearFeeGoal,0) AS DECIMAL(12,2))			AS [Last Year Fee Goal] ,
CAST(ISNULL(@LastYearGrossCollections,0) AS DECIMAL(12,2))	AS [Last Year Gross Collections], 
CAST(ISNULL(@LastYearFeeCollections,0) AS DECIMAL(12,2))		AS [Last Year Fee Collections] 
           
END


GO
