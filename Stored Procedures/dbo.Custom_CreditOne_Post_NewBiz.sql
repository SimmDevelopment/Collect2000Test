SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CreditOne_Post_NewBiz] 
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @phonetype1 varchar(1)
declare @phone1 varchar(10)
declare @phonetype2 varchar(1)
declare @phone2 varchar(10)
declare @phonetype3 varchar(1)
declare @phone3 varchar(10)

select @phonetype1 = substring(otherphone1, 1, 1), @phone1 = right(otherphone1, 10), @phonetype2 = substring(otherphone2, 1, 1), @phone2 = right(otherphone2, 10), @phonetype3 = substring(otherphone3, 1, 1), @phone3 = right(otherphone3, 10)
from debtors with (nolock) 
where number = @number and seq = 0 and ((otherphone1 is not null or otherphone1 <> ''))


if @phonetype1 = 'B'
	begin
		update master
		set workphone = @phone1
		where number = @number

		update debtors
		set workphone = @phone1, otherphone1 = null
		where number = @number and seq = 0
	end
	
	if @phonetype1 = 'H'
			begin
				update master
				set homephone = @phone1
				where number = @number

				update debtors
				set homephone = @phone1, otherphone1 = null
				where number = @number and seq = 0
			end

			if @phonetype1 = 'M'
					begin
						update debtors
						set pager = @phone1
						where number = @number and seq = 0
					end

	if @phonetype2 = 'H'
		begin
				update master
				set homephone = @phone2
				where number = @number

				update debtors
				set homephone = @phone2, otherphone2 = null
				where number = @number and seq = 0
			end

				if @phonetype2 = 'M'
					begin
						update debtors
						set pager = @phone2, otherphone2 = null
						where number = @number and seq = 0
					end

	if @phonetype3 = 'M'
		begin
			update debtors
			set pager = @phone3, otherphone3 = null
			where number = @number and seq = 0
		end

set @phonetype1 = ''
set @phone1 = ''
set @phonetype2 = ''
set @phone2 = ''
set @phonetype3 = ''
set @phone3 = ''


select @phonetype1 = substring(otherphone1, 1, 1), @phone1 = right(otherphone1, 10), @phonetype2 = substring(otherphone2, 1, 1), @phone2 = right(otherphone2, 10), @phonetype3 = substring(otherphone3, 1, 1), @phone3 = right(otherphone3, 10)
from debtors with (nolock) 
where number = @number and seq = 1 and ((otherphone1 is not null or otherphone1 <> ''))


if @phonetype1 = 'B'
	begin
		update debtors
		set workphone = @phone1, otherphone1 = null
		where number = @number and seq = 1
	end
	if @phonetype1 = 'H'
		begin
			update debtors
			set homephone = @phone1, otherphone1 = null
			where number = @number and seq = 1
		end
		if @phonetype1 = 'M'
			begin
				update debtors
				set pager = @phone1
				where number = @number and seq = 1
			end
	if @phonetype2 = 'H'
		begin
				update debtors
				set homephone = @phone2, otherphone2 = null
				where number = @number and seq = 1
			end
				if @phonetype2 = 'M'
					begin
						update debtors
						set pager = @phone2, otherphone2 = null
						where number = @number and seq = 1
					end
	if @phonetype3 = 'M'
					begin
						update debtors
						set pager = @phone3, otherphone3 = null
						where number = @number and seq = 1
					end
END
GO
