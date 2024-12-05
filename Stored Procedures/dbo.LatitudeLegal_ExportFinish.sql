SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    PROCEDURE [dbo].[LatitudeLegal_ExportFinish]
@startdate datetime = null,
@enddate datetime = null,
@llhistoryid int
AS
BEGIN

if(@enddate is null)
begin
set @enddate = getdate()
end
if(@startdate is  null)
begin
select @startdate = max(starteddatetime) from LatitudeLegal_History where endeddatetime is not null and type = 'Export' and Test = 0
end
--INSERT HISTORY RECORD DETAILS
INSERT INTO LatitudeLegal_HistoryRecordDetail
(Number,TransactionDate,TransactionType,TransactionStatus,AttorneyId,AttorneyLawList,Balance,LLHistoryID)
SELECT number,getdate(),1 ,1,attorneyid,attorneylawlist,current0,@llhistoryid
FROM master m with (nolock) where attorneystatus = 'Placing'

INSERT INTO LatitudeLegal_HistoryRecordDetail
(Number,TransactionDate,TransactionType,TransactionStatus,AttorneyId,AttorneyLawList,Balance,LLHistoryID)

SELECT number,getdate(),2,1,attorneyid,attorneylawlist,current0,@llhistoryid
FROM master with (nolock) where attorneystatus = 'Recalling'

DELETE  LatitudeLegal_FeeScheduleREference
FROM LatitudeLegal_FeeScheduleReference fsr JOIN Master m WITH (NOLOCK) ON m.number = fsr.number
WHERE m.attorneystatus = 'Recalling'


INSERT INTO Notes(Created,user0,action,result,comment,number)
SELECT
getdate(),'YGC','+++++','+++++','Account has been placed to attorney:' + a.name,m.number
from master m with (nolock) join attorney a with (nolock) on a.attorneyid = m.attorneyid
where attorneystatus = 'Placing'

INSERT INTO Notes(Created,user0,action,result,comment,number)
SELECT
getdate(),'YGC','+++++','+++++','Account has been recalled from attorney:' + a.name,m.number
from master m with (nolock) join attorney a with (nolock) on a.attorneyid = m.attorneyid
where attorneystatus = 'Recalling'

--UPDATE MASTER
update master set attorneystatus = 'Placed' where attorneystatus = 'Placing' 
update master set attorneystatus = 'Recalled',assignedattorney = null,attorneyid = null,feecode = null where attorneystatus = 'Recalling'

END

GO
