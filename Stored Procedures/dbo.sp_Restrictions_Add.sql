SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Restrictions_Add*/
CREATE   Procedure [dbo].[sp_Restrictions_Add]
@RestrictionID int OUTPUT,
@Number int,
@DebtorID int,
@Home smallint,
@Job smallint,
@Calls smallint,
@Comment text,
@AttyName varchar(30),
@Attyaddr1 varchar(30),
@Attyaddr2 varchar(30),
@AttyCity varchar(20),
@AttyState varchar(2),
@AttyZip varchar(10),
@AttyPhone varchar(15),
@Attynotes text,
@BkyCase varchar(30),
@BkyChap11 smallint,
@BkyChap13 smallint,
@BkyChap7 smallint,
@BkyCourt varchar(30),
@BkyDateFiled Datetime,
@BkyDistrict varchar(30),
@BkyNotes text,
@Suppressletters smallint,
@LettersToAtty bit = 0
AS

INSERT INTO restrictions
(
number,
DebtorID,
home,
job,
calls,
comment,
AttyName,
Attyaddr1,
Attyaddr2,
AttyCity,
AttyState,
AttyZip,
AttyPhone,
Attynotes,
BkyCase,
BkyChap11,
BkyChap13,
BkyChap7,
BkyCourt,
BkyDateFiled,
BkyDistrict,
BkyNotes,
suppressletters,
letterstoatty
)
VALUES
(
@Number,
@DebtorID,
@Home,
@Job,
@Calls,
@Comment,
@AttyName,
@Attyaddr1,
@Attyaddr2,
@AttyCity,
@AttyState,
@AttyZip,
@AttyPhone,
@Attynotes,
@BkyCase,
@BkyChap11,
@BkyChap13,
@BkyChap7,
@BkyCourt,
@BkyDateFiled,
@BkyDistrict,
@BkyNotes,
@Suppressletters,
@LettersToAtty
)

SET @RestrictionID = SCOPE_IDENTITY()

GO
