SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Exchange_Data_Import_SBT_SMS_Inbound]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		declare @testImportFileName varchar(500)

		declare @ImportName varchar(100) = 'SBT_SMS_Inbound'

		drop table if exists #EDSS_Temp
	
		select * into #EDSS_Temp
		from Exchange_Data_SBT_SMS where import_complete = 0 and Import_Name = @ImportName

		select @testImportFileName = (select top 1 import_filename from #EDSS_Temp)

		if (charindex('\',@testImportFilename) <> 0)
		begin
			update #EDSS_Temp set import_fileName = right(Import_FileName,(charindex('\',Reverse(Import_FileName),0))-1) where import_complete = 0 and Import_Name = @ImportName and Import_FileName is not null;	
		end

		declare @importDate datetime = (select top 1 Import_date from #EDSS_Temp where import_complete = 0 and Import_Name = @ImportName);
		declare @FileName varchar(500) = (select top 1 Import_FileName from #EDSS_Temp where import_complete = 0 and Import_Name = @ImportName);

		--Procedure Code Starts - Code before this line should be prepping the data and setting variables

		--SELECT 
		--	data3 Phone 
		--FROM #eDSS_TEMP 
		--where data7 = 'stop'
		--except
		--select MobilePhoneNo Phone from Custom_SMSDeactivation


		--Procedure Code Ends - Code after this line is used for transaction, syncing and debugging - no logic should occur after this
			   
		update #EDSS_Temp
			set Import_Complete = 1, Import_Status = 'Imported Successfully'
		where Import_Complete = 0 and Import_Name = @ImportName
		
		--Sync Exchange_Data
		update edss
		set Import_Name = edsst.Import_Name
		,Import_FileName = edsst.Import_FileName
		,Import_Date = edsst.Import_Date
		,Import_Complete = edsst.Import_Complete
		,Import_Status = edsst.Import_Status
		,Data1 = edsst.Data1
		,Data2 = edsst.Data2
		,Data3 = edsst.Data3
		,Data4 = edsst.Data4
		,Data5 = edsst.Data5
		,Data6 = edsst.Data6
		,Data7 = edsst.Data7
		,Data8 = edsst.Data8
		,Data9 = edsst.Data9
		,Data10 = edsst.Data10
		,Data11 = edsst.Data11
		,Data12 = edsst.Data12
		,Data13 = edsst.Data13
		,Data14 = edsst.Data14
		,Data15 = edsst.Data15
		,Data16 = edsst.Data16
		,Data17 = edsst.Data17
		,Data18 = edsst.Data18
		,Data19 = edsst.Data19
		,Data20 = edsst.Data20
		from Exchange_Data_SBT_SMS edss join #EDSS_Temp edsst on edss.Exchange_Data_SBT_SMS_Id = edsst.Exchange_Data_SBT_SMS_Id
				
		--select * from #EDSS_Temp

		--select * from Exchange_Data_SBT_SMS where import_name = @ImportName

		--ROLLBACK TRANSACTION
		
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		THROW;

		WHILE @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

	END CATCH
	
END
GO
