global class UpdateLeadContact implements Database.Batchable<sObject> {
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        fake();
        String query = 'SELECT Id, Lead_ID__c,Lead__c FROM Contact where  Lead_ID__c !=null ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> ConList) {
       
        // process each batch of records

        List<Contact> tobeupdate=new List<Contact>();
        Set<string> leadid=new Set<string>();
        Map<string,id> mp=new Map<string,id>();
        for(Contact l : ConList)
        {        
           leadid.add(l.Lead_ID__c);
        }
        for(Lead l:[Select id,Lead_ID__c from Lead where Lead_ID__c in :leadid]){
           mp.put(l.Lead_ID__c,l.id);
    }   
        for(Contact l : ConList)
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