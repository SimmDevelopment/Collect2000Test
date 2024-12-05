SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create   FUNCTION [dbo].[MakeQDate](@NormalDate datetime)
RETURNS VARCHAR(8)
AS BEGIN
	RETURN convert(varchar(8),@NormalDate,112)
END
GO
