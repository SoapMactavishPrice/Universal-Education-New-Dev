trigger AssignLeadOwner on Lead (after insert) {
    try {
        // List to store leads for update
        List<Lead> leadsToUpdate = new List<Lead>();

        // Collect School Short Codes from newly inserted leads
        Set<String> schoolCodes = new Set<String>();

        for (Lead lead : Trigger.new) {
            if (lead.School_Short_Code__c == 'PRIMUS' && lead.School_Short_Code__c != null) {
                schoolCodes.add(lead.School_Short_Code__c);
                System.debug('Lead considered for ownership change: ' + lead.Id);
            }
        }

        // Exit if no relevant leads exist
        if (schoolCodes.isEmpty()) {
            System.debug('No leads found with School_Short_Code__c = PRIMUS');
            return;
        }

        // Query LeadUser__c records where SchoolCode__c matches
        Map<String, String> schoolCodeToLeadUserMap = new Map<String, String>();
        for (LeadUser__c leadUser : [
            SELECT Name, SchoolCode__c 
            FROM LeadUser__c 
            WHERE SchoolCode__c IN :schoolCodes
        ]) {
            schoolCodeToLeadUserMap.put(leadUser.SchoolCode__c, leadUser.Name);
            System.debug('Matching LeadUser__c found: ' + leadUser.Name + ' for SchoolCode__c: ' + leadUser.SchoolCode__c);
        }

        // Map to store User Ids based on Name
        Map<String, Id> userNameToUserIdMap = new Map<String, Id>();
        for (User u : [
            SELECT Id, Name 
            FROM User 
            WHERE Name IN :schoolCodeToLeadUserMap.values()
        ]) {
            userNameToUserIdMap.put(u.Name, u.Id);
            System.debug('User found: ' + u.Name + ' with Id: ' + u.Id);
        }

        // Assign OwnerId based on mapped SchoolCode and User Name
        for (Lead lead : Trigger.new) {
            if (lead.School_Short_Code__c == 'PRIMUS' && lead.School_Short_Code__c != null) {
                String leadUserName = schoolCodeToLeadUserMap.get(lead.School_Short_Code__c);
                if (leadUserName != null) {
                    Id newOwnerId = userNameToUserIdMap.get(leadUserName);
                    if (newOwnerId != null) {
                        //  Cannot modify lead directly, so add to update list
                        leadsToUpdate.add(new Lead(
                            Id = lead.Id,
                            OwnerId = newOwnerId
                        ));
                        System.debug('Lead ' + lead.Id + ' assigned to user: ' + leadUserName);
                    } else {
                        System.debug('No matching User found for LeadUser__c.Name: ' + leadUserName);
                    }
                }
            }
        }

        //  Update the leads in bulk
        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
                System.debug('Successfully updated ' + leadsToUpdate.size() + ' leads with new OwnerId.');
            } catch (DmlException e) {
                System.debug('Error updating Lead records: ' + e.getMessage());
            }
        } else {
            System.debug('No leads to update with new OwnerId.');
        }
    } catch (Exception ex) {
        System.debug('Unexpected error in AssignLeadOwner trigger: ' + ex.getMessage());
    }
}

/*trigger AssignLeadOwner on Lead (after insert) {
    try {
        // List to store leads for update
        List<Lead> leadsToUpdate = new List<Lead>();

        // Collect School Short Codes from newly inserted leads
        Set<String> schoolCodes = new Set<String>();
        
        for (Lead lead : Trigger.new) {
            if (lead.School_Short_Code__c == 'PRIMUS' && lead.School_Short_Code__c != null) {
                schoolCodes.add(lead.School_Short_Code__c);
                System.debug('Lead considered for ownership change: ' + lead.Id);
            }
        }
        
        // Exit if no relevant leads exist
        if (schoolCodes.isEmpty()) {
            System.debug('No leads found with School_Short_Code__c = PRIMUS');
            return;
        }

        // Query LeadUser__c records where SchoolCode__c matches
        Map<String, String> schoolCodeToLeadUserMap = new Map<String, String>();
        try {
            for (LeadUser__c leadUser : [
                SELECT Name, SchoolCode__c 
                FROM LeadUser__c 
                WHERE SchoolCode__c IN :schoolCodes
            ]) {
                schoolCodeToLeadUserMap.put(leadUser.SchoolCode__c, leadUser.Name);
                System.debug('Matching LeadUser__c found: ' + leadUser.Name + ' for SchoolCode__c: ' + leadUser.SchoolCode__c);
            }
        } catch (Exception e) {
            System.debug('Error querying LeadUser__c records: ' + e.getMessage());
            return;
        }

        // Map to store User Ids based on Name
        Map<String, Id> userNameToUserIdMap = new Map<String, Id>();
        try {
            List<User> users = [
                SELECT Id, Name 
                FROM User 
                WHERE Name IN :schoolCodeToLeadUserMap.values()
            ];
            for (User u : users) {
                userNameToUserIdMap.put(u.Name, u.Id);
                System.debug('User found: ' + u.Name + ' with Id: ' + u.Id);
            }
        } catch (Exception e) {
            System.debug('Error querying User records: ' + e.getMessage());
            return;
        }

        // Assign OwnerId based on mapped SchoolCode and User Name
        for (Lead lead : Trigger.new) {
            if (lead.School_Short_Code__c == 'PRIMUS' && lead.School_Short_Code__c != null) {
                String leadUserName = schoolCodeToLeadUserMap.get(lead.School_Short_Code__c);
                if (leadUserName != null) {
                    Id newOwnerId = userNameToUserIdMap.get(leadUserName);
                    if (newOwnerId != null) {
                        lead.OwnerId = newOwnerId;
                        leadsToUpdate.add(lead);
                        System.debug('Lead ' + lead.Id + ' assigned to user: ' + leadUserName);
                    } else {
                        System.debug('No matching User found for LeadUser__c.Name: ' + leadUserName);
                    }
                }
            }
        }

        // Update the leads in bulk
        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
                System.debug('Successfully updated ' + leadsToUpdate.size() + ' leads with new OwnerId.');
            } catch (DmlException e) {
                System.debug('Error updating Lead records: ' + e.getMessage());
            }
        } else {
            System.debug('No leads to update with new OwnerId.');
        }
    } catch (Exception ex) {
        System.debug('Unexpected error in AssignLeadOwner trigger: ' + ex.getMessage());
    }
}*/