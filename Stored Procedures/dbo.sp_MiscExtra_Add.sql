SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_MiscExtra_Add*/
CREATE Procedure [dbo].[sp_MiscExtra_Add]
@Number int,
@Title varchar(30),
@TheData varchar(100)
AS

INSERT INTO MiscExtra
(
Number,
Title,
TheData
)
VALUES
(
@Number,
@Title,
@TheData
)

GO
