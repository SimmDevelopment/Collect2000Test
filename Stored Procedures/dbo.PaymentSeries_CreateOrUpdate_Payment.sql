SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PaymentSeries_CreateOrUpdate_Payment]
	@Id int OUT,
	@PaymentVendorSeriesId int,
	@PDCId int,
	@DebtorCreditCardId int,
	@Amount money,
	@SurchargeAmount money,
	@ExecuteDate datetime,
	@Status varchar(20),
	@PaymentLinkUID int,
	@PaymentIdentifier varchar(255)
AS

--SET NOCOUNT ON;

if @Id is null
begin

	insert into PaymentVendorSeriesPayment (
		PaymentVendorSeriesId, PDCId, DebtorCreditCardId, Amount, SurchargeAmount,
		ExecuteDate, Status, PaymentLinkUID, PaymentIdentifier)
	select
		@PaymentVendorSeriesId, @PDCId, @DebtorCreditCardId, @Amount, @SurchargeAmount,
		@ExecuteDate, @Status, @PaymentLinkUID, @PaymentIdentifier

	SET @Id = SCOPE_IDENTITY()

end
else
begin

	update PaymentVendorSeriesPayment
	set
		PaymentVendorSeriesId = isnull(@PaymentVendorSeriesId, PaymentVendorSeriesId), PDCId = isnull(@PDCId, PDCId), DebtorCreditCardId = isnull(@DebtorCreditCardId, DebtorCreditCardId), Amount = isnull(@Amount, Amount), SurchargeAmount = isnull(@SurchargeAmount, SurchargeAmount),
		ExecuteDate = isnull(@ExecuteDate, ExecuteDate), Status = isnull(@Status, Status), PaymentLinkUID = isnull(@PaymentLinkUID, PaymentLinkUID), PaymentIdentifier = isnull(@PaymentIdentifier, PaymentIdentifier)
	where Id = @Id

end

RETURN 0;
GO
