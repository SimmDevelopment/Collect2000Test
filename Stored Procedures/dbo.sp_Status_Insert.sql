SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Status_Insert*/
CREATE   PROCEDURE [dbo].[sp_Status_Insert]
(
	@Code varchar(5),
	@Description varchar(30),
	@StatusType varchar(30),
	@ReturnDays smallint,
	@ReduceStats int,
	@CbrReport bit,
	@IsBankruptcy bit,
	@IsDeceased bit,
	@CaseCount bit,
	@CbrDelete bit,	
	@IsPIF bit,
	@IsSIF bit,	
	@IsDisputed bit
)
AS
-- Name:		sp_Status_Insert
-- Function:		This procedure will insert a new Status in Status table
-- 			using input parameters.
-- Creation:		7/3/2002 jc
--			Used by class CStatusCodeFactory. 
-- Change History:	7/1/2004 jc added support for new columns IsBankruptcy, IsDeceased, CaseCount
--							7/8/2005 jc added support for new columns cbrDelete, IsPIF, IsSIF, IsDisputed
    BEGIN TRAN
	INSERT INTO Status
		(code, Description, StatusType, ReturnDays, ReduceStats, CbrReport,
		IsBankruptcy, IsDeceased, CaseCount, CbrDelete, IsPIF, IsSIF, IsDisputed)
	VALUES(
		@Code, @Description, @StatusType, @ReturnDays, @ReduceStats, @CbrReport,
		@IsBankruptcy, @IsDeceased, @CaseCount, @CbrDelete, @IsPIF, @IsSIF, @IsDisputed)

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Status_Insert: Cannot insert into Status table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
