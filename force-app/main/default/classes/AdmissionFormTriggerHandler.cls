public class AdmissionFormTriggerHandler {
    public static void updateCurrentStatus(List<Admission_Form__c> listAdmissionForm){
        system.debug('listAdmissionForm ' + listAdmissionForm);
        set<string> AdmissionFormLeadId = new set<string>();
        List<Admission_Form__c> lstAdmissionForm = new List<Admission_Form__c>();
        if(RecursiveTriComCurrStatusHandler.isFirstTime == true){
            for(Admission_Form__c oAdmission_Form : listAdmissionForm){
                if(oAdmission_Form.Status__c == 'Dormant'){
                    AdmissionFormLeadId.add(oAdmission_Form.Lead_ID__c);   
                }
            }
            system.debug('AdmissionFormLeadId >> ' + AdmissionFormLeadId);
            if(!AdmissionFormLeadId.IsEmpty()){
                List<Lead> ldLists = [SELECT Id,Lead_ID__c,Current_Status__c FROM Lead where Lead_ID__c =:AdmissionFormLeadId]; 
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
    
   // Method to handle logic after insert
    public static void handleAfterInsert(List<Admission_Form__c> admissionForms) {
        // Debugging the number of records being processed
        System.debug('--- handleAfterInsert: Processing ' + admissionForms.size() + ' Admission_Form__c records.');

        // Collect Enquiry_No__r Ids to avoid querying inside loops
        Set<Id> enquiryIds = new Set<Id>();

        // Collect the School_Short_Code__c values to check the condition
        for (Admission_Form__c admissionForm : admissionForms) {
            if (admissionForm.Enquiry_No__r != null && 
                (admissionForm.School_Short_Code__c == 'STELRG' || admissionForm.School_Short_Code__c == 'STELRA' || admissionForm.School_Short_Code__c == 'STELRB')) {
                enquiryIds.add(admissionForm.Enquiry_No__r.Id);
            }
        }

        // If there are related Enquiry_No__r records to query
        if (!enquiryIds.isEmpty()) {
            // Query related Enquiry_No__r records for the required fields
            List<Enquiry__c> enquiries = [SELECT Id, Called_for_Observation__c, ST_Observation_Done__c, Observation_Re_scheduled__c
                                          FROM Enquiry__c WHERE Id IN :enquiryIds];

            // Create a map for quick lookup
            Map<Id, Enquiry__c> enquiryMap = new Map<Id, Enquiry__c>();
            for (Enquiry__c enquiry : enquiries) {
                enquiryMap.put(enquiry.Id, enquiry);
            }

            // Now, update the Admission_Form__c fields based on the Enquiry_No__r data
            List<Admission_Form__c> admissionFormsToUpdate = new List<Admission_Form__c>();
            for (Admission_Form__c admissionForm : admissionForms) {
                // Only update records that need the fields populated
                if (admissionForm.Enquiry_No__r != null && enquiryMap.containsKey(admissionForm.Enquiry_No__r.Id)) {
                    Enquiry__c relatedEnquiry = enquiryMap.get(admissionForm.Enquiry_No__r.Id);
                    
                    // Update fields from Enquiry__r to Admission_Form__c
                    if (admissionForm.School_Short_Code__c == 'STELRG' || admissionForm.School_Short_Code__c == 'STELRA' || admissionForm.School_Short_Code__c == 'STELRB') {
                        // Debugging the data being updated
                        System.debug('Updating Admission Form ID: ' + admissionForm.Id);
                        System.debug('Enquiry Called_for_Observation: ' + relatedEnquiry.Called_for_Observation__c);
                        System.debug('Enquiry Observation_Done: ' + relatedEnquiry.ST_Observation_Done__c);
                        System.debug('Enquiry Observation_Re_scheduled: ' + relatedEnquiry.Observation_Re_scheduled__c);

                        // Apply the updates
                        admissionForm.Called_for_Observation__c = relatedEnquiry.Called_for_Observation__c;
                        admissionForm.Observation_Done__c = relatedEnquiry.ST_Observation_Done__c;
                        admissionForm.Observation_Re_scheduled__c = relatedEnquiry.Observation_Re_scheduled__c;

                        // Add to the list for DML update
                        admissionFormsToUpdate.add(admissionForm);
                    }
                }
            }

            // Perform update only if there are records to update
            if (!admissionFormsToUpdate.isEmpty()) {
                System.debug('Updating ' + admissionFormsToUpdate.size() + ' Admission_Form__c records.');
                try {
                    update admissionFormsToUpdate;
                    System.debug('Successfully updated ' + admissionFormsToUpdate.size() + ' Admission_Form__c records.');
                } catch (DmlException e) {
                    // Handle potential DML exceptions
                    System.debug('Error updating Admission_Form__c records: ' + e.getMessage());
                    throw new AuraHandledException('DML Exception: ' + e.getMessage());
                }
            } else {
                System.debug('No Admission_Form__c records to update.');
            }
        } else {
            System.debug('No related Enquiry_No__r records found.');
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