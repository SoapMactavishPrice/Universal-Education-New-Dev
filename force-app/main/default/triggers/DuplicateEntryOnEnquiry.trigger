trigger DuplicateEntryOnEnquiry on Enquiry__c (before insert) {

    List<Enquiry__c> l =[select id,Name,Mobile_No__c,Enquiry__c,FirstName__c,Last_Name__c,Parent_Last_Name__c,Parent_First_Name__c,
                         Email__c from Enquiry__c ORDER BY CreatedDate DESC limit 25000];
    
    for(Enquiry__c ld:Trigger.new){
        
        for(Enquiry__c le:l){
            
            if(le.Mobile_No__c == ld.Mobile_No__c && le.FirstName__c == ld.FirstName__c && le.Last_Name__c == ld.Last_Name__c &&
               le.Parent_Last_Name__c==ld.Parent_Last_Name__c && le.Parent_First_Name__c == ld.Parent_First_Name__c && 
               le.Email__c==ld.Email__c){
                   
                   system.debug('VALUES::::'+le.Mobile_No__c);
                   ld.Enquiry__c=le.id;
                   system.debug('Valuee ::::'+ld.id);
               }
        }
    }
}