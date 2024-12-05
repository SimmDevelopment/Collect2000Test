SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[sp_Custom_ShermanBalanceReport]
(
@datebegin datetime,
@dateend datetime
)
AS
BEGIN
	SET @dateend= CAST(CONVERT(varchar(10),getdate(),20) + ' 23:59:59.999' as datetime)
	
	-- Need to Retrieve balance owed in buckets
	SELECT DISTINCT s.[FileName],s.[DateRan],m.account,m.number, m.original as [Orig Balance],m.original1 as [Orig Prin Balance],
	m.original2 as [Orig Int Balance],m.original3 as [Orig Misc Balance], m.original4 as [Orig Fee Balance],
	s.[CurrBalance] as [Sherman Total Balance],
	(s.[PrinOwing]- s.[PrinCollected]) as [Sherman Prin Balance],
	(s.[InterestOwing]-s.[InterestCollected]) as [Sherman Int Balance],
	(s.[MiscExtraOwing]-s.[MiscExtraCollected]) [Sherman Misc Balance],
	(s.[AttyFeeOwing]-s.[AttyFeeCollected]) [Sherman Fee Balance],
	[dbo].[Custom_ShermanBalanceByBucket](m.number,1) as  [Prin Balance],
	[dbo].[Custom_ShermanBalanceByBucket](m.number,2) as  [Int Balance],
	[dbo].[Custom_ShermanBalanceByBucket](m.number,3) as  [Misc Balance],
	[dbo].[Custom_ShermanBalanceByBucket](m.number,4)as  [Fee Balance]	
	FROM ShermanBalanceUpdate s WITH(NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON s.number=m.number
	WHERE s.DateRan BETWEEN @datebegin AND @dateend AND m.Qlevel NOT IN('998','999') AND
	(((s.InterestOwing-s.InterestCollected) <> ([dbo].[Custom_ShermanBalanceByBucket](m.number,2))) OR
    ((s.PrinOwing-s.PrinCollected) <> ([dbo].[Custom_ShermanBalanceByBucket](m.number,1))) OR 
	((s.AttyFeeOwing-s.AttyFeeCollected) <> ([dbo].[Custom_ShermanBalanceByBucket](m.number,4))) OR 
	((s.MiscExtraOwing-s.MiscExtraCollected) <> ([dbo].[Custom_ShermanBalanceByBucket](m.number,3))))
	ORDER BY s.filename,m.account
END
GO
