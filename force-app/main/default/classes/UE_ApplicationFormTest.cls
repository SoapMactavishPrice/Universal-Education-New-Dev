@isTest public class UE_ApplicationFormTest {

    @isTest public static void testmethod1(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Test_account_name';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;


        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
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
        enqlist.add(enq);
        insert enqlist;


       Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        //af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=false;
        af1.School_Institution__c = enq.School_Institution__c;
        insert af1;

        PageReference pageRef = Page.newApplicationForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('eid',af1.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(af1);
        UE_ApplicationForm ag1= new UE_ApplicationForm(sc1);

        ag1.getpassport();
        ag1.getexpdate();
        ag1.validateMother();
        ag1.save();
        ag1.toggleEditMode();
        //ag1.verifyOtpSms();
        //ag1.sendOTP();
        UE_ApplicationForm.fakeMethod();
    }

    @isTest public static void testmethod2(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Test_account_name';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;


        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
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
        enq.School_Institution__c = con.AccountId;

        enqlist.add(enq);
        insert enqlist;


       Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        //af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Ind@ian';
        //af1.Mother_Tongue__c='Bengali';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=false;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.Application_Form_Declaration__c=true;
        af1.School_Institution__c = enq.School_Institution__c;

        insert af1;

        PageReference pageRef = Page.newApplicationForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('eid',af1.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(af1);
        UE_ApplicationForm ag1= new UE_ApplicationForm(sc1);

        ag1.getpassport();
        ag1.getexpdate();
        ag1.validateMother();
        ag1.save();
        ag1.toggleEditMode();
        //ag1.verifyOtpSms();
        //ag1.sendOTP();

    }

    @isTest public static void testmethod3(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Testsaccountname';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;


        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
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
        enq.orgCode__c='123';
        enqlist.add(enq);
        insert enqlist;


       Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='76876876565';
        af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        //af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wif@';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=false;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=false;
        af1.School_Institution__c=acc.Id;
        af1.Autonumber_apexClass__c=5;

        insert af1;

       /* smsgupshupTemplate__c sms=new smsgupshupTemplate__c();
        sms.Name__c='OTP';
        sms.Description__c='description';
        insert sms;*/

        PageReference pageRef = Page.newApplicationForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('eid',af1.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(af1);
        UE_ApplicationForm ag1= new UE_ApplicationForm(sc1);

        ag1.getpassport();
        ag1.getexpdate();
        ag1.validateMother();
        ag1.save();
        ag1.toggleEditMode();
        //ag1.verifyOtpSms();
        //ag1.sendOTP();

    }
    @isTest public static void testmethod4(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Testsaccountname';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;


        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
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
        enq.orgCode__c='123';
        enqlist.add(enq);
        insert enqlist;


       Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='7687687656544';
        af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        //af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='12344';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indi@n';
       // af1.Mother_Tongue__c='Beng@li';
        //af1.Mother_Occupation__c='House Wif@';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        //af1.Single_Parent__c=false;
        //af1.Mother_Detail_Captured__c=true;
        //af1.Father_Datail_captured__c=false;
        //af1.School_Institution__c=acc.Id;
       // af1.Autonumber_apexClass__c=5;

        insert af1;

       /* smsgupshupTemplate__c sms=new smsgupshupTemplate__c();
        sms.Name__c='OTP';
        sms.Description__c='description';
        insert sms;*/

        PageReference pageRef = Page.newApplicationForm;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('eid',af1.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(af1);
        UE_ApplicationForm ag1= new UE_ApplicationForm(sc1);

        ag1.getpassport();
        ag1.getexpdate();
        ag1.validateMother();
        ag1.save();
        ag1.toggleEditMode();
        //ag1.verifyOtpSms();
        //ag1.sendOTP();

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