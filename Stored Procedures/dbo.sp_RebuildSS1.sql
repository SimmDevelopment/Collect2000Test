SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_RebuildSS1*/
CREATE procedure [dbo].[sp_RebuildSS1]  --Rebuilds the Placement figures (Also see sp_RebuildSS2 and 3)
	@Cust varchar (7)
AS
Declare @SMo tinyint
Declare @SYr smallint
Declare @ItemCount int
Declare @Orig money
Declare @ErrNum int

SET NOCOUNT ON

Declare crsr CURSOR LOCAL  FAST_FORWARD READ_ONLY FOR

SELECT SysYear, SysMonth, count(sysyear) as ItemCount, sum(Original) as Orig 
FROM master WITH(NOLOCK) where Customer = @Cust and Status not in (Select Code from Status where ReduceStats = 1)
GROUP BY SysYear, SysMonth
ORDER BY Sysyear, SysMonth


IF @@Error <> 0
	Return @@Error

OPEN crsr	
IF @@Error <> 0
	Return @@Error
FETCH NEXT FROM crsr
INTO @SYr, @SMo, @ItemCount, @Orig
IF @@Error <> 0 
	Return @@Error

WHILE @@FETCH_STATUS = 0 BEGIN
	INSERT INTO StairStep(Customer, SSYear, SSMonth, NumberPlaced, GrossDollarsPlaced, NetDollarsPlaced,
		GTCollections, GTFees, TMCollections, TMFees, LMCollections, LMFees,Adjustments,
		Month1, Month2, Month3, Month4, Month5, Month6, Month7, Month8, Month9, Month10,
		Month11, Month12, Month13, Month14, Month15, Month16, Month17, Month18, Month19, Month20,
		Month21, Month22, Month23, Month24, Month99)
	VALUES(@Cust, @SYr, @SMo, @ItemCount, @Orig, @Orig,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	IF @@Error <> 0
		Return @@Error
	FETCH NEXT FROM crsr
	INTO @SYr, @SMo, @ItemCount, @Orig
	IF @@Error <> 0
		Return @@Error
END
CLOSE crsr
DEALLOCATE crsr
Return @@Error
GO
