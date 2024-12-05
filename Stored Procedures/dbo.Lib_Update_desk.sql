SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_desk]
(
      @CODE   varchar (10),
      @CTL   varchar (3),
      @PRIV   varchar (100),
      @NAME   varchar (30),
      @DESKTYPE   varchar (15),
      @PASSWORD   varchar (8),
      @FEES   money,
      @COLLECTIONS   money,
      @MTDPDCFEES   money,
      @MTDPDCCOLLECTIONS   money,
      @MTDFEES   money,
      @MTDCOLLECTIONS   money,
      @YTDFEES   money,
      @YTDCOLLECTIONS   money,
      @BRANCH   varchar (5),
      @QUEUERPTDAYS   int,
      @QUEUERPT   varchar (1),
      @WAITDAYS   int,
      @MONTHLYGOAL   money,
      @MONTHLYCBRREQUESTS   int,
      @CBRREQUESTS   int,
      @CASELIMIT   int,
      @ENFORCELIMIT   bit,
      @DAILYLIMIT   int,
      @NEWBIZDAYS   int,
      @MAXFOLLOWUP   int,
      @CALIAS   varchar (30),
      @PHONE   varchar (12),
      @EXTENSION   varchar (6),
      @EMAIL   varchar (50),
      @MONTHLYGOAL2   varchar (20),
      @SPECIAL1   varchar (20),
      @SPECIAL2   varchar (20),
      @SPECIAL3   varchar (20),
      @VPASSWORD   varchar (10)
)
as
begin


update dbo.desk set
      CTL = @CTL,
      PRIV = @PRIV,
      NAME = @NAME,
      DESKTYPE = @DESKTYPE,
      PASSWORD = @PASSWORD,
      FEES = @FEES,
      COLLECTIONS = @COLLECTIONS,
      MTDPDCFEES = @MTDPDCFEES,
      MTDPDCCOLLECTIONS = @MTDPDCCOLLECTIONS,
      MTDFEES = @MTDFEES,
      MTDCOLLECTIONS = @MTDCOLLECTIONS,
      YTDFEES = @YTDFEES,
      YTDCOLLECTIONS = @YTDCOLLECTIONS,
      BRANCH = @BRANCH,
      QUEUERPTDAYS = @QUEUERPTDAYS,
      QUEUERPT = @QUEUERPT,
      WAITDAYS = @WAITDAYS,
      MONTHLYGOAL = @MONTHLYGOAL,
      MONTHLYCBRREQUESTS = @MONTHLYCBRREQUESTS,
      CBRREQUESTS = @CBRREQUESTS,
      CASELIMIT = @CASELIMIT,
      ENFORCELIMIT = @ENFORCELIMIT,
      DAILYLIMIT = @DAILYLIMIT,
      NEWBIZDAYS = @NEWBIZDAYS,
      MAXFOLLOWUP = @MAXFOLLOWUP,
      CALIAS = @CALIAS,
      PHONE = @PHONE,
      EXTENSION = @EXTENSION,
      EMAIL = @EMAIL,
      MONTHLYGOAL2 = @MONTHLYGOAL2,
      SPECIAL1 = @SPECIAL1,
      SPECIAL2 = @SPECIAL2,
      SPECIAL3 = @SPECIAL3,
      VPASSWORD = @VPASSWORD
where CODE = @CODE

end
GO
