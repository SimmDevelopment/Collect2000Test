SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_PaymentBatches]
(
      @BATCHNUMBER   int,
      @BATCHTYPE   int,
      @CREATEDDATE   datetime,
      @LASTAMMENDED   datetime,
      @ITEMCOUNT   int,
      @SYSMONTH   int,
      @SYSYEAR   int,
      @PROCESSEDDATE   datetime,
      @PROCESSEDBY   varchar (10)
)
as
begin


update dbo.PaymentBatches set
      BATCHTYPE = @BATCHTYPE,
      CREATEDDATE = @CREATEDDATE,
      LASTAMMENDED = @LASTAMMENDED,
      ITEMCOUNT = @ITEMCOUNT,
      SYSMONTH = @SYSMONTH,
      SYSYEAR = @SYSYEAR,
      PROCESSEDDATE = @PROCESSEDDATE,
      PROCESSEDBY = @PROCESSEDBY
where BATCHNUMBER = @BATCHNUMBER

end
GO
