SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[scheduleletterseries]
AS 
    DECLARE @holdnum INT
    DECLARE @ltrseriesid INT
    DECLARE @loaddate DATETIME

    DECLARE @ltrseriesreq CURSOR 
    SET @ltrseriesreq = CURSOR FOR select TOP 100000 m.number,l.ltrseriesid,m.received from master m with (nolock) inner join customer c with (nolock) on m.customer = c.customer
inner join ltrseriesfact l with (nolock) on c.ccustomerid = l.customerid
where c.ccustomerid in (select customerid from ltrseriesfact with (nolock))
and m.number not in (select accountid from ltrseriesqueue with (nolock))
and m.received > getdate() -25
and m.number not in (select number from pdc with (nolock) where active = 1)
and
m.number not in (select acctid from promises with (nolock) where active = 1)
and
m.number not in (select number from debtorcreditcards with (nolock) where isactive = 1)
and m.status NOT in ('RSK') AND m.closed IS null


    OPEN @ltrseriesreq
    FETCH NEXT FROM @ltrseriesreq INTO @holdnum,@ltrseriesid,@loaddate
    WHILE ( @@fetch_status = 0 ) 
        BEGIN
            EXEC sp_ltrseries_loadqueue_existing_account @ltrseriesid,
                @holdnum, 0, @loaddate 
            FETCH NEXT FROM @ltrseriesreq INTO @holdnum,@ltrseriesid,@loaddate
        END
    CLOSE @ltrseriesreq
    DEALLOCATE @ltrseriesreq
GO
