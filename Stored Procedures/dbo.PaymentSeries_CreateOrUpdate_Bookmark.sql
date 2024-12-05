SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PaymentSeries_CreateOrUpdate_Bookmark]
	@Id int OUT,
	@PaymentType varchar(10),
	@VendorCode varchar(50),
	@UsageCode varchar(20),
	@CheckPointValue varchar(255),
	@RFU varchar(255),
	@LastSyncTime datetime
AS

--SET NOCOUNT ON;

if @Id is null
begin

	insert into PaymentVendorSeriesBookmark (
		PaymentType, VendorCode, UsageCode, CheckPointValue,
		RFU, LastSyncTime)
	select
		@PaymentType, @VendorCode, @UsageCode, @CheckPointValue,
		@RFU, @LastSyncTime

	SET @Id = SCOPE_IDENTITY()

end
else
begin

	update PaymentVendorSeriesBookmark
	set
		PaymentType = isnull(@PaymentType, PaymentType), VendorCode = isnull(@VendorCode, VendorCode), UsageCode = isnull(@UsageCode, UsageCode),
		CheckPointValue = isnull(@CheckPointValue, CheckPointValue), RFU = isnull(@RFU, RFU), LastSyncTime = isnull(@LastSyncTime, LastSyncTime)
	where Id = @Id

end

RETURN 0;
GO
