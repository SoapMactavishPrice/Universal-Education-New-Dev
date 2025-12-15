public class LeadHandler {
    public static void LeadTaskCount(List<Lead> ldLst,map<Id,Lead>newMap){
        for(Lead ld: ldLst){
            if(newMap.containskey(ld.Id)){
                if(string.isNotblank(ld.WA_Response_1__c) || string.isNotblank(ld.WA_Response_2__c) || string.isNotblank(ld.WA_Star_Response__c)){
                    if(newMap.get(ld.Id).WA_Response_1__c != ld.WA_Response_1__c || 
                       newMap.get(ld.Id).WA_Response_2__c != ld.WA_Response_2__c || newMap.get(ld.Id).WA_Star_Response__c != ld.WA_Star_Response__c){
                           
                           //ld.Task_Count__c = 0;
                           ld.Dormant_Count__c = 0;
                           ld.Dormant__c = false ; 
                       }
                }
            }
        }
    }
}