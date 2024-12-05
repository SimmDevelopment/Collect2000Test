SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_LetterRequest_UpdateProcessed*/
CREATE PROCEDURE [dbo].[sp_LetterRequest_UpdateProcessed]
(
	@LetterRequestIDs dbo.IntList_TableType READONLY,
	@JobName VARCHAR(256), 
	@DateProcessed DATETIME, 
	@ProcessingMethod INT
) 
AS
-- Name:		sp_LetterRequest_UpdateProcessed
-- Function:		This procedure will update letter requests processDate and 
-- 			other data after letter requests have been printed for a single 
--			request or for all requests with the same jobname.
SET NOCOUNT ON;
DECLARE @lr AS IntList_TableType;
DECLARE @ERR_MSG AS NVARCHAR(4000);
DECLARE @ERR_SEV AS SMALLINT;
DECLARE @ERR_STA AS SMALLINT;

BEGIN TRY

DECLARE @Cnt AS INT=0
DECLARE @i AS INT=0
DECLARE @LetterRequestID AS INT=null
DECLARE @LetterID AS INT=null
DECLARE @CustCode AS VARCHAR(10)=NULL

IF OBJECT_ID(N'tempdb..#letterRequestIds') IS NOT NULL
BEGIN
DROP TABLE #letterRequestIds
END

create table #letterRequestIds(rownum int, LetterRequestID int)

insert into #letterRequestIds (rownum, LetterRequestID)
Select row_number() over(order by ID)Rownum,ID from @LetterRequestIDs

select @Cnt=count(*) from #letterRequestIds

IF OBJECT_ID('tempdb..#customers') IS NOT NULL DROP TABLE #customers

CREATE TABLE #customers(rownum INT, customer VARCHAR(7), ValidationPeriodExpiration DATE)
WHILE(@i < @Cnt)
BEGIN
	SET @i = @i +1;
	
	SELECT @LetterRequestID = LetterRequestID FROM #letterRequestIds WHERE Rownum = @i;
	SELECT @LetterID=LetterID, @CustCode=CustomerCode FROM LetterRequest WHERE LetterRequestID= @LetterRequestID

IF NOT EXISTS(select * from #customers where customer=@CustCode)
BEGIN			
	EXEC [dbo].[sp_LetterRequest_GetValidationExpirationForAllCustomers]
		@LetterID = @LetterID,
		@ThroughDate = @DateProcessed,
		@IncludeErrors  =1 
END
END

;WITH CTE_INS_VN AS
(SELECT LR.ACCOUNTID,
        LR.LETTERREQUESTID,
        LR.DATEREQUESTED,
        LR.SUBJDEBTORID,
		LR.LETTERCODE,
		(SELECT ValidationPeriodExpiration FROM #customers tempcust WHERE tempcust.customer = LR.CustomerCode  and tempcust.ValidationPeriodExpiration is not null) AS ValidationPeriodExpiration
FROM  LETTERREQUEST LR
	INNER JOIN LETTER L ON L.Code = LR.LetterCode
	INNER JOIN @LETTERREQUESTIDS LRS ON LRS.ID = LR.LetterRequestID
WHERE L.type = 'DUN' AND LR.SubjDebtorID IS NOT NULL
AND LR.SubjDebtorID NOT IN(SELECT DebtorID FROM ValidationNotice where DebtorID= LR.SubjDebtorID AND AccountID=LR.ACCOUNTID)
)

INSERT INTO DBO.ValidationNotice(ValidationPeriodExpiration,AccountID,LetterRequestID,ValidationNoticeSentDate,DebtorID,ValidationPeriodCompleted,ValidationNoticeType,LastUpdated,[Status])
		SELECT CTE_INS_VN.ValidationPeriodExpiration,
		CTE_INS_VN.ACCOUNTID,
		CTE_INS_VN.LETTERREQUESTID,
		CTE_INS_VN.DATEREQUESTED,
		CTE_INS_VN.SUBJDEBTORID,
		0,
		'Letter',
		GETDATE(),
		'Sent'
FROM CTE_INS_VN Where CTE_INS_VN.ValidationPeriodExpiration is not null

/* Validation Notice Data Update functionality   */

;WITH CTE_UPD_VN AS
(SELECT LR.ACCOUNTID,
        LR.LETTERREQUESTID,
        LR.DATEREQUESTED,
        LR.SUBJDEBTORID,
		LR.LETTERCODE,
		VN.NoticeID,
		(SELECT ValidationPeriodExpiration FROM #customers tempcust WHERE tempcust.customer = LR.CustomerCode) AS ValidationPeriodExpiration
FROM  LETTERREQUEST LR
	INNER JOIN LETTER L ON L.Code = LR.LetterCode
	INNER JOIN @LETTERREQUESTIDS LRS ON LRS.ID = LR.LetterRequestID
	LEFT JOIN VALIDATIONNOTICE VN ON VN.DebtorID = LR.SubjDebtorID 
WHERE L.type = 'DUN' AND LR.SubjDebtorID IS NOT NULL AND VN.NoticeID IS NOT NULL)

UPDATE  VN1
SET VN1.ValidationPeriodCompleted=0,
VN1.Status='Sent',
VN1.ValidationNoticeSentDate=R.DATEREQUESTED,
VN1.ValidationPeriodExpiration=R.ValidationPeriodExpiration,
VN1.LetterRequestID=R.LETTERREQUESTID,
VN1.ValidationNoticeType='Letter',
VN1.LastUpdated=GETDATE()
FROM VALIDATIONNOTICE VN1 JOIN CTE_UPD_VN R
ON VN1.NOTICEID=R.NOTICEID 

IF NOT EXISTS(SELECT * FROM @LetterRequestIDs)
BEGIN
	-- if nothing updated so far then lets use the jobname parm
	UPDATE [dbo].[LetterRequest] 
	SET [DateProcessed] = @DateProcessed, ProcessingMethod = @ProcessingMethod
	OUTPUT Inserted.LetterRequestID INTO @lr
	WHERE [JobName] = @JobName
END
ELSE
BEGIN
	UPDATE [dbo].[LetterRequest] 
	SET [DateProcessed] = @DateProcessed, ProcessingMethod = @ProcessingMethod
	OUTPUT Inserted.LetterRequestID INTO @lr
	FROM dbo.LetterRequest lr INNER JOIN @LetterRequestIDs ids
		ON lr.LetterRequestID = ids.Id
END

END TRY
BEGIN CATCH
	SELECT @ERR_MSG = ERROR_MESSAGE(), @ERR_SEV = ERROR_SEVERITY(), @ERR_STA = ERROR_STATE()
	RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA) WITH NOWAIT
END CATCH

GO
