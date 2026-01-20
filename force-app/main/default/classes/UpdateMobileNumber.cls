global class UpdateMobileNumber implements Database.Batchable<sObject> {
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id, MobilePhone,DupMobileNumber__c ,Phone FROM Lead where DupMobileNumber__c = null ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> leadList) {
       
        // process each batch of records

        List<Lead> tobeupdate=new List<Lead>();
        for(Lead l : leadList)
        {        
            if(l.MobilePhone!=null && !string.isBlank(l.MobilePhone)){
                l.DupMobileNumber__c=l.MobilePhone.right(10);
                
            }
            if(string.isBlank(l.MobilePhone))
            {
                if(!string.isBlank(l.Phone))
                {
                    l.DupMobileNumber__c=l.Phone.right(10);
                }
            }
            tobeupdate.add(l);
        }
        try {
            // Update the Account Record
            if(tobeupdate!=null && tobeupdate.size()>0){
            database.update(tobeupdate,false) ;
            }
        
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
  }
}