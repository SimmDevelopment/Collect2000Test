SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [dbo].[NbizAddNBHardCopy] 
@number int,
@Hardcopytype smallint,
@HardCopydata text
as
--
--	Adds Hardcopy info into NBHardCopy.
--

		Insert NBHardcopy (number,hardcopytype,hardcopydata)
		values (@number,@hardcopytype,@hardcopydata)










GO
