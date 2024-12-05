SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[Lib_Insert_Debtor_Assets]
(
      @ID   int output,
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


insert into dbo.Debtor_Assets
(
      ACCOUNTID,
      DEBTORID,
      NAME,
      ASSETTYPE,
      DESCRIPTION,
      CURRENTVALUE,
      LIENAMOUNT,
      VALUEVERIFIED,
      LIENVERIFIED
)
values
(
      @ACCOUNTID,
      @DEBTORID,
      @NAME,
      @ASSETTYPE,
      @DESCRIPTION,
      @CURRENTVALUE,
      @LIENAMOUNT,
      @VALUEVERIFIED,
      @LIENVERIFIED
)

select @ID = Scope_Identity()
end

GO
