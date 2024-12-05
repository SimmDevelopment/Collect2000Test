SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Discover_Recon] 

@customer varchar(8000)

as
DECLARE @runDate datetime
SET @runDate=getdate()

declare @agencycode varchar(4)

declare @discoverrecon table (agencycode varchar (11) null, account varchar(16) null, balance money)

declare cur cursor for

	select agencycode
	from discover_customermapping with (nolock)

open cur
fetch from cur into @agencycode
while @@fetch_status = 0 begin
	
	insert into @discoverrecon(agencycode, account)
	select 'HDR' + @agencycode + ' PRT' , '01011963' + replace(convert(varchar, getdate(), 101), '/', '')

	insert into @discoverrecon(agencycode, account, balance)
	SELECT d.agencycode,m.account,CASE WHEN m.current0 < 0.00 THEN 0.00 ELSE m.current0 END as balance FROM master m WITH(NOLOCK)
	INNER JOIN Discover_CustomerMapping d WITH(NOLOCK) ON d.customer = m.customer
	WHERE m.customer IN(SELECT customercode from DiscoverReturn) AND 
	((m.status NOT IN('PIF','SIF') AND m.Qlevel NOT IN('999','998')) or (m.status = 'aex' and m.qlevel = '998') OR (m.status IN('PIF','SIF') AND m.qlevel = '998'and datediff(day, closed, @runDate) >= 20)) AND
	d.agencycode = @agencycode

	fetch from cur into @agencycode
end

select *
from @discoverrecon

close cur
deallocate cur
GO
