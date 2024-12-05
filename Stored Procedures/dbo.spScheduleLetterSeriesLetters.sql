SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spScheduleLetterSeriesLetters]
AS 
    DECLARE @holdnum INT
    DECLARE @ltrseriesid INT
    DECLARE @loaddate DATETIME

    DECLARE @ltrseriesreq CURSOR 
    SET @ltrseriesreq = 
		CURSOR FOR select m.number,l.ltrseriesid,m.received 
		from master m with (nolock) 
		inner join customer c with (nolock) on m.customer = c.customer
		inner join ltrseriesfact l with (nolock) on c.ccustomerid = l.customerid
		where m.received >= getdate()-6
		and m.current0 between l.minbalance and l.maxbalance
		and c.ccustomerid in (select customerid from ltrseriesfact with (nolock))
		and m.number not in (select accountid from ltrseriesqueue with (nolock))
    OPEN @ltrseriesreq
    FETCH NEXT FROM @ltrseriesreq INTO @holdnum, @ltrseriesid, @loaddate
    WHILE ( @@fetch_status = 0 ) 
        BEGIN
            EXEC sp_ltrseries_loadqueue_existing_account @ltrseriesid, @holdnum, 0, @loaddate 
            FETCH NEXT FROM @ltrseriesreq INTO @holdnum, @ltrseriesid, @loaddate
        END
    CLOSE @ltrseriesreq
    DEALLOCATE @ltrseriesreq

GO
