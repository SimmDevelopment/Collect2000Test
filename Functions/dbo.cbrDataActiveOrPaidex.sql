SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataActiveOrPaidex] ( @AccountId INT , @debtorid int, @IsChargeOffData bit, @accountstatus char (2), @specialcomment varchar(3), @CanReportActive bit, 
						@StatusIsPIF bit , @nextinformationindicator char(2), @PortfolioIndicator int,
						@SettlementArrangement bit, @CCCS bit, @mcoSpecialComment char(2), @StatusIsSIF bit, @SpecialCommentOverride bit, @deleteReturns bit, @qlevel varchar(3),
						@NextCreditorClass char(2), @SpecialNote char(2))
RETURNS TABLE
AS 
    RETURN
 
					select @AccountId as accountid,
					@debtorid as debtorid, 
					case	when @NextCreditorClass = '02' AND @SpecialNote = 'DI' THEN 'DA'
							when @DeleteReturns = 1 AND @qlevel = '999' THEN 'DA'
							when @IsChargeOffData = 1 AND @StatusIsPIF = 1 THEN '64' 
							when @IsChargeOffData = 1 AND @StatusIsSIF = 1 THEN '64'
							when @IsChargeOffData = 0 AND @StatusIsPIF = 1 THEN '62'
							when @IsChargeOffData = 0 AND @StatusIsSIF = 1 THEN '62'
							when @IsChargeOffData = 0 THEN '93' 
							when @nextinformationindicator in ('I','J','K','L') and @IsChargeOffData = 1 then '97'
							when @IsChargeOffData = 1 and @PortfolioIndicator = 2 then @accountstatus
							when @IsChargeOffData = 1 then case 
														when @AccountStatus in ('11', '71', '78', '80', '82', '83', '84', '97') AND  @nextinformationindicator not in ('','Q')
														then @AccountStatus else '97' end
					ELSE @accountstatus END as nextaccountstatus,
					case	when @IsChargeOffData = 1 AND @StatusIsPIF = 1 THEN '' 
							when @IsChargeOffData = 1 AND @StatusIsSIF = 1 THEN 'AU'
							when @IsChargeOffData = 0 AND @StatusIsPIF = 1 THEN ''
							when @IsChargeOffData = 0 AND @StatusIsSIF = 1 THEN 'AU'
							WHEN @SpecialCommentOverride = 1 THEN @specialcomment
							WHEN @IsChargeOffData = 1 AND ISNULL(@mcoSpecialComment,'') <> '' THEN ISNULL(@mcoSpecialComment,'')
							WHEN @IsChargeOffData = 1 AND @CCCS = 1 THEN 'B'
							WHEN @IsChargeOffData = 1 AND @SettlementArrangement = 1 THEN 'AC'
							WHEN @IsChargeOffData = 1 AND @PortfolioIndicator = 2 THEN 'AH'
														   															   
					ELSE ''
					END as nextspecialcomment
					
															
							  					
GO
