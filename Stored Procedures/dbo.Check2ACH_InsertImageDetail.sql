SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Check2ACH_InsertImageDetail]
@imagecontents image,
@batch int,
@sequence int
AS
UPDATE Check2ACH_BatchDetail
SET imagecontents = @imagecontents
WHERE batch = @batch AND sequence = @sequence



GO
