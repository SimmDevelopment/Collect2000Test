SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Verify_ExperianDPE]
AS
BEGIN
--make sure that it created the proc
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Create_ExperianDPE')
	RAISERROR (N'fusion_Create_ExperianDPE stored proc missing',15,1,N'number',5);
--verify tables exist and columns are correct
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_DPE') 
	RAISERROR (N'Services_DPE table missing',15,1,N'number',5);
--make sure service exists
if not exists(select * from Services where Description='Experian DPE')
	RAISERROR (N'Service missing',15,1,N'number',5);

Declare @expectedManifestId uniqueidentifier
set @expectedManifestId='0738FE3D-CD22-40f3-B0D8-31EB0F88B3E5'
if not exists(select * from Services where manifestid=@expectedManifestId)
	RAISERROR(N'Service missing',15,1,N'number',5);

--make sure service is enabled
Declare @serviceId int
select @serviceid=ServiceID from Services where manifestid=@expectedManifestId

Declare @numCustomers int
select @numCustomers=count(*) from Customer
Declare @numEnabledCustomers int

select @numEnabledCustomers=count(*) from ServicesCustomers where serviceId=@serviceId

if( @numCustomers != @numEnabledCustomers )
	RAISERROR(N'All customers not enabled',15,1,N'number',5);

--make sure Exchange client was created
if not exists(select * from Custom_CustomerReference where TreePath='Clients\Latitude Fusion\Experian\DPE')
	RAISERROR (N'Exchange client missing',15,1,N'number',5); 
--Check the num conditions created
Declare @numExpectedConditions int
Declare @numConditions int
set @numExpectedConditions=88
select @numConditions=count(*) from querydesignerconditions where path like '%Latitude Fusion\Experian\DPE\Services_DPE%'
if( @numExpectedConditions != @numConditions )
	RAISERROR (N'Mismatch between number expected (%i) and actual (%i) conditions',15,1,@numExpectedConditions, @numConditions);

END
GO
