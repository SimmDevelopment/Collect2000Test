SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Returns the date portion of the DateTime argument
--Do NOT use in a where clause -- SQLServer will not use indexes correctly if you do
CREATE FUNCTION [dbo].[Date](@inDate datetime)
RETURNS datetime
AS

BEGIN

RETURN DATEADD(day, 0, DATEDIFF(day, 0, @inDate))

END
GO
