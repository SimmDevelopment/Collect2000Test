SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[Lib_Update_ComplaintCategory]
(
      @COMPLAINTCATEGORYID   int,
      @CODE   varchar (20),
      @DESCRIPTION   varchar (8000),
      @SLADAYS   int,
      @PRIORITY   int,
      @CREATEDWHEN   datetime,
      @CREATEDBY   varchar (255),
      @MODIFIEDWHEN   datetime,
      @MODIFIEDBY   varchar (255)
)
as
begin


update dbo.ComplaintCategory set
      [CODE] = @CODE,
      [DESCRIPTION] = @DESCRIPTION,
      [SLADAYS] = @SLADAYS,
      [PRIORITY] = @PRIORITY,
      [CREATEDWHEN] = @CREATEDWHEN,
      [CREATEDBY] = @CREATEDBY,
      [MODIFIEDWHEN] = @MODIFIEDWHEN,
      [MODIFIEDBY] = @MODIFIEDBY
where [COMPLAINTCATEGORYID] = @COMPLAINTCATEGORYID

end


GO
