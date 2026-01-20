public class EnquiryHandler {
  // Method to update the Enquiry_Submitted__c field on the Contact when Log_Status__c is 'New Enquiry'
    public static void updateContactEnquiryStatus(List<Enquiry__c> enquiryList) {
        Set<Id> contactIdsToUpdate = new Set<Id>();
        Set<String> orgCodesToMatch = new Set<String>();
        Map<String, Id> schoolCodeToAccountIdMap = new Map<String, Id>();

        try {
            // Collect contact IDs and OrgCode__c values
            for (Enquiry__c enquiry : enquiryList) {
                if (enquiry.Log_Status__c == 'New Enquiry' && enquiry.Contact__c != null) {
                    contactIdsToUpdate.add(enquiry.Contact__c);
                    System.debug('Enquiry with ID ' + enquiry.Id + ' has Log_Status__c as "New Enquiry". Adding Contact ID ' + enquiry.Contact__c + ' to update list.');
                }
                if (enquiry.OrgCode__c != null) {
                    orgCodesToMatch.add(enquiry.OrgCode__c);
                    System.debug('Enquiry with ID ' + enquiry.Id + ' has OrgCode__c: ' + enquiry.OrgCode__c);
                }
            }

            // Update Enquiry_Submitted__c on Contact records
            if (!contactIdsToUpdate.isEmpty()) {
                List<Contact> contactsToUpdate = [SELECT Id, Enquiry_Submitted__c FROM Contact WHERE Id IN :contactIdsToUpdate];
                for (Contact contact : contactsToUpdate) {
                    // If Enquiry_Submitted__c is false, update it to true
                    if (!contact.Enquiry_Submitted__c) {
                        contact.Enquiry_Submitted__c = true;
                        System.debug('Updating Enquiry_Submitted__c to true for Contact ID ' + contact.Id);
                    } else {
                        System.debug('Contact ID ' + contact.Id + ' already has Enquiry_Submitted__c as true. No update required.');
                    }
                }
                if (!contactsToUpdate.isEmpty()) update contactsToUpdate;
            }

            // Query Accounts with matching School_Short_Code__c for orgCodes
            if (!orgCodesToMatch.isEmpty()) {
                List<Account> accountsToMatch = [SELECT Id, School_Short_Code__c FROM Account WHERE School_Short_Code__c IN :orgCodesToMatch];
                for (Account acc : accountsToMatch) {
                    schoolCodeToAccountIdMap.put(acc.School_Short_Code__c, acc.Id);
                    System.debug('Found Account with School_Short_Code__c: ' + acc.School_Short_Code__c + ' and Account ID: ' + acc.Id);
                }
            }

            // Update School_Institution__c in Enquiry__c records, but only if it's not already correct
            List<Enquiry__c> enquiriesToUpdate = new List<Enquiry__c>();
            for (Enquiry__c enquiry : enquiryList) {
                if (enquiry.OrgCode__c != null && schoolCodeToAccountIdMap.containsKey(enquiry.OrgCode__c)) {
                    Id newSchoolInstitutionId = schoolCodeToAccountIdMap.get(enquiry.OrgCode__c);
                    if (enquiry.School_Institution__c != newSchoolInstitutionId) {
                        System.debug('Updating School_Institution__c for Enquiry ID ' + enquiry.Id + '. Old value: ' + enquiry.School_Institution__c + ', New value: ' + newSchoolInstitutionId);
                        enquiry.School_Institution__c = newSchoolInstitutionId;
                        enquiriesToUpdate.add(enquiry);
                    } else {
                        System.debug('Enquiry ID ' + enquiry.Id + ' already has the correct School_Institution__c. No update needed.');
                    }
                } else {
                    System.debug('No matching School_Short_Code__c for Enquiry ID ' + enquiry.Id + '. Skipping School_Institution__c update.');
                }
            }

            // Update the Enquiry__c records if necessary
            if (!enquiriesToUpdate.isEmpty()) {
                update enquiriesToUpdate;
                System.debug('Updated ' + enquiriesToUpdate.size() + ' Enquiry__c records with School_Institution__c.');
            } else {
                System.debug('No Enquiry__c records needed updates.');
            }

        } catch (DmlException dmlEx) {
            System.debug('DML Exception: ' + dmlEx.getMessage());
            throw new AuraHandledException('Error updating records: ' + dmlEx.getMessage());
        } catch (Exception ex) {
            System.debug('Unexpected Exception: ' + ex.getMessage());
            throw new AuraHandledException('Unexpected error occurred: ' + ex.getMessage());
        }
    }
    

  public static void updateRecordType(List<Enquiry__c> enquiries, Map<Id, String> contactToSchoolShortCodeMap) {
    try {
        // Fetch RecordTypeId for 'EISB' and 'PRIMUS' dynamically using Schema
        Id eisbRecordTypeId = Schema.SObjectType.Enquiry__c.getRecordTypeInfosByName().get('EISB').getRecordTypeId();
        Id primusRecordTypeId = Schema.SObjectType.Enquiry__c.getRecordTypeInfosByName().get('PRIMUS').getRecordTypeId();
        
        System.debug('EISB RecordTypeId: ' + eisbRecordTypeId);
        System.debug('PRIMUS RecordTypeId: ' + primusRecordTypeId);
        
        // Loop through the Enquiry__c records and update RecordTypeId based on School_Short_Code
        for (Enquiry__c enquiry : enquiries) {
            // Get the School_Short_Code__c from the map
            String schoolCode = contactToSchoolShortCodeMap.get(enquiry.Contact__c);

            // Log the School_Short_Code value
            System.debug('School_Short_Code__c: ' + schoolCode);

            if (schoolCode == 'EISB') {
                enquiry.RecordTypeId = eisbRecordTypeId;
                System.debug('Setting RecordTypeId to EISB');
            } else if (schoolCode == 'PRIMUS') {
                enquiry.RecordTypeId = primusRecordTypeId;
                System.debug('Setting RecordTypeId to PRIMUS');
            } else {
                System.debug('No matching RecordTypeId found for School_Short_Code: ' + schoolCode);
            }
        }
    } catch (Exception e) {
        // Catch any exceptions and log them
        System.debug('Error in updateRecordType method: ' + e.getMessage());
        throw new AuraHandledException('Error in EnquiryHandler.updateRecordType: ' + e.getMessage());
    }
}


    
 // Method to create a Task when Stages__c = 'Observation Scheduled'
    public static void createTaskForObservationScheduled(List<Enquiry__c> enquiries) {
        List<Task> tasksToInsert = new List<Task>();
        
        // Log the number of enquiries being processed
        System.debug('Start processing ' + enquiries.size() + ' Enquiry records.');
        
        // Ensure there are records in the list
        if (enquiries.isEmpty()) {
            System.debug('No Enquiry records found in the list.');
        }

        // Loop through the Enquiry__c records
        for (Enquiry__c enquiry : enquiries) {
            try {
                // Log Enquiry details
                System.debug('Processing Enquiry Id: ' + enquiry.Id + ', Stages__c: ' + enquiry.Stages__c);

                // Only create task if Stages__c is 'Observation Scheduled'
                if (enquiry.Stages__c == 'Observation Scheduled') {
                    // Log the details for task creation
                    System.debug('Creating task for Enquiry: ' + enquiry.Id);
                    
                    // Check if Contact__c and its OwnerId is not null
                    if (enquiry.Contact__c != null) {
                        // Log contact details directly from Contact__c
                        System.debug('Enquiry Contact Id: ' + enquiry.Contact__c);
                        Contact contact = [SELECT Id, OwnerId, Name FROM Contact WHERE Id = :enquiry.Contact__c LIMIT 1];
                        System.debug('Contact Name: ' + contact.Name + ', OwnerId: ' + contact.OwnerId);

                        // Create the Task record if OwnerId exists
                        if (contact.OwnerId != null) {
                            Task newTask = new Task(
                                Description = 'Observation is Scheduled. Please send Application Form',
                                OwnerId = contact.OwnerId,  // Owner of the contact
                                Priority = 'High',
                                Status = 'Open',
                                Subject = 'Send Application Form',
                                WhatId = enquiry.Id,  // Related to Enquiry__c
                                WhoId = enquiry.Contact__c  // Related to the Contact__c record
                            );
                            
                            // Add the task to the list for insertion
                            tasksToInsert.add(newTask);
                            
                            // Log the task details
                            System.debug('Task created for Enquiry Id: ' + enquiry.Id + ', Task Subject: ' + newTask.Subject);
                        } else {
                            System.debug('Skipping task creation for Enquiry Id: ' + enquiry.Id + ' as Contact has no OwnerId.');
                        }
                    } else {
                        System.debug('Skipping task creation for Enquiry Id: ' + enquiry.Id + ' as Contact__c is null.');
                    }
                } else {
                    // Log if Stages__c is not 'Observation Scheduled'
                    System.debug('Skipping Enquiry Id: ' + enquiry.Id + ' as Stages__c is not "Observation Scheduled".');
                }
            } catch (Exception e) {
                // Log the error if something goes wrong in processing the Enquiry
                System.debug('Error processing Enquiry Id: ' + enquiry.Id + '. Error: ' + e.getMessage());
            }
        }
        
        // Insert tasks in bulk if any tasks are created
        if (!tasksToInsert.isEmpty()) {
            try {
                // Inserting tasks in bulk
                insert tasksToInsert;
                System.debug('Successfully created ' + tasksToInsert.size() + ' Task(s).');
            } catch (DmlException e) {
                // Catch any DML exceptions (e.g., permission issues, validation rule failures)
                System.debug('DML Error while inserting tasks: ' + e.getMessage());
            }
        } else {
            // Log when no tasks are created
            System.debug('No tasks were created as no Enquiries met the condition "Observation Scheduled".');
        }
    }
    
     // Separate Method to Update Curiosity_Submitted__c Checkbox on Contact
    public static void updateCuriositySubmitted(List<Enquiry__c> enquiries) {
        Set<Id> contactIdsToUpdate = new Set<Id>();

        // Loop through the Enquiry records and collect Contact Ids
        for (Enquiry__c enquiry : enquiries) {
            if (enquiry.Contact__c != null) {
                contactIdsToUpdate.add(enquiry.Contact__c);
            }
        }

        // If there are Contact IDs to update, query and update them
        if (!contactIdsToUpdate.isEmpty()) {
            List<Contact> contactsToUpdate = [SELECT Id, Curiosity_Submitted__c FROM Contact WHERE Id IN :contactIdsToUpdate];

            // Log the number of contacts to update
            System.debug('Found ' + contactsToUpdate.size() + ' Contact records to update.');

            for (Contact con : contactsToUpdate) {
                con.Curiosity_Submitted__c = true;  // Set Curiosity_Submitted__c to true
            }

            // Update the Contact records
            try {
                update contactsToUpdate;
                System.debug('Successfully updated Curiosity_Submitted__c for ' + contactsToUpdate.size() + ' Contact(s).');
            } catch (DmlException e) {
                System.debug('Error updating Curiosity_Submitted__c for Contacts: ' + e.getMessage());
            }
        } else {
            System.debug('No Contacts found to update.');
        }
    }
    
    // Method to update Address__c field on insert if Full_Address__c is not null
    public static void updateAddress(List<Enquiry__c> enquiryList) {
        List<Enquiry__c> enquiriesToUpdate = new List<Enquiry__c>();
        
        try {
            for (Enquiry__c enquiry : enquiryList) {
                // Check if Full_Address__c is not null
                if (enquiry.Full_Address__c != null) {
                    // Update Address__c with Full_Address__c
                    enquiry.Address__c = enquiry.Full_Address__c;
                    enquiriesToUpdate.add(enquiry);
                }
            }
            
            // Only perform update if there are records to update
            if (!enquiriesToUpdate.isEmpty()) {
                update enquiriesToUpdate;
                System.debug('--- Address__c updated for ' + enquiriesToUpdate.size() + ' Enquiry records ---');
            } else {
                System.debug('--- No Enquiries required Address__c update ---');
            }
        } catch (DmlException e) {
            // Catch any DML exceptions and log them
            System.debug('DML Exception occurred while updating Address__c: ' + e.getMessage());
        } catch (Exception e) {
            // Catch any general exceptions
            System.debug('Unexpected exception occurred while updating Address__c: ' + e.getMessage());
        }
    }
    
    
    
}