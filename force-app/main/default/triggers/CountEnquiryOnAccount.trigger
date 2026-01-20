trigger CountEnquiryOnAccount on Enquiry__c (after INSERT, after UPDATE, after DELETE) {
Set <Id> accountIds = new Set <Id>();
    List <Account> lstAccountsToUpdate = new List <Account>();
    
    Map<id,Account> accMap = new Map<id,Account>();
    if(Trigger.isInsert){
        for(Enquiry__c enq:trigger.new){
            accountIds.add(enq.School_Institution__c);
        }
    }
    if(Trigger.isUpdate || Trigger.isDelete){
        for(Enquiry__c enq:trigger.old){
            accountIds.add(enq.School_Institution__c);
        }
    }
    
    for(Account acc:[SELECT Id,Name,Total_No_of_Enquiry_Form_Recived__c,(Select Id from Enquires__r) from Account where Id IN: accountIds]){
        Account accObj = new Account ();
        accObj.Id = acc.Id;
        accObj.Total_No_of_Enquiry_Form_Recived__c = acc.Enquires__r.size();
        system.debug('SIZE OF ENQUIRY WITHOUT APPLICATION FORM:::'+acc.Enquires__r.size());
        lstAccountsToUpdate.add(accObj);
 
    
    for(Account acc1:[SELECT Id,Name,Number_of_Application_Form_Sent__c,(Select Id,Application_Sent__c from Enquires__r where Application_Sent__c=true) from Account where Id IN: accountIds]){
   
        system.debug('SIZE OF ENQUIRY WITH APPLICATION FORM:::'+acc1.Enquires__r.size());
        accObj.Number_of_Application_Form_Sent__c = acc1.Enquires__r.size();
        lstAccountsToUpdate.add(accObj);
    }
    for(Account acc1:[SELECT Id,Name,Application_form_Received_vs_Sent__c,(Select Id,Application_Sent__c,Application_Received__c from Enquires__r where Application_Sent__c=true and Application_Received__c = true) from Account where Id IN: accountIds]){
   
        system.debug('SIZE OF ENQUIRY WITH APPLICATION FORM:::'+acc1.Enquires__r.size());
        accObj.Application_form_Received_vs_Sent__c = acc1.Enquires__r.size();
        lstAccountsToUpdate.add(accObj);
        system.debug('SIZE Of LIST::'+lstAccountsToUpdate.size());
    }
    }
    accMap.putAll(lstAccountsToUpdate);
    if(accMap.size() > 0){
        update accMap.values();
    }
}