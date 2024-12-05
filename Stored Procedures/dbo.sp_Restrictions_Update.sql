SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Restrictions_Update*/
CREATE  Procedure [dbo].[sp_Restrictions_Update]
@RestrictionID int,
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

UPDATE restrictions
SET
Number = @Number,
DebtorID = @DebtorID,
home = @Home,
job = @Job,
calls = @Calls,
comment = @Comment,
AttyName = @AttyName,
Attyaddr1 = @Attyaddr1,
Attyaddr2 = @Attyaddr2,
AttyCity = @AttyCity,
AttyState = @AttyState,
AttyZip = @AttyZip,
AttyPhone = @AttyPhone,
Attynotes = @Attynotes,
BkyCase = @BkyCase,
BkyChap11 = @BkyChap11,
BkyChap13 = @BkyChap13,
BkyChap7 = @BkyChap7,
BkyCourt = @BkyCourt,
BkyDateFiled = @BkyDateFiled,
BkyDistrict = @BkyDistrict,
BkyNotes = @BkyNotes,
suppressletters = @Suppressletters,
letterstoatty = @LettersToAtty
WHERE RestrictionID = @RestrictionID

GO
