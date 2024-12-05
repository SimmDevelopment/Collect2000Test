SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_ExtraData_Update*/
CREATE Procedure [dbo].[sp_ExtraData_Update]
@Number int,
@Ctl varchar(3),
@Extracode varchar(2),
@Line1 varchar(128),
@Line2 varchar(128),
@Line3 varchar(128),
@Line4 varchar(128),
@Line5 varchar(128)
AS

UPDATE extradata
SET
ctl = @Ctl,
line1 = @Line1,
line2 = @Line2,
line3 = @Line3,
line4 = @Line4,
line5 = @Line5
WHERE Number = @Number AND ExtraCode = @ExtraCode
GO
