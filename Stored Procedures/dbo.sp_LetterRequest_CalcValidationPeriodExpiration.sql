SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_LetterRequest_CalcValidationPeriodExpiration]
(
@ValidationPeriodExpiration date =NULL OUTPUT
,@ValidationNoticeType varchar (25) ='Letter'
,@AccountID INT =NULL
,@CustomerCode VARCHAR(10)=NULL
,@ProcessedDate datetime = NULL
)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @noOfDays INT;
Declare @CalDays bit ;
Declare @query NVARCHAR(1000);
Declare @conditionquery NVARCHAR(1000);
Declare @type varchar(25);
Declare @testque nvarchar(max);
DECLARE @Configured BIT ;
DECLARE @PolicySetting nvarchar(max);

SET @ProcessedDate=ISNULL(@ProcessedDate,GETDATE());

EXEC [dbo].[GetValidationnoticePolicySettings]
		@AccountID = @AccountID,
		@CustomerCode=@CustomerCode,
		@Configured = @Configured OUTPUT,
		@PolicySetting = @PolicySetting OUTPUT
IF (@Configured=1)
BEGIN
Select @type=Case When @ValidationNoticeType ='Letter' Then 'LetterNoofDays'
			When @ValidationNoticeType ='Digital' Then 'DigitalNoofDays'
			When @ValidationNoticeType ='Verbally' Then 'VerbalNoofDays'
			End

SET @testque =N';with XMLNAMESPACES (DEFAULT ''http://www.debtsoftware.com/Latitude/Policies'')
			,policy as ( SELECT cast(@PolicySetting as xml) as pxml
			)select @noOfDays= x.v.value(''.'',''decimal'')
			from
			policy cross apply policy.pxml.nodes(''Policy/Setting[@id="'+@type+'"]'') x(v);'
			
			EXECUTE sp_executesql @testque, N'@PolicySetting nvarchar(max),@noOfDays int OUTPUT',@PolicySetting=@PolicySetting, @noOfDays=@noOfDays OUTPUT

;with XMLNAMESPACES (DEFAULT 'http://www.debtsoftware.com/Latitude/Policies')
			,policy as (
			SELECT cast(@PolicySetting as xml) as pxml
			)
			select @CalDays= x.v.value('.','bit') from policy cross apply policy.pxml.nodes('Policy/Setting[@id="excludeWeekendsHolidays"]') x(v);


select @conditionquery=Case when @CalDays =1 then 'AND IsHoliday = 0  AND IsWeekend = 0' else ' AND 1=1' End

SET @query =N'select top 1 @cnt=[Date] from (SELECT TOP (@noOfDays) [Date]  FROM DateDimension WHERE [date] > @ProcessedDate  ' + @conditionquery +' ) as CTE order by [date] desc '

EXECUTE sp_executesql @query, N'@noOfDays INT,@ProcessedDate Datetime, @cnt date OUTPUT', @noOfDays = @noOfDays,@ProcessedDate=@ProcessedDate, @cnt = @ValidationPeriodExpiration OUTPUT

	END
END
GO
