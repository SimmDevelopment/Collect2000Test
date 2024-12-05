SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Verify_LexisNexisSkipTrace]
AS
BEGIN
--make sure that it created the proc
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Create_LexisNexisSkipTrace')
	RAISERROR (N'stored proc missing',15,1,N'number',5);
--verify tables exist and columns are correct
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace') 
	RAISERROR (N'Services_LexisNexis_SkipTrace table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_Nixie') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_Nixie table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_Return') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_Return table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_SSN') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_SSN table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_EDA') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_EDA table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_Deceased') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_Deceased table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_Bankruptcy') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_Bankruptcy table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_341') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_341 table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_Attorney') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_Attorney table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_SkipTrace_Terminator') 
	RAISERROR (N'Services_LexisNexis_SkipTrace_Terminator table missing',15,1,N'number',5);
--make sure service exists
if not exists(select * from Services where Description='LexisNexis SkipTrace Service')
	RAISERROR (N'Service missing',15,1,N'number',5);

Declare @expectedManifestId uniqueidentifier
set @expectedManifestId='7789F41A-D5C0-4203-8FB8-5D39D53AE9E8'
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
if not exists(select * from Custom_CustomerReference where TreePath='Clients\Latitude Fusion\LexisNexis\SkipTrace')
	RAISERROR (N'Exchange client missing',15,1,N'number',5); 
--Check the num conditions created
Declare @numExpectedConditions int
Declare @numConditions int
set @numExpectedConditions=277
select @numConditions=count(*) from querydesignerconditions where path like '%Latitude Fusion\LexisNexis\SkipTrace%'
if( @numExpectedConditions != @numConditions )
	RAISERROR (N'Mismatch between number expected (%i) and actual (%i) conditions',15,1,@numExpectedConditions, @numConditions);
	
END
GO
