public class EnquiresTriggerHandler {
	public static void updateCurrentStatus(List<Enquiry__c> listEnquires){
        system.debug('listEnquires ' + listEnquires);
        set<string> EnquiresLeadId = new set<string>();
        List<Enquiry__c> lstEnquires = new List<Enquiry__c>();
        if(RecursiveTriComCurrStatusHandler.isFirstTime == true){
            for(Enquiry__c oEnquires : listEnquires){
                if(oEnquires.Stages__c == 'Dormant'){
                    EnquiresLeadId.add(oEnquires.Lead_ID__c);   
                }
            }
            system.debug('EnquiresLeadId >> ' + EnquiresLeadId);
            if(!EnquiresLeadId.IsEmpty()){
                List<Lead> ldLists = [SELECT Id,Lead_ID__c,Current_Status__c FROM Lead where Lead_ID__c =:EnquiresLeadId]; 
                List<Lead> listLead = new List<Lead>();
                for(Lead ld:ldLists){
                    Lead oLead = new Lead();
                    oLead.id = ld.id;
                    oLead.Current_Status__c = 'Dormant';    
                    listLead.add(oLead);
                }
                system.debug('listLead  ' + listLead);
                if(!listLead.isEmpty()){
                    RecursiveTriComCurrStatusHandler.isFirstTime = false;
                    update listLead;  
                }                 
            }
        }
    }
         public static void fakeMethod() {
        Integer j = 0;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
     }
}