SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Exchange_NSF_Import_PostProcedure]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
        BEGIN TRANSACTION NSF; -- Give the transaction a name

/*
	
		select * from Exchange_Data
		select * from Exchange_NSF_Import_History

*/

		declare @runRank int;
		declare @maxRank int;

		--Import New Records
		insert into Exchange_NSF_Import_History (Exchange_Data_Id,pdc_id,amount, pdcdate,nsf_description)
		select Exchange_Data_Id, data1, data2, replace(data3,'#',''), data4 
		from Exchange_Data 
		where Exchange_Data_Id not in ( select Exchange_Data_Id from Exchange_NSF_Import_History)
			and Import_Name = 'NSF Import'

		--Apply Run Rank
		select @maxRank = (select max(import_rank) from Exchange_NSF_Import_History)
		
		if (@maxRank = 0 )
			begin
				update Exchange_NSF_Import_History set Import_Rank = 1
				set @runRank = 1
			end
		else
			begin
				set @runRank = @maxRank + 1
				update Exchange_NSF_Import_History set Import_Rank = @runRank where Import_Rank = 0
			end

		--check if all pdcid's exists
		update h
		set import_complete = 1, Reversal_Status = 'PDCID Not Found'
		from Exchange_NSF_Import_History h 
		where pdc_id in 
		(
			select pdc_id 
			from Exchange_NSF_Import_History 
			where Import_rank = @runRank 
				and pdc_id not in (select uid from pdc)
		)
		
		--Update PaymentLinkUid
		update h 
		set h.PaymentLinkUID = p.PaymentLinkUID
		from Exchange_NSF_Import_History h join pdc p with (nolock) on h.PDC_ID = p.UID

		select * from payhistory where PaymentLinkUID in (select paymentlinkuid from Exchange_NSF_Import_History)


		select * from Exchange_Data
		select * from Exchange_NSF_Import_History
		--select * from Collect2000SIMM.dbo.pdc where uid = 1579074






        PRINT '>> ROLLING BACK'
        ROLLBACK TRANSACTION NSF; -- The semi-colon is required (at least in SQL 2012)

        --PRINT '>> COMMITING'
        --COMMIT TRANSACTION NSF;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN 
            PRINT '>> ROLLING BACK'
            ROLLBACK TRANSACTION NSF; -- The semi-colon is required (at least in SQL 2012)
            
            
        END; 
        THROW
    END CATCH

END
GO
