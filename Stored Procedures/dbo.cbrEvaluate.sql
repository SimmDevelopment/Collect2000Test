SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           PROCEDURE [dbo].[cbrEvaluate] @AccountID INTEGER = NULL
-- Name:		cbrEvaluate
-- Function:    This procedure will evaluate accounts to report to credit bureau's
AS
	SET NOCOUNT ON
	DECLARE @CbrInitialize BIT;
	Declare @Iparm varchar(1);
	
	SELECT @Iparm = CASE WHEN ISNULL(cbr_config.CbrInitialize,0) = 'T' THEN 'I' ELSE 'N' END  
	FROM  [cbr_config] 
		INNER JOIN [cbr_config_customer] 
		ON cbr_config.id = cbr_config_customer.cbr_config_id 
		WHERE cbr_config_customer.customerid IS NULL;

	IF @AccountID IS NULL
	BEGIN
		
		EXEC [dbo].[cbrEvaluateBulk_nocursor] NULL,@Iparm,'N',0
		END
	ELSE BEGIN
		EXEC [dbo].[cbrEvaluateBulk_nocursor] @AccountID,@Iparm,'N',0 
	END;
	if (@@error != 0) goto ErrHandler

	SET NOCOUNT OFF
	RETURN(0)	
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in cbrEvaluate.')
	Return(1)
SET NOCOUNT OFF
GO
