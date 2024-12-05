SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[WorkFlow_GetNextEvaluateDate] (@LastEvaluateDate DATETIME, @CurrentDate DATETIME, @Delay BIGINT)
RETURNS TABLE
as

	return SELECT
			CASE WHEN COALESCE(@LastEvaluateDate, @CurrentDate) IS NULL OR @CurrentDate IS NULL OR @Delay IS NULL OR @Delay <= 0 
				THEN COALESCE(@LastEvaluateDate, @CurrentDate)
				ELSE DATEADD(minute,(DATEDIFF(n,COALESCE(@LastEvaluateDate, @CurrentDate),@CurrentDate)/@Delay)*(@delay)+@delay,@LastEvaluateDate)
				End as NextEvaluateDate
				
GO
