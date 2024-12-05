SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[cbrDataPendingExceptionDtl](@accountid int)
returns table as
return	

select p.* from cbrDataPendingExceptionDtlex(@accountid) x
cross apply [dbo].[cbrDataPendingExceptionDtlext](x.number , x.debtorid , x.cbrexception ) p
where p.error <> '';

GO
