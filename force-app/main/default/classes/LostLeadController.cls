public with sharing class LostLeadController {
    @AuraEnabled
    public static void markLeadAsLost(Id recordId, String lostReason, String lostComment) {
        if (recordId == null) {
            throw new AuraHandledException('Lead Id is required.');
        }

        Lead leadToUpdate = new Lead(
            Id = recordId,
            Lost_Date_Time__c = System.now(),
            Lost_Reasons__c = lostReason,
            Reason_Lost__c = true,
            Reason_Losts__c = lostComment
        );

        update leadToUpdate;
    }
}
