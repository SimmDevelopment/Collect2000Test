SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Update_Debtor_Assets]
(
      @ID   int,
      @ACCOUNTID   int,
      @DEBTORID   int,
      @NAME   varchar (50),
      @ASSETTYPE   int,
      @DESCRIPTION   varchar (4000),
      @CURRENTVALUE   money,
      @LIENAMOUNT   money,
      @VALUEVERIFIED   bit,
      @LIENVERIFIED   bit
)
as
begin


update dbo.Debtor_Assets set
      ACCOUNTID = @ACCOUNTID,
      DEBTORID = @DEBTORID,
      NAME = @NAME,
      ASSETTYPE = @ASSETTYPE,
      DESCRIPTION = @DESCRIPTION,
      CURRENTVALUE = @CURRENTVALUE,
      LIENAMOUNT = @LIENAMOUNT,
      VALUEVERIFIED = @VALUEVERIFIED,
      LIENVERIFIED = @LIENVERIFIED
where ID = @ID

end

GO
