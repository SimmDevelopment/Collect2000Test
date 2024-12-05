SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WorkFlow_InsertEventConfigByName]
	@eventName varchar(25),
	@class varchar(5),
	@customer varchar(7),
	@workFlowId uniqueidentifier,
	@actionType bit
AS
BEGIN
	SET NOCOUNT ON;

	if( @class='')
		set @class=null
	if( @customer='')
		set @customer=null


	Insert into WorkFlow_EventConfiguration(Class, Customer, EventID, WorkFlowID, ActionType)
	Select top 1 @Class,@Customer,ID,@WorkFlowId,@ActionType from WorkFlow_Events with (nolock) where name=@EventName
	
END
GO
