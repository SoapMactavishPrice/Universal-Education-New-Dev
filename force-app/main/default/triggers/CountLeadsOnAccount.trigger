trigger CountLeadsOnAccount on Lead (after INSERT, after UPDATE, after DELETE){

    
    Set <Id> accountIds = new Set <Id>();
    List <Account> lstAccountsToUpdate = new List <Account>();
    if(Trigger.isInsert){
        for(Lead ld:trigger.new){
            accountIds.add(ld.School_Institution__c);
        }
    }
    if(Trigger.isUpdate|| Trigger.isDelete){
        for(Lead ld:trigger.old){
            accountIds.add(ld.School_Institution__c);
        }
    }
    
    for(Account acc:[SELECT Id,Name,Total_Leads__c,(Select Id from Leads__r) from Account where Id IN: accountIds]){
        Account accObj = new Account ();
        accObj.Id = acc.Id;
        accObj.Total_Leads__c = acc.Leads__r.size();
        lstAccountsToUpdate.add(accObj);
    }
    
    UPDATE lstAccountsToUpdate;
    
}