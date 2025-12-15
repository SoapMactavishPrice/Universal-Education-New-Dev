trigger CountAdmissionGrantedOnAccount on Admission_Granted__c (after INSERT, after UPDATE, after DELETE) {
    
    Set <Id> accountIds = new Set <Id>();
    List <Account> lstAccountsToUpdate = new List <Account>();
    if(Trigger.isInsert){
        for(Admission_Granted__c ag:trigger.new){
            accountIds.add(ag.School_Institution__c);
        }
    }
    if(Trigger.isUpdate|| Trigger.isDelete){
        for(Admission_Granted__c ag:trigger.old){
            accountIds.add(ag.School_Institution__c);
        }
    }
    
    for(Account acc:[SELECT Id,Name,Total_No_of_Admission_Granted__c,(Select Id from Admissions_Granted__r) from Account where Id IN: accountIds]){
        Account accObj = new Account ();
        accObj.Id = acc.Id;
        accObj.Total_No_of_Admission_Granted__c = acc.Admissions_Granted__r.size();
        lstAccountsToUpdate.add(accObj);
    }
    
    UPDATE lstAccountsToUpdate;
    
    
    
}