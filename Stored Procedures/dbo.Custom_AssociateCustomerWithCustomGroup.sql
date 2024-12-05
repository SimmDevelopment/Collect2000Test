SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_AssociateCustomerWithCustomGroup]
@customer varchar(10),
@customgroupid int

AS

INSERT INTO FACT 
(CustomerID,CustomGroupID)
VALUES
(@customer,@customgroupid)

DECLARE @letterGroup bit
SELECT @letterGroup = LetterGroup FROM CustomCustGroups WHERE ID = @customgroupid

IF @letterGroup = 1
	BEGIN
		DECLARE @ccustomerID int
		SELECT @ccustomerID = ccustomerid from customer WHERE customer = @customer
		
		INSERT INTO CustLtrAllow
		(CustCode,
		LtrCode,
		CopyCustomer,	
		SaveImage)
		SELECT
		@customer,
		LetterCode,
		CopyCustomer,
		SaveImage
		FROM CustomCustGroupLetter
		WHERE CustomCustGroupID = @customgroupid

		INSERT INTO LtrSeriesFact
		(LtrSeriesID,
		CustomerID,
		MinBalance,
		MaxBalance,
		DateCreated,
		DateUpdated)
		SELECT
		LtrSeriesID,
		@ccustomerID,
		MinBalance,
		MaxBalance,
		DateCreated,
		DateUpdated
		FROM CustomCustGroupLtrSeries
		WHERE CustomCustGroupID = @customgroupid

	END

GO
