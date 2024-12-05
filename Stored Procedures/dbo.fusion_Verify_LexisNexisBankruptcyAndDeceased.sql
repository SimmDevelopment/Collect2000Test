SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Verify_LexisNexisBankruptcyAndDeceased]
AS
BEGIN
--make sure that it created the proc
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Create_LexisNexisBankruptcyDeceased')
	RAISERROR (N'stored proc missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Process_LexisNexisBankruptcyDeceased')
	RAISERROR (N'stored proc missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Process_LexisNexisDeceased')
	RAISERROR (N'stored proc missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='fusion_Process_LexisNexisBankruptcy')
	RAISERROR (N'stored proc missing',15,1,N'number',5);
	
--verify tables exist and columns are correct
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_Deceased') 
	RAISERROR (N'Services_LexisNexis_Deceased table missing',15,1,N'number',5);
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='Services_LexisNexis_Bankruptcy') 
	RAISERROR (N'Services_LexisNexis_Bankruptcy table missing',15,1,N'number',5);

--make sure service exists
if not exists(select * from Services where Description='LexisNexis Bankruptcy And Deceased')
	RAISERROR (N'Service missing',15,1,N'number',5);

Declare @expectedManifestId uniqueidentifier
set @expectedManifestId='9F3AB91A-20B6-49C3-8BB5-151F8D7A9592'
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
if not exists(select * from Custom_CustomerReference where TreePath='Clients\Latitude Fusion\LexisNexis\BankruptcyAndDeceased')
	RAISERROR (N'Exchange client missing',15,1,N'number',5); 

--Check the num conditions created
Declare @numExpectedConditions int
Declare @numConditions int
set @numExpectedConditions=15

select @numConditions=count(*) from querydesignerconditions where path like '%Latitude Fusion\LexisNexis\Deceased%'
if( @numExpectedConditions != @numConditions )
	RAISERROR (N'Mismatch between number expected (%i) and actual Lexis Nexis Deceased (%i) conditions',15,1,@numExpectedConditions, @numConditions);
		
set @numExpectedConditions=53
select @numConditions=count(*) from querydesignerconditions where path like '%Latitude Fusion\LexisNexis\Bankruptcy%'
if( @numExpectedConditions != @numConditions )
	RAISERROR (N'Mismatch between number expected (%i) and actual Lexis Nexis Bankruptcy (%i) conditions',15,1,@numExpectedConditions, @numConditions);

END
GO
