SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

 
CREATE PROCEDURE [dbo].[Custom_Auto_GetAllNameIds]
	--@Name	varchar(200)
AS
BEGIN
	SET NOCOUNT ON;

    Select	[ID]					as	[ID],
			[Name]					as	[Name],
			[ProcessType]			as  [ProcessType]
	From	Custom_ExchangeAuto
END

GO
