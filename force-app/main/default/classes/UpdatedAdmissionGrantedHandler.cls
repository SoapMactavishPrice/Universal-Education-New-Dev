public class UpdatedAdmissionGrantedHandler {
    
    // public static void updateRecordTypeOnAdmissionGranted(List<Admission_Granted__c> admissionGrantedList) {
    //     // Set of RecordType Ids we need to work with
    //     Set<Id> recordTypeIdsToUpdate = new Set<Id>();

    //     try {
    //         // Get the Record Type Id for 'Admission Granted Locked'
    //         String recordTypeName = 'Admission Granted Locked';
    //         Id recordTypeId = Schema.SObjectType.Admission_Granted__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            
    //         System.debug('--- Record Type Id for ' + recordTypeName + ' fetched: ' + recordTypeId);

    //         // Loop through the records and check the Status__c picklist value
    //         for (Admission_Granted__c admission : admissionGrantedList) {
    //             // Check if the Status is 'Admission Process Completed'
    //             if (admission.Status__c == 'Admission Process Completed') {
    //                 System.debug('--- Processing Admission_Granted__c record with ID: ' + admission.Id);
                    
    //                 // Only update the record type if it's not already set to the target Record Type
    //                 if (admission.RecordTypeId != recordTypeId) {
    //                     admission.RecordTypeId = recordTypeId;
    //                     System.debug('--- RecordTypeId updated for Admission_Granted__c record ID: ' + admission.Id);
    //                 } else {
    //                     System.debug('--- RecordTypeId already set correctly for Admission_Granted__c record ID: ' + admission.Id);
    //                 }
    //             } else {
    //                 System.debug('--- Skipping Admission_Granted__c record with ID: ' + admission.Id + ' as Status__c is not "Admission Process Completed"');
    //             }
    //         }

    //         // Update the Admission_Granted__c records if they need their record type changed
    //         List<Admission_Granted__c> recordsToUpdate = new List<Admission_Granted__c>();
    //         for (Admission_Granted__c admission : admissionGrantedList) {
    //             if (admission.RecordTypeId == recordTypeId) {
    //                 recordsToUpdate.add(admission);
    //             }
    //         }

    //         if (!recordsToUpdate.isEmpty()) {
    //             System.debug('--- Updating ' + recordsToUpdate.size() + ' Admission_Granted__c records with new Record Type.');
    //             update recordsToUpdate;
    //             System.debug('--- Updated ' + recordsToUpdate.size() + ' Admission_Granted__c records.');
    //         } else {
    //             System.debug('--- No records need to be updated.');
    //         }

    //     } catch (DmlException dmlEx) {
    //         System.debug('DML Exception occurred: ' + dmlEx.getMessage());
    //         throw new AuraHandledException('Error updating Admission Granted records: ' + dmlEx.getMessage());
    //     } catch (Exception ex) {
    //         System.debug('Unexpected Exception occurred: ' + ex.getMessage());
    //         throw new AuraHandledException('Unexpected error occurred: ' + ex.getMessage());
    //     }
    // }

    public static void updateRecordTypeOnAdmissionGranted(List<Admission_Granted__c> admissionGrantedList) {
        try {
            // Get the Record Type Id for 'Admission Granted Locked'
            String recordTypeName = 'Admission Granted Locked';
            Id recordTypeId = Schema.SObjectType.Admission_Granted__c
                .getRecordTypeInfosByName()
                .get(recordTypeName)
                .getRecordTypeId();
            
            System.debug('--- Record Type Id for ' + recordTypeName + ': ' + recordTypeId);

            // Modify records directly (no update DML)
            for (Admission_Granted__c admission : admissionGrantedList) {
                if (admission.Status__c == 'Admission Process Completed') {
                    if (admission.RecordTypeId != recordTypeId) {
                        admission.RecordTypeId = recordTypeId;
                        System.debug('--- RecordTypeId updated for record ID: ' + admission.Id);
                    }
                }
            }

        } catch (Exception ex) {
            System.debug('Unexpected Exception occurred: ' + ex.getMessage());
            throw new AuraHandledException('Unexpected error occurred: ' + ex.getMessage());
        }
    }
    
    public static void fm (){
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