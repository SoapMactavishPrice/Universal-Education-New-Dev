trigger CountAddmissionFormOnAccount on Admission_Form__c (after INSERT, after UPDATE, after DELETE) {
    
    
    Set <Id> accountIds = new Set <Id>();
    List <Account> lstAccountsToUpdate = new List <Account>();
    if(Trigger.isInsert){
        for(Admission_Form__c adf:trigger.new){
            accountIds.add(adf.School_Institution__c);
        }
    }
    if(Trigger.isUpdate|| Trigger.isDelete){
        for(Admission_Form__c adf:trigger.old){
            accountIds.add(adf.School_Institution__c);
        }
    }
    
    for(Account acc:[SELECT Id,Name,Total_No_of_Admission_Form_Filled__c,(Select Id from Admission_Forms__r) from Account where Id IN: accountIds]){
        Account accObj = new Account ();
        accObj.Id = acc.Id;
        accObj.Total_No_of_Admission_Form_Filled__c = acc.Admission_Forms__r.size();
        lstAccountsToUpdate.add(accObj);
    }
    
    UPDATE lstAccountsToUpdate;

}