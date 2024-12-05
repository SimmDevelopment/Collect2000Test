SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*create view LetterStatsDetail*/
create view [dbo].[LetterStatsDetail] as
   select count(*) as letters,desk,branch,customer,code,systemyear,systemmonth from letterstats inner join master on letterstats.number=master.number
      group by letterstats.number,code,systemyear,systemmonth,desk,branch,customer

GO
