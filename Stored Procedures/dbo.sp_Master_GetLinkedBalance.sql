SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Master_GetLinkedBalance*/
CREATE Procedure [dbo].[sp_Master_GetLinkedBalance]
(
	@Link int,
	@AccountID int,
	@TotalType int,
	@LinkedBalance money OUTPUT
)
AS
-- Name:		sp_Master_GetLinkedBalance
-- Function:		This procedure will retrieve the sum of current0 for all linked
--			accounts using link as input parameter and linkedbalance as an
--			output parameter.
-- Creation:		6/19/2003 jc
--			Used by Letter Console. 
-- Change History:	12/2/2003 jc added verification to ensure the output value
--			of @linkedbalance would not be null this addresses an invalid cast exception
--			error received when a null value was returned.
--			5/28/2004 jc joined in status table to only total linked active accounts
--			7/1/2004 jc added new parameter @TotalType to return either current0, current1, or current2
--			@TotalType is either (0=current0, 1=current1, and 2=current2)
--			7/1/2004 jc changed active account eval to look at qlevel instead of joining status table
--			8/30/2004 jc added new parameter @AccountID to return account balances if the passed
--			in account is not linked
--			11/11/2004 jc corrected error in setting output parm @LinkedBalance 
	if @Link is null begin 
		if @TotalType = 0 begin
			SELECT @LinkedBalance = SUM(m.current0)
			FROM Master m
			WHERE m.number = @AccountID
			AND m.qlevel NOT IN ('998', '999')
		end
		else if @TotalType = 1 begin	
			SELECT @LinkedBalance = SUM(m.current1)
			FROM Master m
			WHERE m.number = @AccountID
			AND m.qlevel NOT IN ('998', '999')
		end
		else if @TotalType = 2 begin	
			SELECT @LinkedBalance = SUM(m.current2)
			FROM Master m
			WHERE m.number = @AccountID
			AND m.qlevel NOT IN ('998', '999')
		end
	end 
	else if @Link = 0 begin
		if @TotalType = 0 begin
			SELECT @LinkedBalance = SUM(m.current0)
			FROM Master m
			WHERE m.number = @AccountID
			AND m.qlevel NOT IN ('998', '999')
		end
		else if @TotalType = 1 begin	
			SELECT @LinkedBalance = SUM(m.current1)
			FROM Master m
			WHERE m.number = @AccountID
			AND m.qlevel NOT IN ('998', '999')
		end
		else if @TotalType = 2 begin	
			SELECT @LinkedBalance = SUM(m.current2)
			FROM Master m
			WHERE m.number = @AccountID
			AND m.qlevel NOT IN ('998', '999')
		end
	end 
	else begin
		if @TotalType = 0 begin
			SELECT @LinkedBalance = SUM(m.current0)
			FROM Master m
			WHERE m.Link = @Link
			AND m.qlevel NOT IN ('998', '999')
		end
		else if @TotalType = 1 begin	
			SELECT @LinkedBalance = SUM(m.current1)
			FROM Master m
			WHERE m.Link = @Link
			AND m.qlevel NOT IN ('998', '999')
		end
		else if @TotalType = 2 begin	
			SELECT @LinkedBalance = SUM(m.current2)
			FROM Master m
			WHERE m.Link = @Link
			AND m.qlevel NOT IN ('998', '999')
		end
	end
	if @LinkedBalance is null
	begin
		set @LinkedBalance = 0
	end
GO
