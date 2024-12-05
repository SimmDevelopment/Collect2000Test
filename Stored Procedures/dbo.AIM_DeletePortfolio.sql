SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE     procedure [dbo].[AIM_DeletePortfolio]
      @portfolioId int
AS

begin 
      declare @portfolioTypeId int
      select
            @portfolioTypeId = portfoliotypeid
      from
            aim_portfolio
      where
            portfolioid = @portfolioid

      if(@portfolioTypeId = 0)
      begin
			insert into notes(number, created, user0, action, result, comment)      
			select m.number, GETDATE(), 'PM', '+++++', '+++++', 'Account removed from Purchased Portfolio as it was removed.'
			from master m
			where m.PurchasedPortfolio = @portfolioId
           
            update 
                  master
            set 
                  purchasedportfolio = null                 
            where
                  purchasedportfolio = @portfolioid
      end
      else if(@portfolioTypeId = 1)
      begin
          
            delete AIM_PortfolioSoldAccounts
            from AIM_PortfolioSoldAccounts psa with (nolock) join 
            master m with (nolock) on psa.number = m.number
            where m.soldportfolio = @portfolioid

            --delete ledger entries
            delete AIM_Ledger
            where soldportfolioid = @portfolioId;
            
          --Annotate the accounts
          insert into notes(number, created, user0, action, result, comment)      
          select m.number, GETDATE(), 'PM', '+++++', '+++++', 'Account removed from Sold Portfolio as it was removed.'
          from master m
          where m.SoldPortfolio = @portfolioId
                        
            update master
            set soldportfolio = null
                  ,status = 'ACT'
                  ,qlevel = '015'
                  ,restrictedaccess = 0
                  ,shouldqueue = 1
            where soldportfolio = @portfolioid
      end
      else 
      begin
			insert into notes(number, created, user0, action, result, comment)      
			select m.number, GETDATE(), 'PM', '+++++', '+++++', 'Account removed from Sample Portfolio as it was removed.'
			from master m
			where m.SoldPortfolio = @portfolioId
            
            update 
                  master
            set 
                  soldportfolio = null
            where
                  soldportfolio = @portfolioid
      end

      delete
            aim_portfolio
      where
            portfolioid = @portfolioId
end



GO
