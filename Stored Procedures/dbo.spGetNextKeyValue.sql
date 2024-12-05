SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		William Winton
-- Create date: 2010-02-01
-- Description:	Get the next valid virtual key value from the Sys_NextRef table for a given seriesname value.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.spGetNextKeyValue.sql $
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 16:53:31-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Added procedures from 9 
--  
-- =============================================
CREATE PROCEDURE [dbo].[spGetNextKeyValue]
    @SeriesName varchar(50),
    @KeyBlockSize int = null,
    @ShowOutput int = 1
as
 
declare @NextID int
declare @LastID int
 
declare @nocountstate int
set @nocountstate = (@@OPTIONS & 512)
set nocount on
 
begin tran
 
select @NextID = LastRefID from Sys_NextRef (updlock) where SeriesName = @SeriesName
if @NextID is null
begin
    set @NextID = 1
    if @KeyBlockSize is null set @LastID = @NextID else set @LastID = @NextID + @KeyBlockSize - 1
    insert into Sys_NextRef (SeriesName, LastRefID) select @SeriesName, @LastID
end
else
begin
    set @NextID = @NextID + 1
    if @KeyBlockSize is null set @LastID = @NextID else set @LastID = @NextID + @KeyBlockSize - 1
    update Sys_NextRef set LastRefID = @LastID where SeriesName = @SeriesName
end
 
commit tran
 
if (@nocountstate = 0) set nocount off
 
if @ShowOutput = 1 select NextID = @NextID, LastID = @LastID
return @NextID

GO
