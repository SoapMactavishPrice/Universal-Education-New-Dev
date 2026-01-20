@isTest 
public class SendDocumentControllerTest {
    
	/*@isTest
    public static void sendDocumentTest() {
    	Admission_Granted__c objAdmissionGrant = new Admission_Granted__c();
        objAdmissionGrant.Name = 'Test Record';
        insert objAdmissionGrant;
        
        Attachment obj = new Attachment();
        obj.Name= 'Docusign Application Form.pdf';
        obj.Body = Blob.valueOf('jgkjhk');
        obj.ParentId = objAdmissionGrant.ID;
        insert obj;
        
        System.Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(objAdmissionGrant);
            SendDocumentController objController = new SendDocumentController(sc);
            objController.attachPDF();
        System.Test.stopTest();
    } */

/*    @isTest
    public static void sendDocumentTest1() {
    	Admission_Granted__c objAdmissionGrant = new Admission_Granted__c();
        objAdmissionGrant.Name = 'Test Record';
        insert objAdmissionGrant;
        
        Attachment obj = new Attachment();
        obj.Name= 'red.pdf';
        obj.Body = Blob.valueOf('jgkjhk');
        obj.ParentId = objAdmissionGrant.ID;
        insert obj;
        
        System.Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(objAdmissionGrant);
            SendDocumentController objController = new SendDocumentController(sc);
            objController.attachPDF();
        System.Test.stopTest();
    } */

    @isTest
    public static void sendDocumentTest2() {
    	Admission_Granted__c objAdmissionGrant = new Admission_Granted__c();
        objAdmissionGrant.Name = 'Test Record';
        insert objAdmissionGrant;
        
        Attachment obj = new Attachment();
        obj.Name= 'red.pdf';
        obj.Body = Blob.valueOf('jgkjhk');
        obj.ParentId = objAdmissionGrant.ID;
        insert obj;
        
        System.Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(objAdmissionGrant);
            SendDocumentController objController = new SendDocumentController(sc);
            objController.attachPDF1();
        System.Test.stopTest();
    }
}