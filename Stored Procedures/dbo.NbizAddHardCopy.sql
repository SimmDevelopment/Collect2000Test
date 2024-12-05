SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NbizAddHardCopy]
AS --
--	Adds records to Hardcopy table from NBHardcopy
--
    BEGIN TRANSACTION

    INSERT  INTO [dbo].[HardCopy]
            ( [number],
              [ctl],
              [hardCopyType],
              [hardCopyData] )
            SELECT  [number],
                    [ctl],
                    [hardCopyType],
                    [hardCopyData]
            FROM    [dbo].[NBHardCopy]

    IF @@error <> 0 
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END 
    COMMIT TRANSACTION

GO
