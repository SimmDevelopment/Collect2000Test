SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetAllResults    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE PROCEDURE [dbo].[LionGetAllResults]
AS
	SET NOCOUNT ON;
SELECT code, ctl, Description, worked, contacted, note FROM dbo.LionResultView with (nolock)

GO
