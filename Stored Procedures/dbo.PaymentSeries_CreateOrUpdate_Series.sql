SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PaymentSeries_CreateOrUpdate_Series]
	@Id int OUT,
	@ArrangementId int,
	@AccountId int,
	@PaymentType varchar(10),
	@PaymentVendorTokenId int,
	@SeriesIdentifier varchar(255),
	@Status varchar(20),
	@SeparateSurcharge bit,
	@ExternalCreatedBy varchar(50),
	@ExternalCreatedDate datetime,
	@OriginalPaymentCount int,
	@OriginalTotalAmount money,
	@OriginalFirstPaymentDate datetime,
	@OriginalLastPaymentDate datetime,
	@SeriesSource varchar(50),
	@LastSyncTime datetime,
	@WhenCreated datetime
AS

--SET NOCOUNT ON;

if @Id is null
begin

	insert into PaymentVendorSeries (
		ArrangementId, AccountId, PaymentType, PaymentVendorTokenId, SeriesIdentifier,
		Status, SeparateSurcharge, ExternalCreatedBy, ExternalCreatedDate,
		OriginalPaymentCount, OriginalTotalAmount, OriginalFirstPaymentDate, OriginalLastPaymentDate,
		SeriesSource, LastSyncTime, WhenCreated)
	select
		@ArrangementId, @AccountId, @PaymentType, @PaymentVendorTokenId, @SeriesIdentifier,
		@Status, @SeparateSurcharge, @ExternalCreatedBy, @ExternalCreatedDate,
		@OriginalPaymentCount, @OriginalTotalAmount, @OriginalFirstPaymentDate, @OriginalLastPaymentDate,
		@SeriesSource, @LastSyncTime, @WhenCreated

	SET @Id = SCOPE_IDENTITY()

end
else
begin

	update PaymentVendorSeries
	set
		ArrangementId = isnull(@ArrangementId, ArrangementId), AccountId = isnull(@AccountId, AccountId), PaymentType = isnull(@PaymentType, PaymentType), PaymentVendorTokenId = isnull(@PaymentVendorTokenId, PaymentVendorTokenId), SeriesIdentifier = isnull(@SeriesIdentifier, SeriesIdentifier),
		Status = isnull(@Status, Status), SeparateSurcharge = isnull(@SeparateSurcharge, SeparateSurcharge), ExternalCreatedBy = isnull(@ExternalCreatedBy, ExternalCreatedBy), ExternalCreatedDate = isnull(@ExternalCreatedDate, ExternalCreatedDate),
		OriginalPaymentCount = isnull(@OriginalPaymentCount, OriginalPaymentCount), OriginalTotalAmount = isnull(@OriginalTotalAmount, OriginalTotalAmount), OriginalFirstPaymentDate = isnull(@OriginalFirstPaymentDate, OriginalFirstPaymentDate), OriginalLastPaymentDate = isnull(@OriginalLastPaymentDate, OriginalLastPaymentDate),
		SeriesSource = isnull(@SeriesSource, SeriesSource), LastSyncTime = isnull(@LastSyncTime, LastSyncTime), WhenCreated = isnull(@WhenCreated, WhenCreated)
	where Id = @Id

end

RETURN 0;
GO
