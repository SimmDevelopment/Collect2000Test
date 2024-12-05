SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 09/25/2006
-- Description:	This is the StoredProc that will get the fusion config for the key specified
-- =============================================
CREATE PROCEDURE [dbo].[fusion_GetConfig]
	@name varchar(255)
AS
BEGIN

	SET NOCOUNT ON;

	Select Config		as [Config]
	From FusionConfig
	Where Name=@name

END
GO
