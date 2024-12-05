SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_CBRrequest1]
	@FileNum int,
	@LastName varchar(30),
	@FirstName varchar(30),
	@Middle varchar(1),
	@SSN varchar(9),
	@HouseNum varchar(10),
	@Street varchar(30),
	@Direction varchar(2),
	@City varchar(30),
	@State varchar(2),
	@ZipCode varchar(5),
	@UserID varchar(20),
	@ReportCode varchar(4),
	@RtnStatus int OUTPUT
AS

INSERT INTO CBRRequests (Entered, Number, LastName, FirstName, MiddleInitial, SSN, StreetNumber, StreetName, StreetDir, City, State, ZipCode, ReportCode, UserID)
VALUES (GETDATE(), @FileNum, @LastName, @FirstName, @Middle, @SSN, @HouseNum, @Street, @Direction, @City, @State, @ZipCode, @ReportCode, @UserID)

IF (@@error = 0) BEGIN
	set @RtnStatus = 1
	RETURN @RtnStatus
END




GO
