public class EnquiryTriggerHandler {

    // 1. Called in BEFORE INSERT to populate Enquiry__c fields from Walk-In Leads
    public static void populateEnquiryFromWalkinLead(List<Enquiry__c> enquiries) {
        Map<Id, Enquiry__c> leadIdToEnquiryMap = new Map<Id, Enquiry__c>();
        for (Enquiry__c enq : enquiries) {
            if (enq.Lead__c != null) {
                leadIdToEnquiryMap.put(enq.Lead__c, enq);
            }
        }

        if (leadIdToEnquiryMap.isEmpty()) return;

        Map<Id, Lead> walkinLeads = new Map<Id, Lead>([
            SELECT Id, LeadSource,
                   Apartment_Society__c, Landmark__c, Current_school__c,
                   Mother_s_Educational_Qualifications__c, Father_s_Educational_Qualifications__c,
                   Mother_s_Occupation__c, Father_s_Occupation__c, Pin_code__c,
                   How_did_you_hear_about_us__c
            FROM Lead
            WHERE Id IN :leadIdToEnquiryMap.keySet()
            AND LeadSource = 'Walkin'
        ]);

        for (Id leadId : walkinLeads.keySet()) {
            Lead lead = walkinLeads.get(leadId);
            Enquiry__c enq = leadIdToEnquiryMap.get(leadId);

            enq.Apartment_Society__c = lead.Apartment_Society__c;enq.Locality__c = lead.Landmark__c;enq.Current_school__c = lead.Current_school__c;
            enq.Mother_s_Educational_Qualifications__c = lead.Mother_s_Educational_Qualifications__c;
            enq.Father_s_Educational_Qualifications__c = lead.Father_s_Educational_Qualifications__c;
            enq.Mother_s_Occupation__c = lead.Mother_s_Occupation__c;
            enq.Father_s_Occupation__c = lead.Father_s_Occupation__c;enq.Demographic_Pin_code__c = lead.Pin_code__c;
            enq.How_did_you_hear_about_us__c = lead.How_did_you_hear_about_us__c;
              enq.Demographic__c=true; enq.Demo_Submitted_date__c=system.now().format('dd-MM-yyyy');enq.Demo_Submitted_Time__c=DateTime.now().format('hh:mm a');
        }
    }

    // 2. Called in AFTER INSERT/UPDATE to update Leads from Enquiry__c (excluding Walkin leads)
    public static void updateLeadsFromNonWalkinEnquiry(List<Enquiry__c> enquiries) {
        Map<Id, Enquiry__c> leadIdToEnquiryMap = new Map<Id, Enquiry__c>();

        for (Enquiry__c enq : enquiries) {
            if (enq.Lead__c != null) {
                leadIdToEnquiryMap.put(enq.Lead__c, enq);
            }
        }

        if (leadIdToEnquiryMap.isEmpty()) return;

        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : [
            SELECT Id, LeadSource
            FROM Lead
            WHERE Id IN :leadIdToEnquiryMap.keySet()
            AND LeadSource != 'Walkin'
        ]) {
            Enquiry__c e = leadIdToEnquiryMap.get(lead.Id);

            Lead l = new Lead(
                Id = lead.Id,
                Apartment_Society__c = e.Apartment_Society__c,
                Landmark__c = e.Locality__c,
                Current_school__c = e.Current_school__c,
                Mother_s_Educational_Qualifications__c = e.Mother_s_Educational_Qualifications__c,
                Father_s_Educational_Qualifications__c = e.Father_s_Educational_Qualifications__c,
                Mother_s_Occupation__c = e.Mother_s_Occupation__c,
                Father_s_Occupation__c = e.Father_s_Occupation__c,
                Pin_code__c = e.Demographic_Pin_code__c,
                How_did_you_hear_about_us__c = e.How_did_you_hear_about_us__c
            );

            leadsToUpdate.add(l);
        }

        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
                System.debug('Updated ' + leadsToUpdate.size() + ' Leads from Enquiry.');
            } catch (DmlException ex) {
                System.debug('Error updating leads: ' + ex.getMessage());
            }
        }
    }
}