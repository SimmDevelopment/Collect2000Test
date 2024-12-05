CREATE ROLE [db_latitude]
AUTHORIZATION [db_securityadmin]
GO
ALTER ROLE [db_latitude] ADD MEMBER [SIMM2K1\divinity]
GO
ALTER ROLE [db_latitude] ADD MEMBER [SIMM2K1\divinity2]
GO
ALTER ROLE [db_latitude] ADD MEMBER [SIMM2K1\nctyler]
GO
ALTER ROLE [db_latitude] ADD MEMBER [SIMM2K1\zacharys]
GO
GRANT CREATE TABLE TO [db_latitude]
GRANT EXECUTE TO [db_latitude]
