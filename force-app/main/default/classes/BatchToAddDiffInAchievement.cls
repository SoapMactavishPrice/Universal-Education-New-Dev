public class BatchToAddDiffInAchievement implements Database.Batchable<sObject> {
  
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        Integer d = System.today().toStartOfMonth().addDays(-1).day();
        Integer mo = System.today().toStartOfMonth().addDays(-1).month();
        Integer yr = System.today().toStartOfMonth().addDays(-1).year();
        
        DateTime DT = DateTime.newInstance(yr, mo, d);
        String previousMonth = DT.format('MMMMM');
        String previousYear = DT.format('YYYY');
        
        return Database.getQueryLocator([Select Id, Achievement__c,Difference__c,Schools__c, Unique_Key__c from Targets__c where Month__c =:previousMonth AND Year__c =:previousYear]);
    }
    
    public void execute(Database.BatchableContext bc, List<Targets__c> listOfTargets){
        List<Targets__c> listOfTargetToInsert = new List<Targets__c>();
        
        for(Targets__c temp : listOfTargets){
            
            Targets__c newTarget = new Targets__c();
            
            String key = temp.Schools__c+'-'+System.now().format('MMMMM')+'-'+System.now().format('YYYY');
            newTarget.Schools__c = temp.Schools__c;
            if(temp.Difference__c > 0)
               newTarget.Target__c = temp.Difference__c;
            newTarget.Unique_Key__c = key;
            newTarget.Month__c = System.now().format('MMMMM');
            newTarget.Year__c = System.now().format('YYYY');
            
             
            listOfTargetToInsert.add(newTarget);
        }
        
        if(listOfTargetToInsert.size() > 0){
            Insert listOfTargetToInsert;
        }
    }
    
    public void finish(Database.BatchableContext bc){ 
    }
}