SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessEquipment]
				 
@file_number int
,@Act# varchar(20)
,@Collat_desc varchar(50)
,@Lic# varchar(30)
,@Vin# varchar(30)
,@Yr varchar(10)
,@Mk varchar(30)
,@Mdl varchar(20)
,@Ser varchar(25)
,@Color varchar(20)
,@Key_CD varchar(20)
,@Cond varchar(30)
,@Loc varchar(30)
,@tag# varchar(30)
,@Dlr# varchar(30)
,@PLN_CD varchar(30)
,@Repo_DT varchar(15)
,@DSP_DT varchar(15)
,@Ins varchar(30)
,@Prd_Cmplt# varchar(30)
,@Val money
,@UCC_CD varchar(10)
,@Fil_DT varchar(15)
,@Fil_Loc varchar(30)
,@X_COll varchar(30)
,@LN# varchar(30)
,@Rec_Mthd_CD varchar(20)
,@Reas_CD varchar(30)
,@Typ_CO_CD varchar(30)
,@DSP_CD varchar(30)
,@DSP_ANAL varchar(30)
,@Recovered nvarchar(1)
,@RecoveredDate datetime
,@Commissionable nvarchar(1)
,@WhenLoaded datetime
,@clientid int
,@equipment_id int

AS

DECLARE @receiverNumber INT
SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @clientid
IF(@receivernumber is null)
BEGIN
	RAISERROR ('15001', 16, 1)
	RETURN
END

DECLARE @Qlevel varchar(5)

SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
WHERE [number] = @receiverNumber

IF(@QLevel = '999') 
BEGIN
	RAISERROR('Account has been returned, QLevel 999.',16,1)
	RETURN
END

IF EXISTS (SELECT Number FROM PBEQUIPMENT WITH (NOLOCK) WHERE Number = @receiverNumber AND Ser = @Ser)
BEGIN
UPDATE PBEquipment
SET
			[Act#]              = @Act#
           ,[Collat_desc]		= @Collat_desc
           ,[Lic#]				= @Lic#
           ,[Vin#]				= @Vin#
           ,[Yr]				= @Yr
           ,[Mk]				= @Mk
           ,[Mdl]				= @Mdl
           ,[Color]				= @Color
           ,[Key_CD]			= @Key_CD
           ,[Cond]				= @Cond
           ,[Loc]				= @Loc
           ,[tag#]				= @tag#
           ,[Dlr#]				= @Dlr#
           ,[PLN_CD]			= @PLN_CD
           ,[Repo_DT]			= @Repo_DT
           ,[DSP_DT]			= @DSP_DT
           ,[Ins]				= @Ins
           ,[Prd_Cmplt#]		= @Prd_Cmplt#
           ,[Val]				= @Val
           ,[UCC_CD]			= @UCC_CD
           ,[Fil_DT]			= @Fil_DT
           ,[Fil_Loc]			= @Fil_Loc
           ,[X_COll]			= @X_COll
           ,[LN#]				= @LN#
           ,[Rec_Mthd_CD]		= @Rec_Mthd_CD
           ,[Reas_CD]			= @Reas_CD
           ,[Typ_CO_CD]			= @Typ_CO_CD
           ,[DSP_CD]			= @DSP_CD
           ,[DSP_ANAL]			= @DSP_ANAL
           ,[Recovered]			= CASE @Recovered WHEN 'F' THEN 0 WHEN 'T' THEN 1 END
           ,[RecoveredDate]		= @RecoveredDate
           ,[Commissionable]	= CASE @Commissionable WHEN 'F' THEN 0 WHEN 'T' THEN 1 END
           ,[WhenLoaded]		= @WhenLoaded

WHERE Number = @receiverNumber AND Ser = @Ser

END
ELSE
BEGIN
INSERT INTO [PBEquipment]
           ([Number]
           ,[Act#]
           ,[Collat_desc]
           ,[Lic#]
           ,[Vin#]
           ,[Yr]
           ,[Mk]
           ,[Mdl]
           ,[Ser]
           ,[Color]
           ,[Key_CD]
           ,[Cond]
           ,[Loc]
           ,[tag#]
           ,[Dlr#]
           ,[PLN_CD]
           ,[Repo_DT]
           ,[DSP_DT]
           ,[Ins]
           ,[Prd_Cmplt#]
           ,[Val]
           ,[UCC_CD]
           ,[Fil_DT]
           ,[Fil_Loc]
           ,[X_COll]
           ,[LN#]
           ,[Rec_Mthd_CD]
           ,[Reas_CD]
           ,[Typ_CO_CD]
           ,[DSP_CD]
           ,[DSP_ANAL]
           ,[Recovered]
           ,[RecoveredDate]
           ,[Commissionable]
           ,[WhenLoaded])
     VALUES
           (@receivernumber
			,@Act#
			,@Collat_desc 
			,@Lic# 
			,@Vin# 
			,@Yr 
			,@Mk 
			,@Mdl 
			,@Ser 
			,@Color 
			,@Key_CD 
			,@Cond 
			,@Loc 
			,@tag# 
			,@Dlr# 
			,@PLN_CD 
			,@Repo_DT 
			,@DSP_DT 
			,@Ins 
			,@Prd_Cmplt# 
			,@Val 
			,@UCC_CD 
			,@Fil_DT 
			,@Fil_Loc 
			,@X_COll 
			,@LN# 
			,@Rec_Mthd_CD 
			,@Reas_CD 
			,@Typ_CO_CD 
			,@DSP_CD 
			,@DSP_ANAL 
			,CASE @Recovered  WHEN 'F' THEN 0 WHEN 'T' THEN 1 END
			,@RecoveredDate 
			,CASE @Commissionable  WHEN 'F' THEN 0 WHEN 'T' THEN 1 END
			,@WhenLoaded )
END

GO
