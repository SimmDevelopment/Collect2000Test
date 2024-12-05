SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Insert_PaymentBatches]
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

select top 1 @BATCHNUMBER = batchnumber + 1 from paymentbatches order by batchnumber desc

insert into dbo.PaymentBatches
(
      BATCHNUMBER,
      BATCHTYPE,
      CREATEDDATE,
      LASTAMMENDED,
      ITEMCOUNT,
      SYSMONTH,
      SYSYEAR,
      PROCESSEDDATE,
      PROCESSEDBY
)
values
(
      @BATCHNUMBER,
      @BATCHTYPE,
      @CREATEDDATE,
      @LASTAMMENDED,
      @ITEMCOUNT,
      @SYSMONTH,
      @SYSYEAR,
      @PROCESSEDDATE,
      @PROCESSEDBY
)

end

GO
