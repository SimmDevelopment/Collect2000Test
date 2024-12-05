SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jeff Mixon
-- Create date: 	11/1/2006
-- Description:	Will determine the current version for Fusion
-- =============================================
CREATE PROCEDURE [dbo].[Custom_FusionGetVersion]
	-- Add the parameters for the stored procedure here
	@build int output,
	@minor int output,
	@major int output
--,	@ok bit output
AS
BEGIN
	SET NOCOUNT ON;
IF EXISTS(select * from dbo.sysobjects where id = object_id(N'[dbo].Fusion_AppSettings') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	Select @major=[Value]
	From Fusion_AppSettings
	where [ID]='Build.Major'

	Select @minor=[Value]
	From Fusion_AppSettings
	where [ID]='Build.Minor'

	Select @build=[Value]
	From Fusion_AppSettings
	where [ID]='Build.Build'
END
END
GO
