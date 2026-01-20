@isTest
public class CCAvenuePaymentGateway_Cntl_Test {
    @isTest public static void testmethod1(){
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Contact con = new Contact();
        User u;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Enquiry__c enq = new Enquiry__c();
        Event ev=new Event();
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            //UserRole r = [SELECT Id FROM UserRole];
            u = new User(alias = 'jsmith', email='jsmith@acme.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id,
                timezonesidkey='America/Los_Angeles', 
                username='tt_jsmith@acme123.com');
            insert u;
            
            Account acc = new Account();
            acc.Name ='Universal Test';
            acc.School_Short_Code__c = 'EISN';
            insert acc;
            
            con.FirstName = 'Test_First_name';
            con.LastName ='Test_Last _name';
            con.AccountId = acc.Id;
            con.MobilePhone='9123445678';
            con.Email='rumeli@developer.com';
            con.Type__c='Admission Enquiry';
            insert con;
            
            enq.Contact__c =con.Id;
            enq.Enquiry_Type__c='Test_General';
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
            enq.School_Tour_Scheduled__c=false;
            enq.School_Tour_Re_Scheduled__c=false;
            enq.Interaction_Done__c=false;
            enq.School_Institution__c = acc.ID;
            insert enq;
            
            Class__c objClass = new Class__c();
            objClass.School_Name__c = acc.ID;
            objClass.Original_Class__c = enq.Seeking_Admission_in_Grade__c;
            insert objClass;
            
            ApexPages.currentPage().getParameters().put('eid',enq.id);
            CC_Avenue_Settings__c setting = new CC_Avenue_Settings__c();
            setting.TID__c = '76038402';
            setting.Currency__c = 'INR';
            setting.Redirect_URL__c = 'https://partialcop-universaleducation.cs111.force.com/CCAvenueResponsePage';
            setting.Working_Key__c = '42001027BB54D88C9BE10BA630128C00';
            setting.Cancel_URL__c = 'https://partialcop-universaleducation.cs111.force.com/CCAvenueTransactionCancelled';
            setting.Language__c = 'EN';
            setting.Use_Production_URL__c = true;
            setting.Production_URL__c = 'https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction';
            setting.SF_Site_URL__c =  'https://partialcop-universaleducation.cs111.force.com/';
            setting.Merchant_ID__c = '268341';
            insert setting;
            
            CCAvenuePaymentGateway_Cntl obj = new CCAvenuePaymentGateway_Cntl();
            obj.payNow();
        }
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