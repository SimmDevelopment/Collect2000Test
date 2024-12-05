SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   procedure [dbo].[Lib_PurgeAccountByAccount] 
@account   varchar(30)
,@customer varchar(30)
as

declare @number int
DECLARE crsr CURSOR FAST_FORWARD READ_ONLY FOR
SELECT m.number
FROM master m WiTH(NOLOCK) 
WHERE m.customer = @customer and account = @account

OPEN crsr

FETCH NEXT FROM crsr
INTO @number

WHILE @@FETCH_STATUS = 0 BEGIN

	exec Lib_PurgeAccount @number
	FETCH NEXT FROM crsr
INTO @number
	
END
CLOSE crsr
DEALLOCATE crsr

Declare @PmtDate datetime

Declare @ConversionDate datetime

GO
