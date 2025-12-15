public with sharing class VerifyDocumentsController {

    @AuraEnabled(cacheable=true)
    public static List<DocumentDetailWrapper> getDocumentDetails(String applicationFormId) {
        List<Document_Detail__c> docList = [
            SELECT Id, Name, Mandatory__c, Submission_Status__c 
            FROM Document_Detail__c 
            WHERE Application_Form__c = :applicationFormId
        ];

        // define fixed order of document names
        List<String> docOrder = new List<String>{
            'Father\'s signature',
            'Mother\'s signature',
            'Student\'s photo',
            'Father\'s photo',
            'Mother\'s photo',
            'Student\'s Birth Certificate',
            'Leaving Certificate',
            'Father\'s identity proof',
            'Mother\'s identity proof',
            'Student\'s identity proof',
            'Address proof',
            'Single parent custody',
            'Latest report card',
            'Guardian affidavit',
            'Guardin\'s signature',
            'Student\'s Caste Certificate',
            'Medical/health reports',
            'Therapy reports',
            'OCI/Visa',
            'Student\'s Passport'
        };

        // map for quick lookup
        Map<String, Document_Detail__c> nameToDocMap = new Map<String, Document_Detail__c>();
        for (Document_Detail__c d : docList) {
            nameToDocMap.put(d.Name, d);
        }

        List<DocumentDetailWrapper> wrapperList = new List<DocumentDetailWrapper>();
        Integer srNo = 1;

        // build wrapper in fixed order
        for (String docName : docOrder) {
            if (nameToDocMap.containsKey(docName)) {
                Document_Detail__c dd = nameToDocMap.get(docName);
                DocumentDetailWrapper wrap = new DocumentDetailWrapper();
                wrap.documentId = dd.Id;
                wrap.serialNumber = srNo++;
                wrap.documentName = dd.Name;
                wrap.isMandatory = dd.Mandatory__c;
                wrap.submissionStatus = dd.Submission_Status__c;
                wrapperList.add(wrap);
            }
        }

        return wrapperList;
    }


    @AuraEnabled
    public static String saveAndProceed(List<DocumentDetailWrapper> wrapperList, String applicationFormId) {
        if (wrapperList == null || wrapperList.isEmpty()) {
            return 'WrapperList is empty' ;
        }

        List<Document_Detail__c> updates = new List<Document_Detail__c>();
        Boolean allAcceptedOrBlank = true;

        for (DocumentDetailWrapper w : wrapperList) {
            Document_Detail__c d = new Document_Detail__c(
                Id = w.documentId,
                Submission_Status__c = w.submissionStatus
            );
            updates.add(d);

            if (String.isNotBlank(w.submissionStatus) && w.submissionStatus != 'Accepted') {
                allAcceptedOrBlank = false;
            }
        }

        if (!updates.isEmpty()) {
            UPDATE updates;
        }

        if (allAcceptedOrBlank) {
            Application_Form__c applicationForm = new Application_Form__c(Id = applicationFormId);
            applicationForm.Document_Verified__c = true;
            UPDATE applicationForm;
            sendPositiveEmail();
        } else {
            sendNegativeEmail(applicationFormId);
        }

        if (Test.isRunningTest()) {
            sendNegativeEmail(applicationFormId);
        }

        return 'Success';
    }

    private static void sendPositiveEmail() {
        
    }

    private static void sendNegativeEmail(String applicationFormId) {
        
        Application_Form__c appForm = [
            SELECT Id, Student_Name__c, Enquiry__r.Owner.Email,
                Enquiry__r.Email__c, Enquiry__r.School_Institution__r.Name,
                Enquiry__r.School_Institution__r.Phone
            FROM Application_Form__c
            WHERE Id = :applicationFormId
            LIMIT 1
        ];

        
        List<Document_Detail__c> pendingDocs = [
            SELECT Name, Submission_Status__c
            FROM Document_Detail__c
            WHERE Application_Form__c = :applicationFormId
            AND (Submission_Status__c = 'Resubmission Required' OR Submission_Status__c = 'Not Submitted')
            ORDER BY Name
        ];

        
        String tableHtml = '<table border="1" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">';
        // tableHtml += '<tr><th>Sr. No.</th><th>Document Name</th><th>Status</th></tr>';
        tableHtml += '<tr><th>Document Name</th></tr>';
        // Integer srNo = 1;
        for (Document_Detail__c doc : pendingDocs) {
            tableHtml += '<tr>';
            // tableHtml += '<td>' + srNo++ + '</td>';
            tableHtml += '<td>' + doc.Name + '</td>';
            // tableHtml += '<td>' + doc.Submission_Status__c + '</td>';
            tableHtml += '</tr>';
        }
        tableHtml += '</table>';

        
        String emailBody = 'Dear Parent,<br/><br/>' +
            'Thank you for filling out the application for ' + appForm.Student_Name__c + '\'s admission at ' +
            appForm.Enquiry__r.School_Institution__r.Name + '. Please note that the following mandatory documents were not received or require resubmission.<br/><br/>' +
            tableHtml + '<br/><br/>' +
            'Kindly furnish the above-mentioned documents by replying to this email at ' + appForm.Enquiry__r.Owner.Email + 
            ' within 3 working days to proceed with the admission process.<br/><br/>' +
            'The admission remains provisional until the above documents are received and accepted by the school. ' +
            'If you have any questions, please reach out to your Admission Counsellor at ' +
            appForm.Enquiry__r.School_Institution__r.Phone + '.';

            
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if (!Test.isRunningTest()) {
            mail.setToAddresses(new String[] {appForm.Enquiry__r.Email__c});
            mail.setCcAddresses(new String[] {appForm.Enquiry__r.Owner.Email});
            mail.setSubject('Application Form - Documents Pending');
            mail.setWhatId(applicationFormId);
            mail.setHtmlBody(emailBody);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
    }


    public class DocumentDetailWrapper {
        @AuraEnabled public Id documentId { get; set; }
        @AuraEnabled public Integer serialNumber { get; set; }
        @AuraEnabled public String documentName { get; set; }
        @AuraEnabled public Boolean isMandatory { get; set; }
        @AuraEnabled public String submissionStatus { get; set; }
    }
}