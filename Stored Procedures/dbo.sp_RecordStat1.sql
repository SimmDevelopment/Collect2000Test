SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_RecordStat1]
	@Number int,
	@Desk varchar(10),
	@Touched tinyint,
	@Worked tinyint,
	@Contacted tinyint,
	@ReturnStatus int Output,
	@ErrorBlock tinyint Output
 AS

Declare @SysMonth tinyint
Declare @SysYear smallint
Declare @TheDate datetime
Declare @RowsCount int
Declare @Err int


BEGIN TRAN

SELECT @SysMonth = CurrentMonth, @SysYear = CurrentYear From ControlFile

SELECT @Err=@@Error
IF @Err<>0 BEGIN
	Set @ErrorBlock = 1
	Goto ERRHANDLER
END

SELECT @TheDate = cast(CONVERT(varchar, GETDATE(), 107)as datetime)

SELECT @Err=@@Error
IF @Err<>0 BEGIN
	SET @ErrorBlock = 2
	Goto ERRHANDLER
END

SELECT Desk from DeskStats WHERE Desk=@Desk 
and TheDate = @TheDate and SystemMonth=@SysMonth

SELECT @Err=@@Error, @RowsCount=@@rowcount

IF @Err<>0 BEGIN
	SET @ErrorBlock = 3
	Goto ERRHANDLER
END

IF (@Rowscount=0)
	INSERT INTO DeskStats(Desk, TheDate, Worked, Contacted, Touched, Collections, Fees, SystemMonth, SystemYear)
	VALUES(@Desk, @TheDate, @Worked, @Contacted, @Touched, 0, 0, @SysMonth, @SysYear)
ELSE
	UPDATE DeskStats Set Worked=Worked+@Worked, Contacted=Contacted+@Contacted, Touched=Touched+@Touched
	WHERE Desk=@Desk and TheDate=@TheDate and SystemMonth=@SysMonth

SELECT @Err=@@Error
IF @Err<>0 BEGIN
	SET @ErrorBlock = 4
	Goto ERRHANDLER
END

UPDATE master set TotalViewed =TotalViewed + @Touched, totalWorked=TotalWorked+@Worked,TotalContacted=TotalContacted+@Contacted
WHERE number = @Number

SELECT @Err=@@Error
IF @Err<>0 BEGIN
	SET @ErrorBlock = 5
	Goto ERRHANDLER
END

IF @Worked=1
	Update master SET Worked = @TheDate Where number = @number

SELECT @Err=@@Error
IF @Err <> 0 BEGIN
	SET @ErrorBlock = 6
	Goto ERRHANDLER
END

IF @Contacted=1
	Update master SET Contacted = @TheDate Where number = @number

SELECT @Err=@@Error
IF @Err <>0 BEGIN
	SET @ErrorBlock = 7
	Goto ERRHANDLER
END


ELSE BEGIN
	COMMIT TRAN
	Set @ReturnStatus=0
	Set @ErrorBlock=0
	Return 0
END

ERRHANDLER:
	ROLLBACK TRAN
	SET @ReturnStatus=@Err
	Return @Err
GO
