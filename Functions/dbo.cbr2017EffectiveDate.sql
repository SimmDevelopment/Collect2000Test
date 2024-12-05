SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		George Plimpton
-- Create date: 
-- Description:	Return 9/15/2017, or modify date in order to change effective date for testing
-- =============================================
CREATE FUNCTION [dbo].[cbr2017EffectiveDate] 
()
RETURNS DATETIME
AS 
begin
 return  CAST('2011/9/15' AS DATETIME) 
 end
GO
