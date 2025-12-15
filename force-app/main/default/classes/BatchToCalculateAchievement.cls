public class BatchToCalculateAchievement implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext bc) {
        
             
        String queryStr = [Select Query__c from Dashboard_Query__mdt where DeveloperName = 'Target_Batch'].Query__c;
        return Database.getQueryLocator(queryStr);
       // return Database.getQueryLocator([]);
    }
    public void execute(Database.BatchableContext bc, List<Admission_Granted__c> listOfAdmissionGranted){
        Map<Id,Decimal> mapOfSchoolNNoOfStudent = new Map<Id,Decimal>();
        Map<String,Decimal> mapOfUniqueKeyNAchievement = new Map<String,Decimal>();
        List<Targets__c> listToUpsertTarget = new List<Targets__c>();
        
        Integer currentMonth = System.now().month();
        Integer currentYear = System.now().year();
        
        List<Targets__c> listOfTarget = new List<Targets__c>();
        
        listOfTarget = [Select Id, Achievement__c, Unique_Key__c from Targets__c where CALENDAR_MONTH(CreatedDate) =:currentMonth AND CALENDAR_YEAR(CreatedDate) =:currentYear];
        
        for(Targets__c temp : listOfTarget)
        {
            mapOfUniqueKeyNAchievement.put(temp.Unique_Key__c,temp.Achievement__c);
        }
        
        for(Admission_Granted__c  temp : listOfAdmissionGranted)
        {
            if(mapOfSchoolNNoOfStudent.containsKey(temp.School_Institution__c)){
                Decimal noOfStudent = mapOfSchoolNNoOfStudent.get(temp.School_Institution__c);
                noOfStudent+= 1;
                mapOfSchoolNNoOfStudent.put(temp.School_Institution__c,noOfStudent);
            }else{
                mapOfSchoolNNoOfStudent.put(temp.School_Institution__c,1);
            }
        }
        
        for(Id temp : mapOfSchoolNNoOfStudent.keySet())
        {
            Targets__c newTarget = new Targets__c();
            String key = temp+'-'+System.now().format('MMMMM')+'-'+System.now().format('YYYY');
            newTarget.Schools__c = temp;
            if(mapOfUniqueKeyNAchievement.containsKey(key))
               newTarget.Achievement__c = mapOfSchoolNNoOfStudent.get(temp) + mapOfUniqueKeyNAchievement.get(key);
            else{
                newTarget.Achievement__c = mapOfSchoolNNoOfStudent.get(temp);
                newTarget.Unique_Key__c = key;
                newTarget.Month__c = System.now().format('MMMMM');
                newTarget.Year__c = System.now().format('YYYY');
            }
                
            listToUpsertTarget.add(newTarget);
        }
        
        if(listToUpsertTarget.size() > 0){
            Schema.SObjectField uniqueKey = Targets__c.Fields.Unique_Key__c;
            Database.UpsertResult [] targetVsAchievement = Database.upsert(listToUpsertTarget,uniqueKey,false);
        }
    }   
    public void finish(Database.BatchableContext bc){ 
    }   
}