SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_Debtor_GetByID*/
CREATE  Procedure [dbo].[sp_Debtor_GetByID]
	@DebtorID int
AS

SELECT [Number], [Seq], [Name], [Street1], [Street2], [City], [State], [Zipcode], [HomePhone], [WorkPhone], [SSN], [MR], [OtherName], [DOB], [JobName], [JobAddr1], [Jobaddr2], [JobCSZ], [JobMemo], [Relationship], [Spouse], [SpouseJobName], [SpouseJobAddr1], [SpouseJobAddr2], [SpouseJobCSZ], [SpouseJobMemo], [SpouseHomePhone], [SpouseWorkPhone], [SpouseResponsible], [Pager], [OtherPhone1], [OtherPhoneType], [OtherPhone2], [OtherPhone2Type], [OtherPhone3], [OtherPhone3Type], [DebtorMemo], [language], [DLNum], [Fax], [Email], [DebtorID], [DateCreated], [DateUpdated], [Country], [lastName], [firstName], [middleName], [suffix], [isBusiness], [isParsed], [cbrException], [cbrExclude], [Responsible], COALESCE([USPSKeyLine], [dbo].[fnCalculateUSPSKeyLine]([DebtorID]), '') AS [USPSKeyLine], [EarlyTimeZone], [LateTimeZone], [businessName], [prefix], [gender], [ObservesDST], [RegionCode], [County], [TimeZoneOverride]
FROM [dbo].[Debtors]
WHERE [DebtorID] = @DebtorID



GO
