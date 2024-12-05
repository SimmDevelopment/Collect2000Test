SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[NbizAddExtraData] AS
--
--	Loads Extra data info from NBExtraData table to ExtraData table
--
begin transaction
insert extradata 
select * from nbextradata
if @@error <> 0 
    begin
	rollback tran
	return
    end
commit transaction










GO
