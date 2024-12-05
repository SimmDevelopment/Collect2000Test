SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[cbrUpdatePendingNonEvaluated_NoCursor]
   
AS 
    BEGIN

				--account for bankruptcies in a filed status

				DECLARE @CurrentPaymentHistoryDate DATETIME;
				SELECT @CurrentPaymentHistoryDate = DATEADD(d,-1,CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)),2) + '01' AS DATETIME));
					
				WITH PaymentProfile AS (
				SELECT cw.number as number,cw.primarydebtorid,
								
				CASE WHEN cw.nextinformationindicator IN ('A','B','C','D') AND DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) >=0 and DATEDIFF(m,cw.[PaymentHistoryDateEoM], @CurrentPaymentHistoryDate)-DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) > 0
					 THEN		
						SUBSTRING(REPLICATE('D', CASE WHEN DATEDIFF(m,cw.[DateFiledEoM], cw.[PaymentHistoryDateEOM]) >=24 THEN 24 ELSE case when DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) = 0 then 1 else DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1 end  END)
								+ REPLICATE('L', ABS(DATEDIFF(m,cw.[PaymentHistoryDateEOM], @CurrentPaymentHistoryDate)-(DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1))) + SUBSTRING( [mco].[PaymentHistoryProfile], case when datediff(m,@CurrentPaymentHistoryDate ,cw.[PaymentHistoryDateEoM])>=0 then DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) else 1 end, 24) ,1,24) 
								
					 WHEN cw.nextinformationindicator IN ('A','B','C','D') AND DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) >= 0 and DATEDIFF(m,cw.[PaymentHistoryDateEOM], @CurrentPaymentHistoryDate)-DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) <= 0
					 THEN
				 		SUBSTRING(REPLICATE('D', CASE WHEN DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1 >=24 THEN 24 ELSE case when DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) = 0 then 1 else DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1 end  END)
				 			+ SUBSTRING([mco].[PaymentHistoryProfile],DATEDIFF(m,cw.[DateFiledEoM], cw.[PaymentHistoryDateEOM])+2,24) ,1,24) 
				 												
					 WHEN cw.nextinformationindicator IN ('E','F','G','H')  AND DATEDIFF(m,cw.[DischargeDateEoM], @CurrentPaymentHistoryDate) >= -1 
						AND cw.[DateFiledEoM] IS Not NULL  
					 THEN		--keepng discharges as D and not reverting to L chargeoff	
						SUBSTRING(REPLICATE('D', CASE WHEN DATEDIFF(m,cw.DischargeDateEoM, @CurrentPaymentHistoryDate)+1 >=24 THEN 24 ELSE DATEDIFF(m,cw.DischargeDateEoM, @CurrentPaymentHistoryDate)+1   END)
							+ REPLICATE('D', CASE WHEN DATEDIFF(m,cw.DateFiledEoM, cw.DischargeDateEoM) > 0 THEN  DATEDIFF(m,cw.DateFiledEoM, cw.DischargeDateEoM) ELSE 1 END)
							+ CASE WHEN DATEDIFF(m,cw.PaymentHistoryDateEoM, @CurrentPaymentHistoryDate)+1 < 24 THEN  REPLICATE('L',Case when  cw.DateFiledEoM > cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.PaymentHistoryDateEoM,cw.DateFiledEoM )-1 else 0 End) 
							+ SUBSTRING(mco.PaymentHistoryProfile,case when @CurrentPaymentHistoryDate >= cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.DateFiledEoM, cw.PaymentHistoryDateEoM )+2 else 1 end,24-(case when DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) >=24 THEN 0 ELSE DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) End ))  	ELSE REPLICATE('L',24) END ,1,24)
					 
					 WHEN cw.nextinformationindicator IN ('I','J','K','L') AND DATEDIFF(m,cw.[DismissalDateEom], @CurrentPaymentHistoryDate) >= -1
					 THEN
						SUBSTRING(REPLICATE('L', CASE WHEN DATEDIFF(m,cw.DismissalDateEom, @CurrentPaymentHistoryDate)+1 >=24 THEN 24 ELSE DATEDIFF(m,cw.DismissalDateEom, @CurrentPaymentHistoryDate)+1   END)
							+ REPLICATE('D', CASE WHEN DATEDIFF(m,cw.DateFiledEoM, cw.DismissalDateEom) > 0 THEN  DATEDIFF(m,cw.DateFiledEoM, cw.DismissalDateEom) ELSE 0 END)
							+ REPLICATE('L',Case when  cw.DateFiledEoM > cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.PaymentHistoryDateEoM,cw.DateFiledEOM )-1 else 0 End) 
							+ SUBSTRING(mco.PaymentHistoryProfile,case when @CurrentPaymentHistoryDate >= cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.DateFiledEoM, cw.PaymentHistoryDateEoM)+2 else 1 end,24-(case when DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) >=24 THEN 0 ELSE DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) End ))  ,1,24)
				ELSE
					 cw.PaymentHistoryProfile
				END
					AS PaymentHistoryProfile
			
			
				FROM 
				#cbrwork cw
				INNER JOIN [MasterChargeOff] AS [mco] ON cw.[number] = [mco].[number]
				INNER JOIN Debtors d ON cw.primarydebtorid = d.debtorid
				LEFT OUTER JOIN [dbo].[bankruptcy] b ON d.debtorid = b.debtorid
				WHERE d.seq = 0 
				)
				UPDATE  #cbrwork
				SET PaymentHistoryProfile = PaymentProfile.PaymentHistoryProfile
				FROM PaymentProfile
				JOIN #cbrwork ON #cbrwork.primarydebtorid = PaymentProfile.primarydebtorid;
				
								
 				DECLARE @rowcount INT;
				Declare @OutParms1 Table (AccountID INT);
				
                UPDATE  dbo.cbr_accounts
                SET     accountstatus = cw.nextaccountstatus, 
                        specialcomment = cw.NextSpecialComment,
                        complianceCondition = cw.NextComplianceCondition,
                        currentBalance = CASE WHEN cw.NextAccountStatus IN ('62','64') THEN 0
											  WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
											  WHEN cw.IsChargeOffData = 1 AND cw.nextinformationindicator in ('E','F','G','H') THEN 0
											  WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
                                              ELSE 0
                                         END,
                        originalcreditor = cw.nextoriginalcreditor,
                        creditorclassification = cw.NextCreditorClass,
                        accounttype = cw.accounttype,
                        paymenthistoryprofile = cw.paymenthistoryprofile,
                        paymenthistorydate = @CurrentPaymentHistoryDate,
                        lastpaymentdate = cw.lastpaymentdate,
                        actualPayment = CASE WHEN ISNULL(DATEDIFF(d,cw.lastpaymentdate,GETDATE()),0) < 39 THEN  ISNULL(cw.actualpaymentamount,0) ELSE 0 END,
										--ISNULL(DATEDIFF(d,cw.lastpaymentdate,cmw.DateReported),-1) < 0 AND 
                        lastupdated = CASE WHEN ( (cw.NextAccountStatus <> ISNULL(cmw.AccountStatus,'') OR  cw.NextAccountStatus <> COALESCE(cmw.LastAccountStatus,cmw.AccountStatus,'')) 
													OR ISNULL(cw.NextSpecialComment, '') <> ISNULL(cmw.SpecialComment, '')
													OR cw.nextoriginalcreditor <> ISNULL(cmw.originalcreditor,'')
													OR cw.NextCreditorClass <> ISNULL(cmw.creditorclassification,'')
													OR cw.accounttype <> ca.accounttype
													OR (cw.IsChargeOffData = 1 AND cw.SoldToPurchasedFrom <> ISNULL(cmw.SoldToPurchasedFrom,''))
												) 
												OR (ISNULL(cw.NextComplianceCondition,'') <> ISNULL(cmw.ComplianceCondition,'') AND ISNULL(cw.NextComplianceCondition,'') <> '')	
											THEN GETDATE() ELSE lastupdated END,
                        billingdate = CASE WHEN  cw.NextAccountStatus IN ('62','64') THEN ISNULL(cw.lastpaymentdate,GETDATE())
											WHEN cw.IsChargeOffData = 1 AND  cw.PortfolioIndicator = 2 THEN ISNULL(cw.PortfolioSoldDate,GETDATE())  
											WHEN cw.NextAccountStatus <> cmw.AccountStatus THEN GETDATE() 
											ELSE GETDATE() END,
                        amountpastdue = CASE WHEN cw.NextAccountStatus IN ('11','62','64') THEN 0 
											 WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
											 WHEN cw.IsChargeOffData = 1 AND cw.nextinformationindicator in ('E','F','G','H','D') THEN 0
                        					 WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
											 ELSE 0 END,
											 
                        SoldToPurchasedFrom = CASE WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator IS NOT NULL THEN cw.SoldToPurchasedFrom
												   ELSE '' END,
						PortfolioIndicator = CASE WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator IS NOT NULL THEN cw.PortfolioIndicator
												   ELSE 0 END,						   
						ClosedDate = CASE WHEN cw.IsChargeOffData = 1 THEN cw.ClosedDate ELSE NULL END
						OUTPUT INSERTED.accountID INTO @OutParms1

                FROM    #PendingNonEvaluated pne
						INNER JOIN #cbrwork cw on cw.number = pne.AccountID
                        INNER JOIN dbo.cbr_accounts ca ON ca.accountid =  pne.AccountID
                        LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                                                        AND cmw.debtorid = cw.primarydebtorid
                       
                                                          
                WHERE   (ca.accountstatus NOT IN ( 'DA', 'DF' ) AND ISNULL(cmw.LastAccountStatus,'') NOT IN ( 'DA', 'DF' ))
						AND  cw.StatusCbrReport = 1 
						;
                         
                                                       
                                                                             
                  
				SELECT @rowcount = ISNULL(COUNT(*),0) FROM @OutParms1
                IF @rowcount > 0 
                    BEGIN	

                        INSERT  INTO dbo.cbr_audit
                                ( accountid,
                                  debtorid,
                                  datecreated,
                                  [user],
                                  comment )
                                SELECT  cw.number,
                                        NULL,
                                        GETDATE(),
                                        'SYSTEM',
                                        cac.audittext
                                FROM    #cbrwork cw
                                        INNER JOIN dbo.cbr_accounts ca ON ca.accountid = cw.number
                                        INNER JOIN @OutParms1 AS op ON ca.accountID = op.accountID
                                        CROSS JOIN #CbrAuditComments cac 
                                WHERE   ca.lastUpdated >= CONVERT(varchar(8),GETDATE(),112)
                                AND		cac.audittype = 1 ;             
                    END

                
	
						-- existing account that did not have a status change but received a payment
						Declare @OutParms2 Table (AccountID INT);
						
                        UPDATE  dbo.cbr_accounts
                        SET     currentbalance = CASE WHEN cw.NextAccountStatus IN ('62','64') THEN 0
													WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
													WHEN cw.IsChargeOffData = 1 AND cw.nextinformationindicator in ('E','F','G','H') THEN 0
													WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
													ELSE 0
                                         END,
                                amountpastdue = CASE WHEN cw.NextAccountStatus IN ('11','62','64') THEN 0 
													WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
													WHEN cw.IsChargeOffData = 1 AND cw.nextinformationindicator in ('E','F','G','H','D') THEN 0
                        							WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
													ELSE 0 END,
								paymenthistoryprofile = cw.paymenthistoryprofile,
								paymenthistorydate = @CurrentPaymentHistoryDate,
								lastpaymentdate = cw.lastpaymentdate,
								actualPayment = CASE WHEN ISNULL(DATEDIFF(d,cw.lastpaymentdate,GETDATE()),0) < 39 THEN  ISNULL(cw.actualpaymentamount,0) ELSE 0 END,
														--ISNULL(DATEDIFF(d,cw.lastpaymentdate,cmw.DateReported),-1) < 0 AND 
								lastupdated = CASE WHEN (ROUND(ca.currentbalance,0,1) <> ROUND(coalesce(cmw.openbalance,cw.nextcurrentbalance),0,1)) then GETDATE() else lastupdated END,
                                
                                billingdate = CASE WHEN cw.NextAccountStatus IN ('62','64') THEN ISNULL(cw.lastpaymentdate,GETDATE())
												WHEN cw.IsChargeOffData = 1 AND  cw.PortfolioIndicator = 2 THEN ISNULL(cw.PortfolioSoldDate,GETDATE())  
												ELSE GETDATE() END
								OUTPUT INSERTED.accountID INTO @OutParms2				 		  	  					   
                        FROM    #PendingNonEvaluated pne
						INNER JOIN #cbrwork cw on cw.number = pne.AccountID
                        INNER JOIN dbo.cbr_accounts ca ON ca.accountid =  pne.AccountID
                        LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                                                        AND cmw.debtorid = cw.primarydebtorid
                        WHERE   (ca.accountstatus NOT IN ( 'DA', 'DF' ) AND ISNULL(cmw.LastAccountStatus,'') NOT IN ( 'DA', 'DF' ))
								AND  cw.StatusCbrReport = 1 
                                ;
						SELECT @rowcount = ISNULL(COUNT(*),0) FROM @OutParms2
                        IF @rowcount > 0 
                            BEGIN

                                INSERT  INTO dbo.cbr_audit
                                        ( accountid,
                                          debtorid,
                                          datecreated,
                                          [user],
                                          comment )
                                        SELECT  cw.number,
                                                NULL,
                                                GETDATE(),
                                                'SYSTEM',
                                                cac.audittext
                                        FROM    dbo.cbr_accounts ca
												INNER JOIN #cbrwork cw ON cw.number = ca.accountid
                                                INNER JOIN @OutParms2 AS op ON ca.accountID = op.accountID
                                                CROSS JOIN #CbrAuditComments cac 																								  
                                        WHERE   ca.accountstatus NOT IN ( 'DA', '62', '64', 'DF' )
                                                AND ca.lastUpdated >= CONVERT(varchar(8),GETDATE(),112)
                                                AND cac.audittype = 2;
                            END

                   


		Declare @OutParms4 Table (AccountID INT);
		--update existing debtors
        UPDATE  cbr_debtors
        SET     ecoacode = cw.nextecoacode,
                informationindicator = cw.nextinformationindicator,
                transactiontype = cw.NextTransactionType, 
                [name] = LEFT(ISNULL(d.[name],''),30),
                surname = LEFT(ISNULL(d.[lastname],''),50),
                firstname = LEFT(ISNULL(d.firstname,''),50),
                middlename = LEFT(ISNULL(d.middlename,''),50),
                suffix = LEFT(ISNULL(d.suffix,''),50),
                generationcode = CASE WHEN UPPER(d.suffix) = 'SENIOR'
                                           OR d.suffix = 'SR.'
                                           OR d.suffix = 'SR' THEN 'S'
                                      WHEN UPPER(d.suffix) = 'JUNIOR'
                                           OR d.suffix = 'JR.'
                                           OR d.suffix = 'JR' THEN 'J'
                                      WHEN UPPER(d.suffix) = 'II' THEN '2'
                                      WHEN UPPER(d.suffix) = 'III' THEN '3'
                                      WHEN UPPER(d.suffix) = 'IV' THEN '4'
                                      WHEN UPPER(d.suffix) = 'V' THEN '5'
                                      WHEN UPPER(d.suffix) = 'VI' THEN '6'
                                      WHEN UPPER(d.suffix) = 'VII' THEN '7'
                                      WHEN UPPER(d.suffix) = 'VIII' THEN '8'
                                      WHEN UPPER(d.suffix) = 'IX' THEN '9'
                                      ELSE ''
                                 END,
                ssn = LEFT(ISNULL(d.ssn, ''),15),
                address1 = LEFT(ISNULL(d.street1,''),50),
                address2 = LEFT(ISNULL(d.street2,''),50),
                city = LEFT(ISNULL(d.city,''),50),
                [state] = ISNULL(d.state,''),
                zipcode = d.zipcode,
                dob = CASE WHEN d.dob > '1900-01-01' and d.dob <> ISNULL(cd.dob,'') THEN d.dob
                                 ELSE cd.dob
                            END,
                lastupdated = CASE WHEN cw.nextecoacode <> ISNULL(cmw.ecoacode, '') THEN GETDATE()
								   WHEN cw.nextinformationindicator <> ISNULL(cmw.informationindicator,  '') THEN GETDATE() 
								   WHEN (cw.NextTransactionType <> ISNULL(cmw.CurrentTransactionType,'')) AND cw.NextTransactionType <> '' THEN GETDATE()
								   WHEN ISNULL(cd.dob,'19000101') <> ISNULL(d.dob,'19000101') THEN GETDATE()
								   WHEN ISNULL(AuthorizedUserSegment,'') <> ISNULL(cmw.AuthorizedUserAddress,'') THEN GETDATE()
							  ELSE lastupdated END,
				AuthorizedUserSegment = cmw.AuthorizedUserAddress
		OUTPUT INSERTED.accountID INTO @OutParms4
        FROM        #PendingNonEvaluated pne
						INNER JOIN #cbrwork cw on cw.number = pne.AccountID
                        INNER JOIN dbo.cbr_debtors cd ON cd.accountid =  cw.number AND cd.debtorid = cw.debtorid
                        LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number AND cmw.debtorid = cw.debtorid
                        INNER JOIN debtors d on cd.debtorid = d.debtorid
        WHERE			cw.StatusCbrReport = 1 
				;
			
END -- Procedure


GO
