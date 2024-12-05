SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataAuditKeysex] ( @accountid int, @debtorid int, @CbrOutofStatute bit, @statusisfraud bit, @CanReportActive bit, 
						@specialcomment char(2), @nextspecialcomment char(2), @cbrenabled bit, @accountstatus char(2) , @nextaccountstatus char(2), @deletereturns bit, @cbroverride bit,
						@qlevel char(3), @cbrexclude bit, @primarydebtorid int, @responsible bit , @cbrprevent bit, @NextEcoaCode char(2),
						@lastecoacode char(2), @ecoacode char(2), @informationindicator char(2), @nextinformationindicator char(2), @lastinformationindicator char(2),
						@LastComplianceCondition char(2), @NextComplianceCondition char(2), @IsAuthorizedAccountUser bit, @StatusIsPIF bit, @StatusIsSIF bit,
						@compliancecondition char(2), @lastaccountstatus char(2), @specialnote char(2), @returned datetime)
RETURNS TABLE
AS 
    RETURN			-- review order of precedence
					-- Set Audit Keys
						select @accountid as number,
						@debtorid as debtorid,
						Case 
							when @StatusIsFraud = 1 or @nextaccountstatus = 'DF' 
							    then  18
							when  NOT @cbrenabled = 1 -- Configuration change
								then  7
							when @CbrOutofStatute = 1 AND NOT @accountstatus = 'DA' -- statute of limitations
								then  8
							when @cbrexclude = 1 AND @primarydebtorid > 0 -- debtor excluded
								then  11
							when @responsible = 0 AND @primarydebtorid > 0 -- primary debtor not responsible
								then 12                     
							when @cbrprevent = 1 
								 then  17 
							when @NextComplianceCondition not IN ('XR','') then 3 
			
							when  @StatusIsPIF = 1 and ( @accountstatus NOT IN ('62', '64')
										OR @accountstatus IS NULL )
								 then 13 
								 
							when  @StatusIsSIF = 1 and ( @accountstatus NOT IN ('62', '64')
										OR @accountstatus IS NULL )
								 then 14	
											
							when @deletereturns = 1 AND @qlevel = '999' and isdate(@returned)=1
								-- account returned--allow delete regardless
								 then 10
							
							when  @nextaccountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97')
									AND @accountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') 
									and ISNULL(@nextcompliancecondition, '') NOT IN ( '', 'XR' )
									AND ISNULL(@lastcompliancecondition, '') <> ISNULL(@nextcompliancecondition, '') 
									THEN 3
	                                                            
							WHEN @nextaccountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97')
									AND @accountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') 
									and ISNULL(@nextcompliancecondition, '') = 'XR'
									AND ISNULL(@lastcompliancecondition, '') <> 'XR' 
									THEN 4
																
							WHEN @nextaccountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97')
									AND @accountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') 
									and ISNULL(@nextcompliancecondition, '') = ''
									AND ISNULL(@lastcompliancecondition, '') = ''
									AND ISNULL(@compliancecondition, '') <> '' 
									THEN 5
									
							WHEN @specialnote = 'DI' AND @cbrprevent = 0 AND @nextaccountstatus = 'DA' 
									THEN 38 
									
							WHEN @specialnote = 'DA' AND @cbrprevent = 0 AND @lastaccountstatus IN ('62','64') 
									THEN 40
									
							WHEN @specialnote = '' AND @cbrprevent = 0 AND @lastaccountstatus IN ('DA') 
									THEN 39
																		
											
						END AS auditcommentkey,
			                     
						case 
							when @cbrexclude = 1 AND @primarydebtorid = 0 
								then  31	
							when @responsible = 0 AND @primarydebtorid = 0 and isnull(@IsAuthorizedAccountUser,0) = 0
								then  31  

						    when @NextEcoaCode = 'Z'	AND @lastecoacode IS NULL then 30
						    when @NextEcoaCode = 'Z'	AND @lastecoacode IS NOT NULL then 31
						    when @NextEcoaCode != 'X'	AND @ecoacode = 'X'	AND @lastecoacode IS NULL then 32
						    when @NextEcoaCode != 'X'	AND @lastecoacode = 'X' then 33
						    when @NextEcoaCode = 'X'	AND ( @lastecoacode != 'X' OR @lastecoacode IS NULL ) then 34
									  
						    when ( @informationindicator != 'Z' OR @informationindicator IS NULL )
								AND @nextinformationindicator = 'Z' then 35
						    when @InformationIndicator = 'Z' AND @NextInformationIndicator = 'Q'
								AND @lastinformationindicator = 'Z' then 36
						    when @InformationIndicator = 'Z' AND @NextInformationIndicator = 'Q'
								AND @lastinformationindicator IS NULL then 37
						   END  as DebtorsAuditCommentKey,

					    @cbroverride As cbroverride;
			            
GO
