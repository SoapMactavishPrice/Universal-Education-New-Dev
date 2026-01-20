trigger EnquiryTrigger1 on Enquiry__c (before insert, after insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        EnquiryTriggerHandler.populateEnquiryFromWalkinLead(Trigger.new);
    }
    
    if (Trigger.isAfter) {
        EnquiryTriggerHandler.updateLeadsFromNonWalkinEnquiry(Trigger.new);
    }
}