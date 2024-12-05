SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetAllActions    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE PROCEDURE [dbo].[LionGetAllActions]
AS
	SET NOCOUNT ON;
SELECT code, Description, ctl, WasAttempt, WasWorked FROM dbo.LionActionView with (nolock)
GO
