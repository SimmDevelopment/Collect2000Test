SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_GetAccountWarnings] 

@AccountID INTEGER 

/*

exec Custom_GetAccountWarnings 9415

*/

AS 
SET NOCOUNT ON; 
declare @multiple as INT
DECLARE @linkText AS VARCHAR(max)
--Return linked account values for US Bank
IF @AccountID IN (SELECT number FROM master m WITH (NOLOCK) WHERE number = @accountid 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 289) 
AND link > 0 AND link IN (SELECT link FROM master WITH (NOLOCK) WHERE link = m.link AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 289) AND closed IS NULL AND number <> @accountid))
	BEGIN
	--Create a string from a result dataset query
	SELECT @linkText = COALESCE(@linkText + '', '') + 'ACCOUNT ENDING IN    ' + RIGHT(m.account, 4) + '    BALANCE =  ' + CONVERT(VARCHAR(10), m.current0) + '
		'
    FROM master m WITH (NOLOCK)
    WHERE link = (SELECT link FROM master WHERE Number = @AccountID)
    --return the string to the warning screen, can only select variables or strings to return, no queries
	SELECT @linkText AS warning, CAST(0 AS BIT) AS [severe];
		
	RETURN 0;
	END
	
--MA OOS Disclosure
IF @accountid IN (SELECT number 
					FROM master m WITH (NOLOCK) INNER JOIN dbo.EarlyStageData e WITH (NOLOCK) ON m.number = e.AccountID
					WHERE State = 'MA' AND e.PromoExpDate < GETDATE())
begin
	SELECT 'WE ARE REQUIRED BY REGULATION OF THE MASSACHUSETTS ATTORNEY GENERAL TO NOTIFY YOU OF THE FOLLOWING INFORMATION.  THIS INFORMATION IS NOT LEGAL ADVICE: THIS DEBT MAY BE TOO OLD FOR YOU TO BE SUED ON IT IN COURT.  IF IT IS TOO OLD, YOU CANNOT BE REQUIRED TO PAY IT THROUGH A LAWSUIT.  TAKE NOTE: YOU CAN RENEW THE DEBT AND THE STATUTE OF LIMITATIONS FOR THE FILING OF A LAWSUIT AGAINST YOU IF YOU DO ANY OF THE FOLLOWING: MAKE ANY PAYMENT ON THE DEBT, SIGN A PAPER IN WHICH YOU ADMIT THAT YOU OWE THE DEBT OR IN WHICH YOU MAKE A NEW PROMISE TO PAY; SIGN A PAPER IN WHICH YOU GIVE UP OR WAIVE YOUR RIGHT TO STOP THE CREDITOR FROM SUING YOU IN COURT TO COLLECT THE DEBT.  WHILE THIS DEBT MAY NOT BE ENFORCEABLE THROUGH A LAWSUIT, IT MAY STILL AFFECT YOUR ABILITY TO OBTAIN CREDIT OR AFFECT YOUR CREDIT SCORE OR RATING.' AS warning, CAST(0 AS BIT) AS [severe];
	
	RETURN 0;
END

--NM OOS Disclosure
IF @accountid IN (SELECT number 
					FROM master m WITH (NOLOCK) INNER JOIN dbo.EarlyStageData e WITH (NOLOCK) ON m.number = e.AccountID
					WHERE State = 'NM' AND e.PromoExpDate < GETDATE())
begin
	SELECT 'WE ARE REQUIRED BY NEW MEXICO ATTORNEY GENERAL TO NOTIFY YOU OF THE FOLLOWING INFORMATION. THIS INFORMATION IS NOT LEGAL ADVICE: THIS DEBT MAY BE TOO OLD FOR YOU TO BE SUED UPON IN COURT. IF IT IS TOO OLD, YOU CAN’T BE REQUIRED TO PAY IT THROUGH A LAWSUIT. YOU CAN RENEW THE DEBT AND START THE TIME FOR THE FILING OF A LAWSUIT AGAINST YOU TO COLLECT THE DEBT IF YOU DO ANY OF THE FOLLOWING: MAKE ANY PAYMENT OF THE DEBT; SIGN A PAPER IN WHICH YOU ADMIT THAT YOU OWE THE DEBT OR IN WHICH YOU MAKE A NEW PROMISE TO PAY; SIGN A PAPER IN WHICH YOU GIVE UP (“WAIVE”) YOUR RIGHT TO STOP THE DEBT COLLECTOR FROM SUING YOU IN COURT TO COLLECT THE DEBT.' AS warning, CAST(0 AS BIT) AS [severe];
	
	RETURN 0;
END	

--NYC OOS Disclosure
IF @accountid IN (SELECT number 
					FROM master m WITH (NOLOCK) INNER JOIN dbo.EarlyStageData e WITH (NOLOCK) ON m.number = e.AccountID
					WHERE State = 'NY' AND zipcode IN (SELECT * FROM dbo.Custom_NYC_Zipcodes WITH (NOLOCK)) AND e.PromoExpDate < GETDATE())
begin
	SELECT UPPER('
	WE ARE REQUIRED BY LAW TO GIVE YOU THE FOLLOWING INFORMATION ABOUT THIS DEBT. THE LEGAL TIME LIMIT (STATUTE OF LIMITATIONS) FOR SUING YOU TO COLLECT THIS DEBT HAS EXPIRED. HOWEVER, IF SOMEBODY SUES YOU ANYWAY TO TRY AND MAKE YOU PAY THIS DEBT, COURT RULES REQUIRE YOU TO TELL THE COURT THAT THE STATUTE OF LIMITATIONS HAS EXPIRED TO PREVENT THE CREDITOR FROM OBTAINING A JUDGMENT. EVEN THOUGH THE STATUTE OF LIMITATIONS HAS EXPIRED, YOU MAY CHOOSE TO MAKE PAYMENTS. HOWEVER, BE AWARE: IF YOU MAKE A PAYMENT, THE CREDITOR’S RIGHT TO SUE YOU TO MAKE YOU PAY THE ENTIRE DEBT MAY START AGAIN.
	 ***************************************************************
	 Third Party collections: must ask and record preferred language 
	 ***************************************************************
') AS warning, CAST(0 AS BIT) AS [severe];
	
	RETURN 0;
END	

IF @accountid IN (SELECT number 
					FROM master m WITH (NOLOCK) INNER JOIN dbo.EarlyStageData e WITH (NOLOCK) ON m.number = e.AccountID
					WHERE State = 'NY' AND zipcode IN (SELECT * FROM dbo.Custom_NYC_Zipcodes WITH (NOLOCK)))
begin
	SELECT UPPER('Once contact is made with the consumer or right party contact, only two calls are allowed per week.
    Do not speak to spouse regarding the debt 
    In any permitted communication with the consumer, the debt collection agency must provide the following:
       1. A call-back number to a phone that is answered by an actual person
       2.  The name of the agency
       3.  The originating creditor of the debt
       4. The name of the person to call back
       5. The amount of the debt at the time of communication
    When leaving a message, either with a voice recorder or a third party,  FDCPA limitations on third party disclosure prevent leaving the amount of the debt and the original creditor’s name in the message
    Settlement agreements- must be confirmed in writing within 5 business days. Settlement in Full (SIF) letters must be sent. 

******************* Third Party collections: must ask and record preferred language ******************************

') AS warning, CAST(0 AS BIT) AS [severe];
	
	RETURN 0;
END	

CREATE TABLE #tempWarnings (
	warning VARCHAR(255),
	severe	 BIT
)
IF @AccountID = 9415
BEGIN
INSERT INTO #tempwarnings
SELECT '1' AS warning, CAST(0 AS BIT) AS [severe]
SELECT '2' AS warning, CAST(0 AS BIT) AS [severe]
END
SELECT * FROM #tempwarnings w





IF @AccountID IN (SELECT number FROM master m WITH (NOLOCK) WHERE (customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid IN (183, 29, 186, 280, 282)) OR customer IN ('0000101','0001534')))

begin
	SELECT UPPER('Requires paper draft') AS warning, CAST(0 AS BIT) AS [severe];
	
	RETURN 0;
END

--IF @AccountID IN (SELECT number FROM master m WITH (NOLOCK) WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 289)
--AND LEFT(m.Zipcode, 5) IN (SELECT LEFT(zipcode, 5) FROM Custom_USBank_Event_ZipCodes cubezc WITH (NOLOCK)))

--BEGIN
--	--Create a string from a result dataset query
--	SELECT @linkText = 'ACCOUNT QUALIFIES FOR 30 DAY SPECIAL HOLD IF IMPACTED BY THE ' + UPPER([event]) 
--	FROM Custom_USBank_Event_ZipCodes cubezc WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON @accountID = m.number AND LEFT(cubezc.Zipcode, 5) = LEFT(m.Zipcode, 5)
--		WHERE @AccountID = m.number 
		
--	--return the string to the warning screen, can only select variables or strings to return, no queries
--	SELECT @linkText AS warning, CAST(0 AS BIT) AS [severe];
		
--	RETURN 0;
--END

ELSE IF @AccountID IN (3204423, 9415) --(SELECT IsOOS FROM Native_OOS_Accounts WHERE number = @AccountID) = 1
BEGIN
	SELECT CASE WHEN @accountid = 9415 THEN '*** ALERT ***: Account is out of statute!
	The law limits how long you can be sued on a debt. Because of the age of your debt, ' + (SELECT previouscreditor FROM master WITH (NOLOCK) WHERE number = @AccountID) + ' cannot sue you for it.'
	ELSE '*** ALERT ***: Account is out of statute!' END AS [Warning], CAST(0 AS BIT) [Severe]
END

DECLARE @HyundaiSIF AS VARCHAR(MAX)
IF (SELECT customer FROM master m WITH (NOLOCK)  WHERE number = @AccountID) IN ('0001122', '0001123')
BEGIN
	SELECT @HyundaiSIF = CASE WHEN RIGHT(account, 1) IN (1,3,5,7,9) THEN '*******This account ends in an ODD number which allows a 50% Blanket SIF in 1 Payment' ELSE '*******This account ends in an EVEN number which allows a 60% Blanket SIF in 1 Payment' END FROM master WITH (NOLOCK) WHERE number = @accountid
	
	SELECT @HyundaiSIF AS [Warning], CAST(0 AS BIT) [Severe]
END


--snowfly warning
/*
if @accountid in (select number from ztempsnowflyblowout with (nolock))
begin

set @multiple = isnull((select multiple from ztempsnowflyblowout with (nolock) where number = @accountid), 0)

SELECT '*****June Incentive*****
Collect a New Money Payment (NMP) on this account and get ' 
+ convert(varchar(1), @multiple) + 'X the normal tokens.'

  AS [Warning], CAST(0 AS BIT) AS [Severe]; 


RETURN 0;
end
*/
--return 0; 
GO
