global class ApplicationFormInCompleteDoc {

    webservice static Boolean UpdateDocumentInComplete(String applicationFormId){
    	Boolean result = false;
        List<Enquiry__c> updateEnquiry = new List<Enquiry__c>();
        
        List<Application_Form__c> updateApplicationForm = new List<Application_Form__c>();
        try{
            Application_Form__c af = [Select Id, Status__c,Enquiry__c from Application_Form__c where Id=:applicationFormId];
            af.Status__c = 'Document Incomplete';
            updateApplicationForm.add(af);
            
            update updateApplicationForm;
            
            
            Enquiry__c enq = [Select Id, Stages__c from Enquiry__c where Id=:af.Enquiry__c];
           	enq.Stages__c = 'Document Incomplete';
            updateEnquiry.add(enq);
            
            update updateEnquiry;
            
            result = true;
        }catch(dmlexception e){
            System.debug('Error '+e.getMessage());
            result = false;
        }
        
        return result;
    }
}