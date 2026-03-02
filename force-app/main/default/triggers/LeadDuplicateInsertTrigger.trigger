trigger LeadDuplicateInsertTrigger on Lead (before insert, after insert, before update, after update) {

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        boolean restrictDuplicates = true;
        String val = System.label.Trigger_Lead_RestrictDuplicate;
        
        if (String.isNotBlank(val)) {
            restrictDuplicates = Boolean.valueOf(val);
        }
        
        if (restrictDuplicates) {
            // LeadDuplicateInsertTriggerHandler.updateLeadStatus(Trigger.new);
        }
        
        List<leadlog__c> lglist = new List<leadlog__c>();
        
        for (Lead l : Trigger.new) {
            leadlog__c lg = new leadlog__c();
            lg.Name = l.Name;
            
            if (l.MobilePhone != null && !String.isBlank(l.MobilePhone)) {

                String phone = l.MobilePhone.replaceAll('\\s','');

                l.DupMobileNumber__c = phone.right(10);

                if (phone.startsWith('91')) {
                    if (phone.length() == 12) {
                        l.MobilePhone = '+' + phone;
                    } else if (phone.length() == 10) {
                        l.MobilePhone = '+91' + phone;
                    }
                } else {
                    if (phone.length() == 10) {
                        l.MobilePhone = '+91' + phone;
                    }
                }
            }

            
            if (String.isBlank(l.MobilePhone)) {
                if (!String.isBlank(l.Phone)) {
                    l.DupMobileNumber__c = l.Phone.right(10);
                }
            }
            
            lg.mobile__c = l.DupMobileNumber__c;
            lg.code__c = l.School_Short_Code__c;
            lg.School_Institution__c = l.School_Institution__c;
            lg.source__c = l.LeadSource;
            lglist.add(lg);
        }
        
        // database.insert(lglist, false);
    }
    
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        //before update
        System.debug('updateCurrentStatusonlead');
        // LeadDuplicateInsertTriggerHandler.updateCurrentStatus(new List<Lead>(Trigger.new));
        
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        System.debug('Test 01');
        // LeadDuplicateInsertTriggerHandler.updateCurrentStatusonlead(new List<Lead>(Trigger.new), Trigger.oldMap);
    }
    
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            LeadHandler.LeadTaskCount(Trigger.new, Trigger.oldMap);
        }
    }
    
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        // LeadDuplicateInsertTriggerHandler.populateMCFields();
    }
}