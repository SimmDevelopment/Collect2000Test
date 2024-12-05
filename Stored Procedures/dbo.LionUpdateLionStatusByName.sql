SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionUpdateLionStatusByName    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 01/02/2007
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionUpdateLionStatusByName]
	@StatusCode varchar(5),
	@NewStatus varchar(5),
	@NewDescription varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	if exists(select * from LionStatus with (nolock) where StatusCode=@StatusCode)
	BEGIN
		delete From LionStatus where StatusCode=@StatusCode
	END

	Insert into LionStatus([StatusCode],[NewStatus],[NewDescription])
	Values(@StatusCode,@NewStatus,@NewDescription)

END

GO
