SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Master_GetItemBySsn*/
CREATE Procedure [dbo].[sp_Master_GetItemBySsn]
	@Ssn varchar(15)
AS
-- Name:		sp_Master_GetItemBySsn
-- Creation:		06/2003 
--			Used by manual new business entry.
-- Change History:	7/9/2004 jc added replace statements to ensure no dashes.

	select * from master where replace(ssn,'-','') = replace(@Ssn,'-','')
GO
