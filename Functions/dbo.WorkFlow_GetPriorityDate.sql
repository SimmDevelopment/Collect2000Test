SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[WorkFlow_GetPriorityDate] (@Date DATETIME, @Priority TINYINT)
RETURNS TABLE
as
	RETURN SELECT CASE WHEN @Date IS NULL THEN NULL ELSE DATEADD(MINUTE, -5 * ISNULL(@Priority,100), @Date) END AS PriorityDate;
GO
