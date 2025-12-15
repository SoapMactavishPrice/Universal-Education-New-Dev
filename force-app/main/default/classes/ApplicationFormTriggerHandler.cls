public class ApplicationFormTriggerHandler {

    // Method to update Address fields when Full_Address__c is not null
    public static void updateAddressFields(List<Application_Form__c> applicationForms) {
        // Debugging the number of records being processed
        System.debug('--- updateAddressFields: Processing ' + applicationForms.size() + ' Application_Form__c records.');

        // Create a list to hold records that need to be updated
        List<Application_Form__c> applicationFormsToUpdate = new List<Application_Form__c>();

        // Iterate through the Application_Form__c records
        for (Application_Form__c appForm : applicationForms) {
            // Check if Full_Address__c is not null and update the Address__c and Residential_Address__c fields
            if (appForm.Full_Address__c != null) {
                // Debugging the address being used for update
                System.debug('Updating Application_Form__c ID: ' + appForm.Id);
                System.debug('Full_Address__c: ' + appForm.Full_Address__c);

                // Update the Address__c and Residential_Address__c fields
                appForm.Address__c = appForm.Full_Address__c;
                appForm.Residential_Address__c = appForm.Full_Address__c;

                // Add the record to the update list
                applicationFormsToUpdate.add(appForm);
            }
        }

        // Perform the update if there are records to update
        if (!applicationFormsToUpdate.isEmpty()) {
            // Debugging the number of records being updated
            System.debug('Updating ' + applicationFormsToUpdate.size() + ' Application_Form__c records.');

            try {
                update applicationFormsToUpdate;
                System.debug('Successfully updated ' + applicationFormsToUpdate.size() + ' Application_Form__c records.');
            } catch (DmlException e) {
                // Handle any DML exceptions and log the error
                System.debug('Error updating Application_Form__c records: ' + e.getMessage());
                throw new AuraHandledException('DML Exception: ' + e.getMessage());
            }
        } else {
            // Debugging if no records were updated
            System.debug('No Application_Form__c records were updated.');
        }
    }
}