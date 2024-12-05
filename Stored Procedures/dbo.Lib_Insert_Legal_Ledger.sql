SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lib_Insert_Legal_Ledger]
(
      @Legal_LedgerID   int output,
      @ACCOUNTID   int,
      @CUSTOMER   varchar (7),
      @ITEMDATE   datetime,
      @DESCRIPTION   varchar (50),
      @DEBITAMT   money,
      @CREDITAMT   money,
      @PAYHISTORYID   int,
      @INVOICEABLE   bit,
      @INVOICE   int,
      @LEGALLEDGERTYPEID int,
	  @APPROVEDBY varchar(50),
	  @ACCOUNTINGLEDGERID varchar(50),
	  @APPROVEDAMOUNT money,
	  @APPROVEDON datetime,
	  @CREATED datetime,
	  @AIMINVOICEID varchar(50),
	  @AIMUNIQUEID varchar(50),
	  @AIMID int,
	  @EXPORTEDFORAPPROVALON datetime
)
as
begin


insert into dbo.Legal_Ledger
(
      
      ACCOUNTID,
      CUSTOMER,
      ITEMDATE,
      DESCRIPTION,
      DEBITAMT,
      CREDITAMT,
      PAYHISTORYID,
      INVOICEABLE,
      INVOICE,
	  LEGALLEDGERTYPEID, 
	  APPROVEDBY ,
	  ACCOUNTINGLEDGERID,
	  APPROVEDAMOUNT ,
	  APPROVEDON ,
	  CREATED ,
	  AIMINVOICEID, 
	  AIMUNIQUEID ,
	  AIMID ,
	  EXPORTEDFORAPPROVALON
      
)
values
(
      @ACCOUNTID,
      @CUSTOMER,
      @ITEMDATE,
      @DESCRIPTION,
      @DEBITAMT,
      @CREDITAMT,
      @PAYHISTORYID,
      @INVOICEABLE,
      @INVOICE,
	  @LEGALLEDGERTYPEID, 
	  @APPROVEDBY ,
	  @ACCOUNTINGLEDGERID,
	  @APPROVEDAMOUNT ,
	  @APPROVEDON ,
	  @CREATED ,
	  @AIMINVOICEID, 
	  @AIMUNIQUEID ,
	  @AIMID ,
	  @EXPORTEDFORAPPROVALON
      
)

select @Legal_LedgerID = Scope_Identity()
end

GO
