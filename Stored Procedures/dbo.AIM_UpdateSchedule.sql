SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*  AIM_dbo.AIM_UpdateSchedule     */
CREATE procedure [dbo].[AIM_UpdateSchedule]
	@scheduleid int,
	@scheduletypeid int,
	@startdate datetime = null,
	@enddate datetime = null,
	@runtime datetime = null,
	@everyday bit,
	@weekdays bit,
	@everynumminutes int,
	@everynumdays int,
	@everynumweeks int,
	@dayofmonth int,
	@sunday bit,
	@monday bit,
	@tuesday bit,
	@wednesday bit,
	@thursday bit,
	@friday bit,
	@saturday bit,
	@january bit,
	@february bit,
	@march bit,
	@april bit,
	@may bit,
	@june bit,
	@july bit,
	@august bit,
	@september bit,
	@october bit,
	@november bit,
	@december bit
AS


if (@scheduleid > 0)
	begin
		update AIM_schedule
			set scheduletypeid = @scheduletypeid,
				startdate = @startdate, 
				enddate = @enddate, 
				runtime = @runtime, 
				everyday = @everyday, 
				weekdays = @weekdays, 
				everynumminutes = @everynumminutes,
				everynumdays = @everynumdays, 
				everynumweeks = @everynumweeks, 
				dayofmonth = @dayofmonth, 
				sunday = @sunday, 
				monday = @monday, 
				tuesday = @tuesday, 
				wednesday = @wednesday, 
				thursday = @thursday, 
				friday = @friday, 
				saturday = @saturday, 
				january = @january, 
				february = @february, 
				march = @march, 
				april = @april, 
				may = @may, 
				june = @june, 
				july = @july, 
				august = @august, 
				september = @september, 
				october = @october, 
				november = @november, 
				december = @december
		where scheduleid = @scheduleid
	end
else
	begin
		insert into AIM_schedule(scheduletypeid, startdate, enddate, runtime, everyday, weekdays, everynumminutes, everynumdays, everynumweeks, dayofmonth, sunday, monday, tuesday, wednesday, thursday, friday, saturday, january, february, march, april, may, june, july, august, september, october, november, december)
		values(@scheduletypeid, @startdate, @enddate, @runtime, @everyday, @weekdays, @everynumminutes, @everynumdays, @everynumweeks, @dayofmonth, @sunday, @monday, @tuesday, @wednesday, @thursday, @friday, @saturday, @january, @february, @march, @april, @may, @june, @july, @august, @september, @october, @november, @december)
		select @scheduleid = @@IDENTITY
	end
	
select @scheduleid as 'scheduleid'


GO
