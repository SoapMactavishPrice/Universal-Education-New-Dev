@isTest
public class UE_CtrEnquiryFormTest {
    
    static testMethod void UE_CtrEnquiryFormTest() {
    //UE_CtrEnquiryForm uc=new UE_CtrEnquiryForm();
	
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
    Account acc = new Account();
    acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHT';
    insert acc;
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
        
         Enquiry__c enq1 = new Enquiry__c();
        enq1.Contact__c =con.Id;
        enq1.Enquiry_Type__c='Test_General';
        enq1.Date_of_Birth__c=system.today()-2000;
        enq1.Academic_Year__c='2015';
        enq1.FirstName__c='test_Student';
        enq1.Last_Name__c='Test';
        enq1.Log_Status__c='On Hold';
        enq1.Seeking_Admission_in_Grade__c='II';
        enq1.Parent_First_Name__c ='test_parent';
        enq1.Parent_Last_Name__c= con.LastName;
        enq1.Email__c=con.Email;
        //enq1.Mobile_No__c =con.MobilePhone;
        enq1.School_Institution__c=con.AccountId;
        enq1.Address__c ='test_address';
        insert enq1;
        
    Enquiry__c enq = new Enquiry__c();
       //enq.Contact__c =con.Id;
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
        enq.Enquiry__c=enq1.Id;
        enq.Contact__c=con.Id;
        insert enq;
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enq1);
        UE_CtrEnquiryForm uc1= new UE_CtrEnquiryForm(sc1);
        uc1.save();
        List<Enquiry__c> enq1list=new List<Enquiry__c>();
        enq1list.add(enq1);
        system.assertEquals(enq1list.size(),1);
        String aa='UHM';
        
        PageReference pageRef = Page.UE_AdmissionFormVF;
          Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('sname',aa);
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        UE_CtrEnquiryForm uc= new UE_CtrEnquiryForm(sc);
        uc.dob=system.today();
        uc.pdate=system.today();
        uc.pdate1=system.today();
        uc.option='option';
        uc.field2='field2';
        uc.f3='f3';
        uc.message='message';
        
        
        uc.save();
        uc.cancle();
        uc.reset();
        uc.makeNewEnquiry();
        uc.forgotEnquiry();
        uc.getEnquiryNumber();
        uc.setupPickValMap();
        uc.getPrimaryPickVals();
        uc.getSecondaryPickVals();
        
 }
    static testMethod void UE_CtrEnquiryFormTest1(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
    acc.Name ='Test_account_name';
    insert acc;
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
        
         Enquiry__c enq1 = new Enquiry__c();
        enq1.Contact__c =con.Id;
        enq1.Enquiry_Type__c='Test_General';
        enq1.Date_of_Birth__c=system.today()-2000;
        enq1.Academic_Year__c='2015';
        enq1.FirstName__c='test_Student';
        enq1.Last_Name__c='Test';
        enq1.Log_Status__c='On Hold';
        enq1.Seeking_Admission_in_Grade__c='II';
        enq1.Parent_First_Name__c ='test_parent';
        enq1.Parent_Last_Name__c= con.LastName;
        enq1.Email__c=con.Email;
        //enq1.Mobile_No__c =con.MobilePhone;
        enq1.School_Institution__c=con.AccountId;
        enq1.Address__c ='test_address';
        insert enq1;
        
    Enquiry__c enq = new Enquiry__c();
       //enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
       // enq.FirstName__c='test_Student';
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
        enq.Enquiry__c=enq1.Id;
        enq.Contact__c=con.Id;
        insert enq;
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        UE_CtrEnquiryForm uc= new UE_CtrEnquiryForm(sc);
        uc.dob=system.today();
        uc.pdate=system.today();
        uc.pdate1=system.today();
        uc.option='option';
        uc.field2='field2';
        uc.f3='f3';
        uc.message='message';
        uc.eid=apexpages.currentpage().getparameters().get('id');
        
        uc.save();
        
    }
    static testMethod void UE_CtrEnquiryFormTest2(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
    acc.Name ='Test_account_name';
    insert acc;
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
        
    Enquiry__c enq = new Enquiry__c();
       //enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
       // enq.FirstName__c='test_Student';
       // enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
       // enq.Parent_First_Name__c ='test_parent';
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
        enq.Contact__c=con.Id;
        //enq.Enquiry__c=enq1.Id;
        insert enq;
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        UE_CtrEnquiryForm uc= new UE_CtrEnquiryForm(sc);
        uc.dob=system.today();
        uc.pdate=system.today();
        uc.pdate1=system.today();
        uc.option='option';
        uc.field2='field2';
        uc.f3='f3';
        uc.message='message';
        uc.eid=apexpages.currentpage().getparameters().get('id');
        
        uc.save();
        
    }
     static testMethod void UE_CtrEnquiryFormTest3(){
         
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         
        Account acc = new Account();
    acc.Name ='Test_account_name';
    insert acc;
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
        
    Enquiry__c enq = new Enquiry__c();
       //enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
       // enq.FirstName__c='test_Student';
       // enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
       // enq.Parent_First_Name__c ='test_parent';
        //enq.Parent_Last_Name__c= con.LastName;
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
		enq.Country__c='India';
         enq.Contact__c=con.Id;
        insert enq;
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        UE_CtrEnquiryForm uc= new UE_CtrEnquiryForm(sc);
        uc.dob=system.today();
        uc.pdate=system.today();
        uc.pdate1=system.today();
        uc.option='option';
        uc.field2='field2';
        uc.f3='f3';
        uc.message='message';
        uc.eid=apexpages.currentpage().getparameters().get('id');
        
        uc.save();
    }
      static testMethod void UE_CtrEnquiryFormTest4(){
        Account acc = new Account();
    acc.Name ='Test_account_name';
    insert acc;
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
        
    Enquiry__c enq = new Enquiry__c();
       //enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
       // enq.FirstName__c='test_Student';
       // enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
       // enq.Parent_First_Name__c ='test_parent';
        //enq.Parent_Last_Name__c= con.LastName;
        //enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test_address';
        //enq.City__c='test_city';
        enq.State__c='test_state';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
		enq.Country__c='India';
          enq.Contact__c=con.Id;
        insert enq;
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        UE_CtrEnquiryForm uc= new UE_CtrEnquiryForm(sc);
        uc.dob=system.today();
        uc.pdate=system.today();
        uc.pdate1=system.today();
        uc.option='option';
        uc.field2='field2';
        uc.f3='f3';
        uc.message='message';
        uc.eid=apexpages.currentpage().getparameters().get('id');
        
        uc.save();
        
    }
      static testMethod void UE_CtrEnquiryFormTest5(){
          
           Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          
        Account acc = new Account();
    acc.Name ='Test_account_name';
    insert acc;
    
    Contact con = new Contact();
    con.FirstName = 'Test_First_name';
    con.LastName ='Test_Last _name';
    con.AccountId=acc.Id;
    con.MobilePhone='9123445678';
    con.Email='biswajit@developer.com';
    con.Type__c='Admission Enquiry';
    insert con;
        
    Enquiry__c enq = new Enquiry__c();
       //enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
       // enq.FirstName__c='test_Student';
       // enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
          enq.Mobile_No__c=con.MobilePhone;
        enq.Seeking_Admission_in_Grade__c='II';
       // enq.Parent_First_Name__c ='test_parent';
        //enq.Parent_Last_Name__c= con.LastName;
        //enq.Email__c=con.Email;
        //enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        //enq.Address__c ='test_address';
        //enq.City__c='test_city';
       // enq.State__c='test_state';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
		enq.Country__c='India';
          enq.Contact__c=con.Id;
        insert enq;
        ApexPages.StandardController sc = new ApexPages.StandardController(enq);
        UE_CtrEnquiryForm uc= new UE_CtrEnquiryForm(sc);
        uc.dob=system.today();
        uc.pdate=system.today();
        uc.pdate1=system.today();
        uc.option='option';
        uc.field2='field2';
        uc.f3='f3';
        uc.message='message';
        uc.eid=apexpages.currentpage().getparameters().get('id');
        
        uc.save();
        
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