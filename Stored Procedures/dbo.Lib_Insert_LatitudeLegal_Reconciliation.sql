SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[Lib_Insert_LatitudeLegal_Reconciliation]
(
      @ACCOUNTID   int,
	  @FORW_FILE varchar(20),
	  @FIRM_ID varchar(20),
      @DPLACED   datetime,
      @DEBT_NAME   varchar (30),
      @CRED_NAME   varchar (30),
      @D1_BAL   money,
      @IDATE   datetime,
      @IAMT   money,
      @IDUE   money,
      @PAID   money,
      @COST_BAL   money,
      @DEBT_CS   varchar (23),
      @DEBT_ZIP   varchar (9),
      @CRED_NAME2   varchar (25),
      @COMM   char (4),
      @SFEE   char (4),
      @RFILE   varchar (8),
      @RECEIVEDDATE datetime
)
as
begin


insert into dbo.LatitudeLegal_Reconciliation
(
        ACCOUNTID  ,
		FORW_FILE ,
		FIRM_ID,
        DPLACED  ,
        DEBT_NAME  ,
        CRED_NAME  ,
        D1_BAL  ,
        IDATE  ,
        IAMT  ,
        IDUE  ,
        PAID  ,
        COST_BAL  ,
        DEBT_CS  ,
        DEBT_ZIP  ,
        CRED_NAME2  ,
        COMM  ,
        SFEE  ,
        RFILE  ,
		RECEIVEDDATE ,
		SENTDATE ,
		SENTFLAG
)
values
(
      @ACCOUNTID,
	  @FORW_FILE,
	  @FIRM_ID,
      @DPLACED,
      @DEBT_NAME,
      @CRED_NAME,
      @D1_BAL,
      @IDATE,
      @IAMT,
      @IDUE,
      @PAID,
      @COST_BAL,
      @DEBT_CS,
      @DEBT_ZIP,
      @CRED_NAME2,
      @COMM,
      @SFEE,
      @RFILE,
	  @RECEIVEDDATE,
		null,0
)

end



GO
