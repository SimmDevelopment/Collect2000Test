SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_ExtraData_Add*/
CREATE Procedure [dbo].[sp_ExtraData_Add]
@Number int,
@Ctl varchar(3),
@Extracode varchar(2),
@Line1 varchar(128),
@Line2 varchar(128),
@Line3 varchar(128),
@Line4 varchar(128),
@Line5 varchar(128)
AS

INSERT INTO extradata
(
number,
ctl,
extracode,
line1,
line2,
line3,
line4,
line5
)
VALUES
(
@Number,
@Ctl,
@Extracode,
@Line1,
@Line2,
@Line3,
@Line4,
@Line5
)

--SET @ExtraDataID = @@IDENTITY
GO
