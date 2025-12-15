public class SendDocumentController {
    public Id admissionId;
    
    public SendDocumentController(ApexPages.StandardController stdController) {
        admissionId = stdController.getId();
    }

    public void attachPDF() {
        /*Attachment attach = new Attachment(parentId = admissionId, Name = 'Docusign Application Form.pdf', body = pdfbody);
        insert attach;*/
        
        Blob pdfbody;
        PageReference pdf = Page.DocuSignApplicationPDF;
        pdf.getParameters().put('id', admissionId);        

        if(Test.isRunningTest()) {
            pdfBody = blob.valueOf('Unit.Test');
        } else {
            pdfbody = pdf.getContent();
        }
        
        delete [SELECT Id From Attachment Where ParentID =: admissionId AND Name LIKE '%[Docusign Template]%'];       
        
        Attachment attach = new Attachment(parentId = admissionId, Name = 'Application Form [Docusign Template].pdf', body = pdfbody);
        insert attach;        

        Admission_Granted__c adg = new Admission_Granted__c(id=admissionId);
        adg.Form_A_Sent__c = true;
        update adg;
    }

    public void attachPDF1() {
        /*Attachment attach = new Attachment(parentId = admissionId, Name = 'Docusign Application Form.pdf', body = pdfbody);
        insert attach;*/
        
        Blob pdfbody;
        PageReference pdf = Page.C1FormPDF;
        pdf.getParameters().put('id', admissionId);


        if(Test.isRunningTest()) {
            pdfBody = blob.valueOf('Unit.Test');
        } else {
            pdfbody = pdf.getContent();
        }
        
        delete [SELECT Id From Attachment Where ParentID =: admissionId AND Name LIKE '%[Docusign Template]%'];                
        
        Attachment attach = new Attachment(parentId = admissionId, Name = 'C1 Form [Docusign Template].pdf', body = pdfbody);
        insert attach;        

        Admission_Granted__c adg = new Admission_Granted__c(id=admissionId);
        adg.Form_C_Sent__c = true;
        update adg;
    }

}