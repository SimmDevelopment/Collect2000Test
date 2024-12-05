SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spAccountCustomer_Select*/
CREATE   PROCEDURE [dbo].[spAccountCustomer_Select]
	@Customer varchar(7)
AS


Select Customer, Name, Street1, Street2, City, State, Zipcode, Phone, Fax, Email, FeeSchedule,
       LegalFeeSchedule, IsPODCust, CustGroup, AcknowledgeNewBiz, COB, CultureCode,
       BlanketSIF, InterestBuckets, Priority, CollectorFeeSchedule, BankID
From Customer with(nolock) where Customer = @Customer

Return @@Error




GO
