SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Insert_status]
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


insert into dbo.status
(
      CODE,
      DESCRIPTION,
      STATUSTYPE,
      RETURNDAYS,
      CTL,
      CBRREPORT,
      CASECOUNT,
      ISBANKRUPTCY,
      ISDECEASED,
      REDUCESTATS
)
values
(
      @CODE,
      @DESCRIPTION,
      @STATUSTYPE,
      @RETURNDAYS,
      @CTL,
      @CBRREPORT,
      @CASECOUNT,
      @ISBANKRUPTCY,
      @ISDECEASED,
      @REDUCESTATS
)

end
GO
