SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   PROCEDURE [dbo].[Custom_DSTUpdate]

AS
/*
DESCRIPTION:

	Updates AreaCode.Offset according to these rules:

	Daylight Saving Time begins for most of the United States
at 2 a.m. on the second Sunday of March. Time reverts to standard
time at 2 a.m. on the first Sunday of November. In the U.S., each
time zone switches at a different time.

	In the European Union, Summer Time begins and ends at 1 am
Universal Time (Greenwich Mean Time). It starts the last Sunday
in March, and ends the last Sunday in October. In the EU, all
time zones change at the same moment.

WARNING:
	
	European Union/Summer Time is not accounted for in this script.
	
	This should be scheduled to run AFTER 2AM on any given day.
	
CHANGES:
	
	Updated 03/01/2007 to comply with the Energy Policy Act of 2005 -SJ
	
	Updated 3/05/2007 to enable this procedure to take effect anytime,
	not just on the days that DST starts or ends. -WB
*/

DECLARE	@year int;
SET @year = DatePart( yyyy, GetDate() );

IF	( GetDate() BETWEEN 
		dbo.fnDateForNthWeekdayOf( 2, 1, 3, @year ) AND
		dbo.fnDateForNthWeekdayOf( 1, 1, 11, @year )
	)
BEGIN
	/*
	Turn Daylight Saving Time On.
	*/
	UPDATE
		[AreaCode]
	SET
		[Offset] = ( [Timezone] - ( 2 * [Timezone] ) ) + 1
	WHERE
		[HasDst] = 1;
END
ELSE
BEGIN
	/*
	Turn Daylight Saving Time Off.
	*/
	UPDATE
		[AreaCode]
	SET
		[Offset] = ( [Timezone] - ( 2 * [Timezone] ) )
	WHERE
		[HasDst] = 1;
END;

/*
Update Non-Daylight Savings Zones
*/
UPDATE
	[AreaCode]
SET
	[Offset] = ( [Timezone] - ( 2 * [Timezone] ) )
WHERE
	[HasDst] = 0;

/*
Special consideration for Saipan CHST Time
*/
UPDATE
	[AreaCode]
SET
	[Offset] = Abs( [TIMEZONE] )
WHERE
	[State] IN ('GU','MP');

/*
Not sure if this is needed.
*/
RETURN(1);
GO
