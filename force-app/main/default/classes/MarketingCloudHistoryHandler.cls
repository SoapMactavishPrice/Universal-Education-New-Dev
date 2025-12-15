public class MarketingCloudHistoryHandler {
    public static void insertMarketingCloudHistory(List<Marketing_Cloud_History__c> newmclist){
        List<Task> taskList = new List<Task>();
        Set<Id> leadIds = new Set<Id>();

        // Extract Lead IDs from newmclist
        for(Marketing_Cloud_History__c mch : newmclist){
            leadIds.add(mch.Lead__c);
        }

        // Query Marketing_Cloud_History__c records related to the Lead IDs
        List<Marketing_Cloud_History__c> MCHList = [SELECT Id, Name, Lead__c, Lead__r.OwnerId, Customer_Message__c 
                                                    FROM Marketing_Cloud_History__c 
                                                    WHERE Lead__c IN :leadIds];

        for(Marketing_Cloud_History__c mch : MCHList){
            // Add your condition here to determine when to create a Task
            if(mch.Customer_Message__c != null && mch.Customer_Message__c.contains('Body')){
                Task tsk = new Task();
                tsk.WhoId = mch.Lead__c;
                system.debug('Lead Id: ' + tsk.WhoId);
                system.debug('Lead Owner Id: ' + mch.Lead__r.OwnerId);
                tsk.Subject = 'A New Inbound WhatsApp message has been received, Please check.';
                tsk.Status = 'Open';
                tsk.Priority = 'High';
                tsk.OwnerId = mch.Lead__r.OwnerId;
                tsk.ActivityDate = Date.today();
                taskList.add(tsk);
                system.debug('Task List: ' + taskList);
            }
        }

        // Insert the list of tasks
        if(!taskList.isEmpty()){
            insert taskList;
        }
    }
}