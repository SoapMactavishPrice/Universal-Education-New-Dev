public class ApplicationTrgFormHandler {
  public static void syncLeadFieldsFromApplicationForm(List<Application_Form__c> appForms) {
        Map<Id, Application_Form__c> leadMap = new Map<Id, Application_Form__c>();
        
        for (Application_Form__c form : appForms) {
            if (form.Lead__c != null) {
                leadMap.put(form.Lead__c, form);
            }
        }
        
        if (leadMap.isEmpty()) return;
        
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Id leadId : leadMap.keySet()) {
            Application_Form__c form = leadMap.get(leadId);
            Lead l = new Lead(
                Id = leadId,
                Are_you_a_single_parent__c = form.Single_Parent__c,
                Father_s_First_Name__c = form.Father_First_Name__c,
                Father_s_Last_Name__c = form.Father_Last_Name__c,
                Father_s_Mobile_number__c = form.Father_Phone__c,
                Father_s_Email_ID__c = form.Father_Email_Id__c,
                Name_of_the_organisation_father__c = form.Father_Name_of_Organisation__c,
                Father_s_Designation__c = form.Father_Designation__c,
                Mother_s_First_Name__c = form.Mother_First_Name__c,
                Mother_s_Last_Name__c = form.Mother_Last_Name__c,
                Mother_s_Mobile_number__c = form.Mother_Phone__c,
                Mother_s_Email_ID__c = form.Mother_Email_Id__c,
                Name_of_the_organisation_Mother__c = form.Mother_Name_of_Organisation__c,
                Mother_s_Designation__c = form.Mother_Designation__c
            );
            leadsToUpdate.add(l);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            // try {
                update leadsToUpdate;
                System.debug('Updated ' + leadsToUpdate.size() + ' Lead(s) from Application_Form__c.');
            // } catch (DmlException e) {
            //     System.debug('Failed to update Lead(s): ' + e.getMessage());
            //     throw new AuraHandledException('Lead Update Failed: ' + e.getMessage());
            // }
        }
    }

    public static void syncEnquiryFieldsFromApplicationForm(List<Application_Form__c> appForms) {
        Map<Id, Application_Form__c> enquiryMap = new Map<Id, Application_Form__c>();
        
        for (Application_Form__c form : appForms) {
            if (form.Enquiry__c != null) {
                enquiryMap.put(form.Enquiry__c, form);
            }
        }
        
        if (enquiryMap.isEmpty()) return;
        
        List<Enquiry__c> enquiriesToUpdate = new List<Enquiry__c>();
        
        for (Id leadId : enquiryMap.keySet()) {
            Application_Form__c form = enquiryMap.get(leadId);
            Enquiry__c l = new Enquiry__c(
                Id = leadId,
                Are_you_a_single_parent__c = form.Single_Parent__c,
                Father_s_First_Name__c = form.Father_First_Name__c,
                Father_s_Last_Name__c = form.Father_Last_Name__c,
                Father_s_Mobile_number__c = form.Father_Phone__c,
                Father_s_Email_ID__c = form.Father_Email_Id__c,
                Name_of_the_organisation_father__c = form.Father_Name_of_Organisation__c,
                Father_s_Designation__c = form.Father_Designation__c,
                Mother_s_First_Name__c = form.Mother_First_Name__c,
                Mother_s_Last_Name__c = form.Mother_Last_Name__c,
                Mother_s_Mobile_number__c = form.Mother_Phone__c,
                Mother_s_Email_ID__c = form.Mother_Email_Id__c,
                Name_of_the_organisation_Mother__c = form.Mother_Name_of_Organisation__c,
                Mother_s_Designation__c = form.Mother_Designation__c
            );
            enquiriesToUpdate.add(l);
        }
        
        if (!enquiriesToUpdate.isEmpty()) {
            // try {
                update enquiriesToUpdate;
                System.debug('Updated ' + enquiriesToUpdate.size() + ' Lead(s) from Application_Form__c.');
            // } catch (DmlException e) {
            //     System.debug('Failed to update Lead(s): ' + e.getMessage());
            //     throw new AuraHandledException('Lead Update Failed: ' + e.getMessage());
            // }
        }
    }
}