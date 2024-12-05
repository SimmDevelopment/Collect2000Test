SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




create procedure [dbo].[Lib_Insert_ServiceRequest_PRESETS]
(
      @PRESETID   uniqueidentifier,
      @MANIFESTID   uniqueidentifier,
      @RECURRING   bit,
      @INCLUDECODEBTORS   bit,
      @DATECREATED   datetime,
      @IMGPRESET   image,
      @XMLPRESET   ntext
)
as
begin


insert into dbo.ServiceRequest_PRESETS
(
      [PRESETID],
      [MANIFESTID],
      [RECURRING],
      [INCLUDECODEBTORS],
      [DATECREATED],
      [IMGPRESET],
      [XMLPRESET]
)
values
(
      @PRESETID,
      @MANIFESTID,
      @RECURRING,
      @INCLUDECODEBTORS,
      @DATECREATED,
      @IMGPRESET,
      @XMLPRESET
)

end



GO
