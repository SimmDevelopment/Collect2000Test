SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[LionCanUserViewNotes]
(
	@LionUserId int,
	@canView bit output
)
AS
set @canView=1
	SET NOCOUNT ON;
SELECT @canView = CanViewNotes FROM lionuserpermissions
where LionUserId=@LionUserId

GO
