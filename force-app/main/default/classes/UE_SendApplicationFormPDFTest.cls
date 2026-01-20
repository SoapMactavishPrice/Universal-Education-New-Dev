@isTest public class UE_SendApplicationFormPDFTest {
    
    public static testmethod void testmethod1(){
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Test_account_name';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@gmail.com';
        con.Type__c='Admission Enquiry';
        insert con;
        
        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Stages__c='Enquiry';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='test_parent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test_address';
        enq.City__c='test_city';
        enq.State__c='test_state';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.Name='rumeli';
        enqlist.add(enq);
        insert enqlist;
        
        Application_Form__c af1=new Application_Form__c();
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Academic_Year__c='2020-21';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=10000;
        af1.Mother_Anual_Income__c=20000;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Birth_Place__c='kolkata';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='6767876543';
        af1.Mother_Business_Contact__c='9876787654';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@developer.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        insert af1;
        
        
        PageReference pageRef = Page.ApplicationformPDF;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',af1.Id);
        blob pdfBody;
        if(Test.isRunningTest()) { 
            pdfBody = blob.valueOf('Unit.Test');
        } else {
            pdfBody = pageRef.getContentAsPDF();
        }
        Attachment attach = new Attachment();
        attach.Body = pdfBody;
        attach.Name = 'Document.pdf';
        attach.IsPrivate = false;
        attach.ParentId = af1.id;
        insert attach;
        
        UE_SendApplicationFormPDF sf=new UE_SendApplicationFormPDF();
        sf.send();
        UE_SendApplicationFormPDF.sendPDF(af1.Id);
    }
    
      class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
}