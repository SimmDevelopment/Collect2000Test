SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[Receiver_SelectCloseAccountsReadyForFile]
@clientid int
as
begin

DECLARE @lastFileSentDT datetime
select @lastFileSentDT = dbo.Receiver_GetLastFileDate(9,@clientid)

SELECT

      'ACLS' as record_type,
      r.sendernumber as file_number,
      m.account as account,
      sl.clientstatus as close_status_code,
      m.closed as close_date

FROM

      master m  with (nolock) join receiver_reference r with (nolock)
      on r.receivernumber = m.number join
      receiver_statuslookup sl  with (nolock) on m.status = sl.agencystatus and sl.clientid = @clientid
      join status s with (nolock) on s.code = m.status
WHERE
      m.closed is not null
      and m.qlevel = '998'
      and r.clientid = @clientid
       and ((sl.holddays IS NULL AND m.closed + isnull(s.returndays,0) <= getdate()) OR
            (sl.holddays IS NOT NULL AND m.closed + isnull(sl.holddays,0) <= getdate()))
end

GO
