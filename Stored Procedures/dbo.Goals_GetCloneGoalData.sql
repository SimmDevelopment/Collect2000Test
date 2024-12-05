SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Goals_GetCloneGoalData]
@ID VARCHAR(50),
@Branch VARCHAR(10) = NULL,
@GoalType VARCHAR(30),
@GoalMonth DATETIME,
@CloneMonth DATETIME

AS

BEGIN

DECLARE @PostingDays INT
DECLARE @CloneMonthPostingDays INT
DECLARE @CloneMonthGrossGoal MONEY
DECLARE @CloneMonthFeeGoal MONEY
DECLARE @CloneMonthGrossCollections MONEY
DECLARE @CloneMonthFeeCollections MONEY

SELECT @PostingDays = dbo.Goals_GetCalendarMonthTotalPostingDays(@GoalMonth)
SELECT @CloneMonthPostingDays = dbo.Goals_GetCalendarMonthTotalPostingDays(@CloneMonth)

IF(@GoalType = 'Desk')
BEGIN

	SELECT @CloneMonthGrossGoal = ISNULL(Gross,0),@CloneMonthFeeGoal = ISNULL(Fee,0) 
	FROM Goals_Desk 
	WHERE Month([Month]) = Month(@CloneMonth) 
	AND Year([Month]) = Year(@CloneMonth)  
	AND Desk = @ID

	SELECT @CloneMonthGrossCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*TotalPaid ELSE TotalPaid END),
			@CloneMonthFeeCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*(Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) ELSE (Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) END) 
	FROM Payhistory WITH (NOLOCK) 
	WHERE SystemMonth = Month(@CloneMonth) 
	AND SystemYear = Year(@CloneMonth) 
	AND Desk = @ID 
	AND BatchType IN ('PA','PAR','PC','PCR','PUR','PU')

END
ELSE IF(@GoalType = 'Company')
BEGIN

	SELECT @CloneMonthGrossGoal = ISNULL(Gross,0),@CloneMonthFeeGoal = ISNULL(Fee,0) 
	FROM Goals_CompanyMonth
	WHERE Month([Month]) = Month(@CloneMonth) 
	AND Year([Month]) = Year(@CloneMonth)  
	AND CAST(GoalsCompanyID AS VARCHAR(50)) = @ID 

	SELECT @CloneMonthGrossCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*TotalPaid ELSE TotalPaid END),
			@CloneMonthFeeCollections = SUM(CASE WHEN BatchType LIKE '%R%' THEN -1*(Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) ELSE (Fee1+Fee2+Fee3+Fee4+Fee5+Fee6+Fee7+Fee8+Fee9+Fee10) END) 
	FROM Payhistory P WITH (NOLOCK) JOIN Goals_CompanyCustomer GCC WITH (NOLOCK)
	ON P.Customer = GCC.Customer
	WHERE SystemMonth = Month(@CloneMonth) 
	AND SystemYear = Year(@CloneMonth) 
	AND BatchType IN ('PA','PAR','PC','PCR','PUR','PU')
	AND CAST(GoalsCompanyID AS VARCHAR(50)) = @ID 

END

SELECT
CAST(ISNULL(@PostingDays,0) AS INT)				AS [Posting Days],
CAST(ISNULL(@CloneMonthPostingDays,0) AS INT)       AS [Clone Month Posting Days], 
CAST(ISNULL(@CloneMonthGrossGoal,0) AS DECIMAL(12,2))			AS [Clone Month Gross Goal],
CAST(ISNULL(@CloneMonthFeeGoal,0) AS DECIMAL(12,2))			AS [Clone Month Fee Goal] ,
CAST(ISNULL(@CloneMonthGrossCollections,0) AS DECIMAL(12,2))	AS [Clone Month Gross Collections],
CAST(ISNULL(@CloneMonthFeeCollections,0) AS DECIMAL(12,2))	AS [Clone Month Fee Collections]  
           
END


GO
