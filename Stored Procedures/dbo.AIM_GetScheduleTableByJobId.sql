SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*  AIM_dbo.AIM_GetScheduleTableByJobId     */
CREATE procedure [dbo].[AIM_GetScheduleTableByJobId]
	@jobid int
AS


select  s.scheduleid,
		s.scheduletypeid,
		s.startdate,
		s.enddate,
		s.runtime,
		s.everyday,
		s.weekdays,
		s.everynumminutes,
		s.everynumdays,
		s.everynumweeks,
		s.dayofmonth,
		s.sunday,
		s.monday,
		s.tuesday,
		s.wednesday,
		s.thursday,
		s.friday,
		s.saturday,
		s.january,
		s.february,
		s.march,
		s.april,
		s.may,
		s.june,
		s.july,
		s.august,
		s.september,
		s.october,
		s.november,
		s.december
from AIM_Schedule s inner join AIM_Job j on s.scheduleid = j.scheduleid
where j.jobid = @jobid


GO
