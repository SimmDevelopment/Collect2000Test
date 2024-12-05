SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[IsAllowedtoCall](
@CallStart as int='' ,
@CallEnd as int='',
@NoCallStart as int='',
@NoCallEnd as int='',
@DebtorId as int,
@DoNotCall as bit,
@sTime as int  

)
Returns bit
AS Begin

Declare @isAllowed bit=0  
Declare @isOutside as bit=0
Declare @strOutMessage as varchar=''

IF (@DoNotCall=0)
Begin
	IF (@NoCallStart >= 0 and @NoCallEnd > 0) OR (@NoCallStart>0 and @NoCallEnd >=0)
	Begin
		 IF (@sTime = @NoCallEnd)  
			 Begin    
				 IF(DATEPART(Minute,dbo.GetDebtorsLocalTime(@DebtorId)) > 0 )
					set @sTime =@sTime+1
				Else 
					set @sTime=@sTime
			 End
		IF (@NoCallStart > @NoCallEnd)
            Begin
                IF((@sTime >= @NoCallStart) OR (@sTime < @NoCallEnd))
					set  @isOutside=1
				Else 
					set  @isOutside=0
			End
		Else
			Begin
			IF((@NoCallStart) <= (@sTime)) and (@sTime <= @NoCallEnd)
				set @isOutside = 1
			Else
				set @isOutside = 0
			End
        IF (@isOutside=1)
		Begin
                set @strOutMessage = 'Current time is inside a restricted time window for each debtor on the account'
		End
	End
					

	
IF(@isOutside=0)
Begin
	 IF (@CallStart >= 0 and @CallEnd >= 0 and @NoCallStart = 0 and @NoCallEnd = 0)
		 Begin
			IF (@sTime = @CallEnd)
				Begin			
					  IF(DATEPART(Minute,dbo.GetDebtorsLocalTime(@DebtorId)) > 0 )
						set @sTime=@sTime+1
					Else
						set @sTime=@sTime

				End
			 IF (@CallStart > @CallEnd)
				 Begin
				 IF((@CallEnd <= @sTime) and (@sTime < @CallStart))
					set  @isOutside=1
				Else 
					set  @isOutside=0
			
				 End
			 Else
				 Begin
					 IF ((@sTime > @CallEnd) OR( @sTime < @CallStart))
						 set  @isOutside=1
					Else 
						set  @isOutside=0 
				 End
			 IF (@isOutside=1)
				 Begin
					set @strOutMessage='Current time is outside a preferred call window for each debtor on the account'
				 End

		End
End
End
Else
	Begin
		set @strOutMessage = 'Outside Preferred Call Window'
	End	
IF @strOutMessage !=''
	Begin
		set @isAllowed=1 
		Return ~@isAllowed
	End
Return ~(@isAllowed)
End

GO
