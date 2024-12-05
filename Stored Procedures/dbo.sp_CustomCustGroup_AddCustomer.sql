SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_CustomCustGroup_AddCustomer*/
CREATE Procedure [dbo].[sp_CustomCustGroup_AddCustomer]
	@CustomCustGroupID int,
	@Customer varchar(7)
AS
-- Name:		sp_CustomCustGroup_AddCustomer
-- Function:		This procedure will update custltrallow, ltrseriesfact
-- Creation:		unknown
--			Used by Letter Console. 
-- Change History:	12/17/2003 jc revised to properly update letter series for custom letter groups
BEGIN TRAN T1

--Is the group a Letter Group?
IF EXISTS (SELECT * FROM CustomCustGroups WHERE ID = @CustomCustGroupID AND LetterGroup = 1)
BEGIN
	--Remove all of the customer's current allowed letters
	DELETE FROM CustLtrAllow
	WHERE CustCode = @Customer

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END

	--Remove all of the customer's current allowed letter series
	DELETE lsf FROM LtrSeriesFact lsf
	INNER JOIN customer c ON c.ccustomerid = lsf.customerid
	WHERE c.customer = @Customer

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
	
	--Add all of the group's letters to the customer
	INSERT INTO CustLtrAllow
	(CustCode, LtrCode, CopyCustomer, SaveImage)
	SELECT @Customer, LetterCode, CopyCustomer, SaveImage
	FROM CustomCustGroupLetter
	WHERE CustomCustGroupID = @CustomCustGroupID

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END

	--Add all of the group's letter series to the customer
	INSERT INTO LtrSeriesFact
	(LtrSeriesID, CustomerID, MinBalance, MaxBalance, DateCreated, DateUpdated)
	SELECT ccgls.LtrSeriesID, c.ccustomerid, ccgls.MinBalance, ccgls.MaxBalance, getdate(), getdate()
	FROM CustomCustGroupLtrSeries ccgls with(nolock)
	INNER JOIN customer c with(nolock) ON c.customer = @Customer
	WHERE ccgls.CustomCustGroupID = @CustomCustGroupID

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
END

INSERT INTO FACT
(CustomerID, CustomGroupID)
VALUES
(@Customer, @CustomCustGroupID)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END

--Commit the transaction
COMMIT TRAN T1
GO
