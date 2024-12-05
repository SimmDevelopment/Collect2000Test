SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[IsDaylightSavings]()
returns bit
as
begin
    declare @result bit;
    declare @timeZone varchar(50);
    declare @utcOffset int;
 
    exec MASTER.dbo.xp_regread
        'HKEY_LOCAL_MACHINE',
        'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
        'TimeZoneKeyName',
        @timeZone out;
 
    set @utcOffset =
        case
            when CHARINDEX('Eastern', @timeZone) > 0
                then 4
            when CHARINDEX('Central', @timeZone) > 0
                then 5
            when CHARINDEX('Mountain', @timeZone) > 0
                then 6
            when CHARINDEX('Pacific', @timeZone) > 0
                then 7
            when CHARINDEX('Alaska', @timeZone) > 0
                then 8
            when CHARINDEX('Hawaii', @timeZone) > 0
                then 9
            else 0
        end;
 
    set @result =
        case
            when CAST(DATEDIFF(HH, GETDATE(), GETUTCDATE()) as int) = @utcOffset
                then 1
            else 0
        end;
 
    return @result;
end;
GO
