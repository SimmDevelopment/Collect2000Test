SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*create procedure UpdateLetterStats*/
create procedure [dbo].[UpdateLetterStats]
	@number int,
	@code varchar(5)
as
     declare @systemyear smallint, @systemmonth smallint
     select @systemyear=currentyear, @systemmonth=currentmonth from controlfile
     
     insert into letterstats (number,code,systemyear,systemmonth)
          values (@number, @code, @systemyear, @systemmonth)
GO
