SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*MTDCollections_Insert*/
CREATE  Procedure [dbo].[MTDCollections_Insert]
	@ReportTable TinyInt,	--1=MTDCollectionsByCust, 2=MTDCollectionsByDesk, 3=MTDCollectionsByBranchCust
	@Customer varchar(7),
	@BranchCode varchar(5),
	@DeskCode varchar(10),
	@MTDGross money,
	@MTDFees money,
	@MTDPDCGross money,
	@MTDPDCFees money,
	@UserID int
 /*
**Name            :MTDCollections_Insert
**Function        :Inserts or Updates a record in the MTDCollectionsByCust or MTDCollectionsByDesk table
**Creation        :9/3/2004 mr
**Used by         :Statistics Console
**Change History  :
*/

AS

Declare @RowCount int
Declare @Error int

IF @ReportTable = 1 BEGIN
	UPDATE MTDCollectionsByCust 
	SET 
		MTDGross=MTDGross+@MTDGross,
		MTDFees=MTDFees+@MTDFees,
		MTDPDCGross=MTDPDCGross+@MTDPDCGross,
		MTDPDCFees=MTDPDCFees+@MTDPDCFees
	WHERE Customer=@Customer and UserID=@UserID

	SELECT @RowCount=@@RowCount,@Error=@@Error
	IF @Error<>0 Return @Error
	IF @RowCount = 0 BEGIN
		INSERT INTO MTDCollectionsByCust (Customer, MTDGross, MTDFees, MTDPDCGross, MTDPDCFees, UserID)
		VALUES(@Customer, @MTDGross, @MTDFees, @MTDPDCGross, @MTDPDCFees, @UserID)

		Return @@Error
	END
	ELSE
		Return 0

END

IF @ReportTable = 2 BEGIN
	UPDATE MTDCollectionsByDesk
	SET
		MTDGross=MTDGross+@MTDGross,
		MTDFees=MTDFees+@MTDFees,
		MTDPDCGross=MTDPDCGross+@MTDPDCGross,
		MTDPDCFees=MTDPDCFees+@MTDPDCFees
	WHERE Desk=@DeskCode and UserID=@UserID

	SELECT @RowCount=@@RowCount,@Error=@@Error
	IF @Error<>0 Return @Error
	IF @RowCount = 0 BEGIN
		INSERT INTO MTDCollectionsByDesk (Desk, MTDGross, MTDFees, MTDPDCGross, MTDPDCFees, UserID)
		VALUES(@DeskCode, @MTDGross, @MTDFees, @MTDPDCGross, @MTDPDCFees, @UserID)
		
		RETURN @@Error
	END
	ELSE
		Return 0

END

IF @ReportTable = 3 BEGIN
	UPDATE MTDCollectionsByCust
	SET 
		MTDGross=MTDGross+@MTDGross,
		MTDFees=MTDFees+@MTDFees,
		MTDPDCGross=MTDPDCGross+@MTDPDCGross,
		MTDPDCFees=MTDPDCFees+@MTDPDCFees
	WHERE Customer=@Customer and BranchCode=@BranchCode and UserID=@UserID
	
	SELECT @RowCount=@@RowCount,@Error=@@Error
	IF @Error<>0 Return @Error
	IF @RowCount = 0 BEGIN
		INSERT INTO MTDCollectionsByCust (Customer, BranchCode, MTDGross, MTDFees, MTDPDCGross, MTDPDCFees, UserID)
                VALUES(@Customer,@BranchCode,@MTDGross,@MTDFees,@MTDPDCGross,@MTDPDCFees,@UserID)

		RETURN @@Error
	END
	ELSE
		Return 0
END

Return -1


GO
