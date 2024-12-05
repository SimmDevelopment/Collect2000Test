SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Verify_ExperianCollectionTriggers]
AS
BEGIN
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Create_ExperianCollectionTriggers')
	RAISERROR (N'stored proc missing [fusion_Create_ExperianCollectionTriggers]',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Process_ExperianCollectionTriggers')
	RAISERROR (N'stored proc missing [fusion_Process_ExperianCollectionTriggers]',15,1,N'number',5);

if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_ServicesCTDeleteDupes')
	RAISERROR (N'stored proc missing [fusion_ServicesCTDeleteDupes]',15,1,N'number',5);

if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_ServicesCTCreateDeletedDupesTable')
	RAISERROR (N'stored proc missing [fusion_ServicesCTCreateDeletedDupesTable]',15,1,N'number',5);

--make sure service exists
if not exists(select * from Services where Description='Collection Triggers Service')
	RAISERROR (N'Service missing',15,1,N'number',5);

Declare @expectedManifestId uniqueidentifier
set @expectedManifestId='3A06D872-9931-4F6E-804E-112323FB1588'
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
if not exists(select * from Custom_CustomerReference where TreePath='Clients\Latitude Fusion\Experian\Collection Triggers')
	RAISERROR (N'Exchange client missing',15,1,N'number',5); 
--Check the num conditions created
Declare @numExpectedConditions int
Declare @numConditions int

set @numExpectedConditions=96
select @numConditions=count(*) from querydesignerconditions where path like '%Latitude Fusion\Experian\Collection Triggers%'

if( @numExpectedConditions != @numConditions )
	RAISERROR (N'Mismatch between number expected (%i) and actual (%i) conditions',15,1,@numExpectedConditions, @numConditions);

END
GO
