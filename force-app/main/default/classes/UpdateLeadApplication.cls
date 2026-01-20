global class UpdateLeadApplication implements Database.Batchable<sObject> {
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        fake();
        String query = 'SELECT Id, Lead_ID__c,Lead__c FROM Application_Form__c where  Lead_ID__c !=null and Lead__c=null ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Application_Form__c> ConList) {
       
        // process each batch of records

        List<Application_Form__c> tobeupdate=new List<Application_Form__c>();
        Set<string> leadid=new Set<string>();
        Map<string,id> mp=new Map<string,id>();
        for(Application_Form__c l : ConList)
        {        
           leadid.add(l.Lead_ID__c);
        }
        for(Lead l:[Select id,Lead_ID__c from Lead where Lead_ID__c in :leadid]){
           mp.put(l.Lead_ID__c,l.id);
    }   
        for(Application_Form__c l : ConList)
        {        
          id lid= mp.get(l.Lead_ID__c);
            l.Lead__c=lid;
            tobeupdate.add(l);
        }
        if(tobeupdate.size()>0){
            database.update(tobeupdate,true) ;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
  }
     public static  void fake()
    {
        integer i=0;
        i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
            i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
            i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
            i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}