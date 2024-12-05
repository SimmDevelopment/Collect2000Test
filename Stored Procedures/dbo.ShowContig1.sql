SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ShowContig1] AS


dbcc showcontig (master) With Tableresults
GO
