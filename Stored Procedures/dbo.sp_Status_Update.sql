SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*PROCEDURE sp_Status_Update*/
CREATE   PROCEDURE [dbo].[sp_Status_Update]
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
-- Name:		sp_Status_Update
-- Function:		This procedure will update an Status item in Status table
-- 			using input parameters.
-- Creation:		7/3/2002 jc
--			Used by class CStatusCodeFactory. 
-- Change History:	7/1/2004 jc added support for new columns IsBankruptcy, IsDeceased, CaseCount
--							7/8/2005 jc added support for new columns cbrDelete, IsPIF, IsSIF, IsDisputed
    BEGIN TRAN
	UPDATE Status
		SET Description = @Description,
		StatusType = @StatusType,
		ReturnDays = @ReturnDays,
		ReduceStats = @ReduceStats,
		CbrReport = @CbrReport,
		IsBankruptcy = @IsBankruptcy,
		IsDeceased = @IsDeceased,
		CaseCount = @CaseCount,
		CbrDelete = @CbrDelete,	
		IsPIF = @IsPIF,
		IsSIF = @IsSIF,	
		IsDisputed = @IsDisputed
		
	WHERE code = @Code

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Status_Update: Cannot update Status table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
