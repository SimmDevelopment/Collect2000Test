SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cbrDataPendingExceptionDtlv]
as

select * from cbrDataPendingExceptionDtl(null) ;

GO
