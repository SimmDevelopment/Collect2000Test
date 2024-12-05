SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Lib_Update_EarlyStageData]
(
      @ACCOUNTID   int,
      @PAYMENTHISTORY   char (24),
      @CURRENTMINDUE   money,
      @CURRENTDUE   money,
      @CURRENT30   money,
      @CURRENT60   money,
      @CURRENT90   money,
      @CURRENT120   money,
      @CURRENT150   money,
      @CURRENT180   money,
      @STATEMENTMINDUE   money,
      @STATEMENTDUE   money,
      @STATEMENT30   money,
      @STATEMENT60   money,
      @STATEMENT90   money,
      @STATEMENT120   money,
      @STATEMENT150   money,
      @STATEMENT180   money,
      @PROMOINDICATOR   char (15),
      @PROMOEXPDATE   datetime,
      @SUBSTATUSES   char (6),
      @INTERESTRATE   money,
      @FIXEDINTERESTFLAG   bit,
      @FIXEDMINPAYMENT   money,
      @MULTIPLEACCOUNTS   int,
      @AROWNER   char (6),
      @PLANCODE   char (6),
      @PROVIDERTYPE   char (3),
      @LATEFEEFLAG   bit,
      @LATEFEEACCESSED   char (6),
      @FORCECBFLAG   bit,
      @MAILTOCOAPP   bit,
      @FIRSTPAYMENTDEFAULT   bit,
      @CYCLECODE   char (5),
      @CYCLEPREVIOUSBEGIN   datetime,
      @CYCLEPREVIOUSDUE   datetime,
      @CYCLEPREVIOUSLATE   datetime,
      @CYCLEPREVIOUSEND   datetime,
      @CYCLECURRENTBEGIN   datetime,
      @CYCLECURRENTDUE   datetime,
      @CYCLECURRENTLATE   datetime,
      @CYCLECURRENTEND   datetime,
      @CYCLENEXTBEGIN   datetime,
      @CYCLENEXTDUE   datetime,
      @CYCLENEXTLATE   datetime,
      @CYCLENEXTEND   datetime,
      @EFT   bit,
      @MULTIPLEPROVIDERS   bit,
		@COLLECTORDESK varchar(10)
)
as
begin


update dbo.EarlyStageData set
      PAYMENTHISTORY = @PAYMENTHISTORY,
      CURRENTMINDUE = @CURRENTMINDUE,
      CURRENTDUE = @CURRENTDUE,
      CURRENT30 = @CURRENT30,
      CURRENT60 = @CURRENT60,
      CURRENT90 = @CURRENT90,
      CURRENT120 = @CURRENT120,
      CURRENT150 = @CURRENT150,
      CURRENT180 = @CURRENT180,
      STATEMENTMINDUE = @STATEMENTMINDUE,
      STATEMENTDUE = @STATEMENTDUE,
      STATEMENT30 = @STATEMENT30,
      STATEMENT60 = @STATEMENT60,
      STATEMENT90 = @STATEMENT90,
      STATEMENT120 = @STATEMENT120,
      STATEMENT150 = @STATEMENT150,
      STATEMENT180 = @STATEMENT180,
      PROMOINDICATOR = @PROMOINDICATOR,
      PROMOEXPDATE = @PROMOEXPDATE,
      SUBSTATUSES = @SUBSTATUSES,
      INTERESTRATE = @INTERESTRATE,
      FIXEDINTERESTFLAG = @FIXEDINTERESTFLAG,
      FIXEDMINPAYMENT = @FIXEDMINPAYMENT,
      MULTIPLEACCOUNTS = @MULTIPLEACCOUNTS,
      AROWNER = @AROWNER,
      PLANCODE = @PLANCODE,
      PROVIDERTYPE = @PROVIDERTYPE,
      LATEFEEFLAG = @LATEFEEFLAG,
      LATEFEEACCESSED = @LATEFEEACCESSED,
      FORCECBFLAG = @FORCECBFLAG,
      MAILTOCOAPP = @MAILTOCOAPP,
      FIRSTPAYMENTDEFAULT = @FIRSTPAYMENTDEFAULT,
      CYCLECODE = @CYCLECODE,
      CYCLEPREVIOUSBEGIN = @CYCLEPREVIOUSBEGIN,
      CYCLEPREVIOUSDUE = @CYCLEPREVIOUSDUE,
      CYCLEPREVIOUSLATE = @CYCLEPREVIOUSLATE,
      CYCLEPREVIOUSEND = @CYCLEPREVIOUSEND,
      CYCLECURRENTBEGIN = @CYCLECURRENTBEGIN,
      CYCLECURRENTDUE = @CYCLECURRENTDUE,
      CYCLECURRENTLATE = @CYCLECURRENTLATE,
      CYCLECURRENTEND = @CYCLECURRENTEND,
      CYCLENEXTBEGIN = @CYCLENEXTBEGIN,
      CYCLENEXTDUE = @CYCLENEXTDUE,
      CYCLENEXTLATE = @CYCLENEXTLATE,
      CYCLENEXTEND = @CYCLENEXTEND,
      EFT = @EFT,
      MULTIPLEPROVIDERS = @MULTIPLEPROVIDERS,
		COLLECTORDESK = @COLLECTORDESK
where ACCOUNTID = @ACCOUNTID

end

GO