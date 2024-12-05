SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_SynchronizePhones]
   
AS 

	DECLARE @Updated TABLE (
		[number] INTEGER NOT NULL, 
		[PhoneNumber] varchar(30) NOT NULL, 
		[phonestatusid] INTEGER NOT NULL 
	)
	
	DECLARE	@UpdatedBy VARCHAR(10);

    SELECT @UpdatedBy = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();

	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
    UPDATE  dbo.phones_master
    SET     UpdatedBy = @UpdatedBy, --'Linking'
	        LastUpdated = GETDATE(),
			phonestatusid = CASE WHEN badcount > 0 THEN 1
								 WHEN badcount = 0 and goodcount > 0 THEN 2
								 ELSE 0

      END

    OUTPUT Inserted.number,Inserted.PhoneNumber, Inserted.phonestatusid INTO @Updated

    FROM    ( SELECT    pm2.phonenumber,
                        m2.link,
                        SUM(CASE pm2.phonestatusid
                              WHEN 2 THEN 1
                              ELSE 0
                            END) AS goodcount,
                        SUM(CASE pm2.phonestatusid
                              WHEN 1 THEN 1
                              ELSE 0
                            END) AS badcount
              FROM      dbo.phones_master pm2
                        INNER JOIN dbo.master m2 ON pm2.number = m2.number
              WHERE     link > 0
                        AND link IS NOT NULL
              GROUP BY  pm2.phonenumber,
                        m2.link
            ) x
            INNER JOIN dbo.master m ON x.link = m.link
            INNER JOIN dbo.phones_master ON m.number = phones_master.number
    WHERE   x.phonenumber = phones_master.phonenumber and isnull(phonestatusid,0) <> CASE WHEN badcount > 0 THEN 1 ELSE 2 END 


INSERT INTO .[dbo].[notes]
           ([number]
           ,[ctl]
           ,[created]
           ,[user0]
           ,[action]
           ,[result]
           ,[comment]
           ,[Seq]
           ,[IsPrivate]
           ,[UtcCreated])
     SELECT
           number 
           ,'Lnk' as ctl
           ,Getdate() as created
           ,'Linking' as user0
           ,'CO' as action
           ,'CO' as result
           ,'Linked PhoneNumber ' + rtrim(phonenumber) + ' changed to ' + case when phonestatusid = 1 then 'Bad' Else 'Good' + ' Status' End as comment
           ,0 as Seq
           , 0 as IsPrivate
           ,GetUTCDate() as UtcCreated
    FROM @Updated
	where phonestatusid > 0 --added this where statement to reduce the unwanted notes on accounts that have unknown phone numbers Padrick
GO
