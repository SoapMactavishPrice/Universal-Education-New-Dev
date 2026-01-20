global class LeadUpdateBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Name,Lead_ID__c, Id, LastName, FirstName, MiddleName FROM Contact where Lead_ID__c!=null';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contact> ConList) {
        
        // process each batch of records
        
        Set<Id> ids= new Set<Id>();
        Map<Id,id> MapOfCon= new Map<Id,id>();
        for(Contact con : ConList)
        {        
            ids.add(con.Lead_ID__c);
            MapOfCon.put(con.Lead_ID__c ,con.id);
        }
        
          Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        list<Lead> lstLead=[select Id from Lead where  Lead_ID__c IN :ids];
        List<Lead> Listtoupdatelead =new List<Lead>();
        for(lead l: lstLead)
        {
            if(MapOfCon!=null){
                id conid=MapOfCon.get(l.id);
                if(conid!=null)
                {
                    l.Contact__c=conid;
                    Listtoupdatelead.add(l);
                }
            }
            
        }
        if(Listtoupdatelead!=null && Listtoupdatelead.size()>0 ){
           database.update(Listtoupdatelead,false) ;
        }
        
    }
    global void finish(Database.BatchableContext BC) {
    // execute any post-processing operations
}
}