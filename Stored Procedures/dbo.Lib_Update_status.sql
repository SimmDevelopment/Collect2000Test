SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_status]
(
      @CODE   varchar (5),
      @DESCRIPTION   varchar (30),
      @STATUSTYPE   varchar (30),
      @RETURNDAYS   int,
      @CTL   varchar (3),
      @CBRREPORT   bit,
      @CASECOUNT   bit,
      @ISBANKRUPTCY   bit,
      @ISDECEASED   bit,
      @REDUCESTATS   int
)
as
begin


update dbo.status set
      DESCRIPTION = @DESCRIPTION,
      STATUSTYPE = @STATUSTYPE,
      RETURNDAYS = @RETURNDAYS,
      CTL = @CTL,
      CBRREPORT = @CBRREPORT,
      CASECOUNT = @CASECOUNT,
      ISBANKRUPTCY = @ISBANKRUPTCY,
      ISDECEASED = @ISDECEASED,
      REDUCESTATS = @REDUCESTATS
where CODE = @CODE

end
GO
