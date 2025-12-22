public class LeadStageAndStatusHandler {

    // Static flags to prevent recursive execution
    private static Boolean isExecutingUpdateLeadStages = false;
    private static Boolean isExecutingUpdateLeadStatusAfter = false;
    private static Boolean isExecutingUpdateLeadStatusFromRelatedRecords = false;

    public static void updateLeadStatusAfter(List<Lead> newLeads, Map<Id, Lead> oldLeadMap) {
        // Check if this method is already executing
        if (isExecutingUpdateLeadStatusAfter) {
            System.debug('updateLeadStatusAfter already executing - preventing recursion');
            return;
        }

        // Set flag to prevent recursion
        isExecutingUpdateLeadStatusAfter = true;

        try {
            System.debug('Starting updateLeadStatusAfter method...');

            List<Lead> leadsToUpdate = new List<Lead>();

            for (Lead l : newLeads) {
                System.debug('Processing Lead Id: ' + l.Id + ', Current Status: ' + l.Status);

                Lead oldLead = oldLeadMap.get(l.Id);
                System.debug('Old Status: ' + oldLead.Status);

                if (l.Status != oldLead.Status) {
                    System.debug('Status has changed for Lead Id: ' + l.Id);

                    if (l.Status == 'Lost') {
                        System.debug('Skipping Lead Id: ' + l.Id + ' because Status is ' + l.Status);
                        continue;
                    }

                    System.debug('Preparing to update Lead_Status__c for Lead Id: ' + l.Id + ' to ' + l.Status);
                    // Create a new Lead instance for DML
                    Lead leadToUpdate = new Lead(Id = l.Id, Lead_Status__c = l.Status);
                    leadsToUpdate.add(leadToUpdate);
                } else {
                    System.debug('No Status change for Lead Id: ' + l.Id);
                }
            }

            if (!leadsToUpdate.isEmpty()) {
                System.debug('Updating ' + leadsToUpdate.size() + ' Lead(s) in database');
                update leadsToUpdate;
                System.debug('Leads updated successfully');
            } else {
                System.debug('No Leads to update');
            }

            System.debug('Finished updateLeadStatusAfter method');
        } finally {
            // Reset flag after execution completes (success or error)
            // isExecutingUpdateLeadStatusAfter = false;
        }
    }

    
    public static void updateLeadStages(List<Lead> leads) {
        // Check if this method is already executing
        if (isExecutingUpdateLeadStages) {
            System.debug('updateLeadStages already executing - preventing recursion');
            return;
        }

        // Set flag to prevent recursion
        isExecutingUpdateLeadStages = true;

        try {
            if (leads == null || leads.isEmpty()) {
                System.debug('No leads to process');
                return;
            }

            Set<Id> leadIds = new Set<Id>();
            for (Lead l : leads) {
                if (l.Id != null) {
                    leadIds.add(l.Id);
                }
            }
            if (leadIds.isEmpty()) {
                System.debug('No valid Lead Ids');
                return;
            }

            Map<Id, Enquiry__c> enquiryMap = new Map<Id, Enquiry__c>();

            List<Enquiry__c> enquiries = [SELECT Id, Lead__c, School_Tour_Scheduled__c, Meet_Done__c, 
                    Interaction_Online_Scheduled__c, Interaction_Done__c
                FROM Enquiry__c
                WHERE Lead__c IN :leadIds];

            for (Enquiry__c e : enquiries) {
                enquiryMap.put(e.Lead__c, e);
            }

            Map<Id, Admission_Form__c> admissionFormMap = new Map<Id, Admission_Form__c>();
            
            List<Admission_Form__c> admissionForms = [SELECT Id, Lead__c, Shortlisted__c, Interaction_Scheduled__c, Non_Stellar_Interaction_Done__c
                FROM Admission_Form__c
                WHERE Lead__c IN :leadIds];
            
            for (Admission_Form__c af : admissionForms) {
                admissionFormMap.put(af.Lead__c, af);
            }
            

            Map<Id, Admission_Granted__c> admissionGrantedMap = new Map<Id, Admission_Granted__c>();

            
            List<Admission_Granted__c> admissionGrants = [SELECT Id, Lead__c, Payment_Confirmed__c, Status__c
                FROM Admission_Granted__c
                WHERE Lead__c IN :leadIds];

            for (Admission_Granted__c ag : admissionGrants) {
                admissionGrantedMap.put(ag.Lead__c, ag);
            }

            for (Lead l : leads) {
                if (l.lead_Stage__c == null) {
                    l.lead_Stage__c = 'Lead';
                    System.debug('Lead ' + l.Id + ' initialized to Lead stage');
                }

                String stage = l.lead_Stage__c;
                System.debug('Processing Lead ' + l.Id + ' current stage: ' + stage);

                if (l.Converted__c == true && stage == 'Lead') {
                    l.lead_Stage__c = 'Opportunity';
                    stage = l.lead_Stage__c;
                    System.debug('Lead ' + l.Id + ' moved to Opportunity stage');
                }

                Enquiry__c enq = enquiryMap.get(l.Id);
                if (enq != null) {
                    if (enq.School_Tour_Scheduled__c == true && 
                        (stage == 'Lead' || stage == 'Opportunity')) {
                        l.lead_Stage__c = 'Meeting Schedule';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Meeting Schedule stage');
                    }
                    if (enq.Meet_Done__c == true && 
                        (stage == 'Lead' || stage == 'Opportunity' || stage == 'Meeting Schedule')) {
                        l.lead_Stage__c = 'Meeting Done';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Meeting Done stage');
                    }
                    if (enq.Interaction_Online_Scheduled__c == true && 
                        (stage == 'Lead' || stage == 'Opportunity' || stage == 'Meeting Schedule' || stage == 'Meeting Done')) {
                        l.lead_Stage__c = 'Interaction Scheduled';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Interaction Scheduled stage');
                    }
                    if (enq.Interaction_Done__c == true && 
                        (stage == 'Lead' || stage == 'Opportunity' || stage == 'Meeting Schedule' || stage == 'Meeting Done' || stage == 'Interaction Scheduled')) {
                        l.lead_Stage__c = 'Interaction Done';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Interaction Done stage');
                    }
                }

                Admission_Form__c admForm = admissionFormMap.get(l.Id);
                if (admForm != null) {
                    if (admForm.Interaction_Scheduled__c == true && 
                        (stage == 'Lead' || stage == 'Opportunity' || stage == 'Meeting Schedule' || stage == 'Meeting Done')) {
                        l.lead_Stage__c = 'Interaction Scheduled';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Interaction Scheduled stage');
                    }
                    if (admForm.Non_Stellar_Interaction_Done__c == true && 
                        (stage == 'Lead' || stage == 'Opportunity' || stage == 'Meeting Schedule' || stage == 'Meeting Done' || stage == 'Interaction Scheduled')) {
                        l.lead_Stage__c = 'Interaction Done';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Interaction Done stage');
                    }
                    if (admForm != null && admForm.Shortlisted__c == 1 && 
                        (stage == 'Lead' || stage == 'Opportunity' || stage == 'Meeting Schedule' || stage == 'Meeting Done' || stage == 'Interaction Scheduled' || stage == 'Interaction Done')) {
                        l.lead_Stage__c = 'Shortlisted';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Shortlisted stage');
                    }
                }

                Admission_Granted__c admGranted = admissionGrantedMap.get(l.Id);
                if (admGranted != null) {
                    if (admGranted.Payment_Confirmed__c == true && 
                        (stage != 'Payment Done' && stage != 'Admission Done' && stage != 'Admission Cancelled')) {
                        l.lead_Stage__c = 'Payment Done';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Payment Done stage');
                    }
                    if (admGranted.Status__c == 'Admission Process Completed') {
                        l.lead_Stage__c = 'Admission Done';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Admission Done stage');
                    }
                    if (admGranted.Status__c == 'Admission Cancelled') {
                        l.lead_Stage__c = 'Admission Cancelled';
                        stage = l.lead_Stage__c;
                        System.debug('Lead ' + l.Id + ' moved to Admission Cancelled stage');
                    }
                }
            }
        } finally {
            // Reset flag after execution completes (success or error)
            // isExecutingUpdateLeadStages = false;
        }
    }

    public static void updateLeadStatusFromRelatedRecords(List<Lead> leads) {
        // Check if this method is already executing
        if (isExecutingUpdateLeadStatusFromRelatedRecords) {
            System.debug('updateLeadStatusFromRelatedRecords already executing - preventing recursion');
            return;
        }

        // Set flag to prevent recursion
        isExecutingUpdateLeadStatusFromRelatedRecords = true;

        try {
            if (leads == null || leads.isEmpty()) {
                System.debug('No leads to process');
                return;
            }

            Set<Id> leadIds = new Set<Id>();
            for (Lead l : leads) {
                if (l.Id != null) {
                    leadIds.add(l.Id);
                } else {
                    System.debug('Skipping Lead with no Id (cannot query related records) - temp record: ' + l);
                }
            }

            if (leadIds.isEmpty()) {
                System.debug('No valid Lead Ids to query related records for.');
                return;
            }

            Map<Id, Enquiry__c> enquiryByLead = new Map<Id, Enquiry__c>();
            for (Enquiry__c e : [SELECT Id, Lead__c, Application_Link_Sent__c, Reason_Lost__c FROM Enquiry__c WHERE Lead__c IN :leadIds]) {
                if (e != null && e.Lead__c != null && !enquiryByLead.containsKey(e.Lead__c)) {
                    enquiryByLead.put(e.Lead__c, e);
                }
            }

            Map<Id, Application_Form__c> appFormByLead = new Map<Id, Application_Form__c>();
            for (Application_Form__c a : [SELECT Id, Lead__c, Print_Copy_Submitted__c, Application_Accepted__c, Application_Rejected__c, Document_Verified__c FROM Application_Form__c WHERE Lead__c IN :leadIds]) {
                if (a != null && a.Lead__c != null && !appFormByLead.containsKey(a.Lead__c)) {
                    appFormByLead.put(a.Lead__c, a);
                }
            }

            Map<Id, Admission_Form__c> admissionFormByLead = new Map<Id, Admission_Form__c>();
            for (Admission_Form__c af : [SELECT Id, Lead__c, Document_Received__c, Reason_Lost__c FROM Admission_Form__c WHERE Lead__c IN :leadIds]) {
                if (af != null && af.Lead__c != null && !admissionFormByLead.containsKey(af.Lead__c)) {
                    admissionFormByLead.put(af.Lead__c, af);
                }
            }

            for (Lead l : leads) {
                if (l.Id == null) {
                    continue;
                }

                System.debug('Processing Lead ' + l.Id + ' starting Status: ' + l.Lead_Status__c);
                Enquiry__c enq = enquiryByLead.get(l.Id);
                if (enq != null && enq.Application_Link_Sent__c == true) {
                    l.Lead_Status__c = 'Application Sent';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Application Sent" because Enquiry__c.Application_Link_Sent__c is true');
                }

                if (enq != null && enq.Reason_Lost__c == true) {
                    l.Lead_Status__c = 'Lost';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Lost" because Enquiry__c.Reason_Lost__c is true');
                }

                Application_Form__c app = appFormByLead.get(l.Id);
                if (app != null && app.Print_Copy_Submitted__c == true) {
                    l.Lead_Status__c = 'Application Received';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Application Received" because Application_Form__c.Print_Copy_Submitted__c is true');
                }

                if (app != null && app.Application_Rejected__c == true) {
                    l.Lead_Status__c = 'Application Reject';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Application Reject" because Application_Form__c.Application_Rejected__c is true');
                }

                if (app != null && app.Document_Verified__c == true) {
                    l.Lead_Status__c = 'Document Verified';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Document Verified" because Application_Form__c.Document_Verified__c is true');
                }

                if (app != null && app.Application_Accepted__c == true) {
                    l.Lead_Status__c = 'Application Accepted';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Application Accepted" because Application_Form__c.Application_Accepted__c is true');
                }

                Admission_Form__c adm = admissionFormByLead.get(l.Id);
                if (adm != null && adm.Document_Received__c == true) {
                    l.Lead_Status__c = 'Documents Received';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Documents Received" because Admission_Form__c.Document_Received__c is true');
                }
                if (adm != null && adm.Reason_Lost__c == true) {
                    l.Lead_Status__c = 'Lost';
                    System.debug('Lead ' + l.Id + ' -> Status set to "Lost" because Admission_Form__c.Reason_Lost__c is true');
                }

                System.debug('Processing complete for Lead ' + l.Id + ' final Status: ' + l.Lead_Status__c);
            }
        } finally {
            // Reset flag after execution completes (success or error)
            // isExecutingUpdateLeadStatusFromRelatedRecords = false;
        }
    }

}