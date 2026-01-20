public with sharing class EnquiryLostController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getLostReasonPicklistValues() {
        List<Map<String, String>> options = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Lead.Lost_Reasons__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        // Default option
        Map<String, String> defaultOption = new Map<String, String>();
        defaultOption.put('label', 'Reject');
        defaultOption.put('value', 'Reject');
        options.add(defaultOption);

        for (Schema.PicklistEntry entry : ple) {
            Map<String, String> option = new Map<String, String>();
            option.put('label', entry.getLabel());
            option.put('value', entry.getValue());
            options.add(option);
        }
        return options;
    }

    @AuraEnabled
    public static void saveEnquiryLost(Id recordId, String lostReason, String comment) {
        Enquiry__c enquiry = [SELECT Id, Reason_Lost__c, Reason_Losts__c, Lost_Reasons__c, Stages__c FROM Enquiry__c WHERE Id = :recordId LIMIT 1];
        enquiry.Reason_Lost__c = true;
        enquiry.Reason_Losts__c = comment;
        enquiry.Lost_Reasons__c = lostReason;
        enquiry.Stages__c = 'Lost';
        enquiry.Lost_Date_Time__c = System.now();
        update enquiry;
    }
}