SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Verify_TransUnionCPE]
AS
BEGIN
--make sure that it created the proc
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Create_TransUnionCPE')
	RAISERROR (N'fusion_Create_TransUnionCPE stored proc missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Process_TransUnionCPE')
	RAISERROR (N'fusion_Process_TransUnionCPE stored proc missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_FixServicesCPETable')
	RAISERROR (N'fusion_FixServicesCPETable stored proc missing',15,1,N'number',5);
--verify tables exist and columns are correct
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_CPE') 
	RAISERROR (N'Services_CPE table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_CPE_CH01') 
	RAISERROR (N'Services_CPE_CH01 table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_CPE_IN01') 
	RAISERROR (N'Services_CPE_IN01 table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_CPE_SC01') 
	RAISERROR (N'Services_CPE_SC01 table missing',15,1,N'number',5);
--make sure service exists
if not exists(select * from Services where Description='TU CPE Service')
	RAISERROR (N'Service missing',15,1,N'number',5);

Declare @expectedManifestId uniqueidentifier
set @expectedManifestId='D816C19B-53F6-42db-94E3-7D4CE4FFBBF8'
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
if not exists(select * from Custom_CustomerReference where TreePath='Clients\Latitude Fusion\TransUnion\CPE')
	RAISERROR (N'Exchange client missing',15,1,N'number',5); 
--Check the num conditions created
Declare @numExpectedConditions int
Declare @numConditions int
set @numExpectedConditions=112
select @numConditions=count(*) from querydesignerconditions where path like '%Latitude Fusion\TransUnion\CPE\Services_CPE%'
if( @numExpectedConditions != @numConditions )
	RAISERROR (N'Mismatch between number expected (%i) and actual (%i) conditions',15,1,@numExpectedConditions, @numConditions);

END
GO
