trigger EnquiryTrigger on Enquiry__c (before insert, after insert, after update) {
    try {
        System.debug('--- EnquiryTrigger started ---');

        if (Trigger.isAfter) {
            List<Id> leadIds = new List<Id>();
            for (Enquiry__c e : Trigger.new) {
                leadIds.add(e.Lead__c);
            }
 
            List<Lead> leads = new List<Lead>();
 
            for (Id leadId : leadIds) {
                leads.add(new Lead(Id = leadId));
            }
 
            UPDATE leads;
        }

        // Collect Contact Ids for the records being processed
        Set<Id> contactIds = new Set<Id>();
        Set<String> orgCodesToMatch = new Set<String>(); // Collect OrgCodes for matching
        Map<Id, String> contactToSchoolShortCodeMap = new Map<Id, String>(); // Map for School Short Code

        for (Enquiry__c enquiry : Trigger.new) {
            if (enquiry.Contact__c != null) {
                contactIds.add(enquiry.Contact__c);
            }
            if (enquiry.OrgCode__c != null) {
                orgCodesToMatch.add(enquiry.OrgCode__c); // Collect OrgCode values
            }
        }

        // Query to load the Contact's related Account and School_Short_Code__c
        List<Contact> contacts = [SELECT Id, Account.School_Short_Code__c FROM Contact WHERE Id IN :contactIds];

        // Build map of Contact to School Short Code
        for (Contact con : contacts) {
            contactToSchoolShortCodeMap.put(con.Id, con.Account.School_Short_Code__c);
        }

        // **Before Insert**: Update RecordType, Curiosity_Submitted__c, and Contact Enquiry Status
        if (Trigger.isBefore && Trigger.isInsert) {
            // Update the Record Type for the Enquiry__c records
            System.debug('--- Trigger is Before Insert, updating record type ---');
            EnquiryHandler.updateRecordType(Trigger.new, contactToSchoolShortCodeMap);
            
            // Update Curiosity_Submitted__c to 'true' for related Contacts
            System.debug('--- Trigger is Before Insert, updating Curiosity_Submitted__c to True ---');
            EnquiryHandler.updateCuriositySubmitted(Trigger.new);

            // Update Contact Enquiry Status if Log_Status__c is 'New Enquiry'
            System.debug('--- Trigger is Before Insert, updating Contact Enquiry Status ---');
            EnquiryHandler.updateContactEnquiryStatus(Trigger.new);
            
            // Update Address__c with Full_Address__c if Full_Address__c is not null
            System.debug('--- Trigger is Before Insert, updating Address__c from Full_Address__c ---');
            EnquiryHandler.updateAddress(Trigger.new);
        }

        // **After Insert/Update**: Update School_Institution__c and handle Task creation
        if (Trigger.isAfter) {
            // Update School_Institution__c if OrgCode matches School_Short_Code
            if (!orgCodesToMatch.isEmpty()) {
                EnquiryHandler.updateContactEnquiryStatus(Trigger.new); // Ensure status is updated after insert
            }

            // Create Tasks if Stages__c = 'Observation Scheduled'
            System.debug('--- Trigger is After Insert/Update, checking Stages__c for Task creation ---');
            EnquiryHandler.createTaskForObservationScheduled(Trigger.new);
        }
        
    } catch (Exception e) {
        // Log exception if any
        System.debug('Error in EnquiryTrigger: ' + e.getMessage());
    }
}




 


/*
trigger EnquiryTrigger on Enquiry__c (before insert) {
    try {
        // Fetch Contact and its related Account's School_Short_Code__c before processing
        Set<Id> contactIds = new Set<Id>();
        for (Enquiry__c enquiry : Trigger.new) {
            if (enquiry.Contact__c != null) {
                contactIds.add(enquiry.Contact__c);
            }
        }

        // Query to load the Contact's related Account and School_Short_Code__c
        Map<Id, String> contactToSchoolShortCodeMap = new Map<Id, String>();
        for (Contact con : [SELECT Id, Account.School_Short_Code__c FROM Contact WHERE Id IN :contactIds]) {
            contactToSchoolShortCodeMap.put(con.Id, con.Account.School_Short_Code__c);
        }

        // Pass to the handler to update record type
        EnquiryHandler.updateRecordType(Trigger.new, contactToSchoolShortCodeMap);
        
    } catch (Exception e) {
        // Log exception if any
        System.debug('Error in EnquiryTrigger: ' + e.getMessage());
    }
}
*/