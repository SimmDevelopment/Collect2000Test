SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* Object:  Stored Procedure dbo.AIM_AllocateNumberBlock    */

CREATE         procedure [dbo].[AIM_AllocateNumberBlock]
	@numberNeeded int
AS

	declare @startNumber int
	select
		@startNumber = nextdebtor
	from
		controlfile

	update 
		controlfile
	set
		nextdebtor = @startNumber + @numberNeeded + 1

	select 
		@startNumber as nextdebtor
		,cast(currentmonth as int) AS currentmonth
		,cast(currentYear as int) as currentyear
		FROM controlfile




GO
