SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  procedure [dbo].[Distribute_UpdateSubscription]
	@uid int,
	@sourcedesk varchar(7),
	@destinationdesk varchar(7),
	@customergroup int,
	@minimumbalance money,
	@maximumbalance money,
	@dailyrecords int,
	@maximumdays int,
	@active bit,
	@caselimit int
AS

	update subscriptions 
	set sourcedesk = @sourcedesk, destinationdesk = @destinationdesk, 
	customergroup = @customergroup, minimumbalance = @minimumbalance, 
	maximumbalance = @maximumbalance, dailyrecords = @dailyrecords, 
	maximumdays = @maximumdays, active = @active 
	where uid = @uid

	update desk
	set caselimit = @caselimit
	where code = @destinationdesk


GO
