@isTest public class send_Application_through_EmailTest {

    @isTest public static void testmethod1(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        System.Test.startTest();
        
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
        
        
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Stages__c='Enquiry';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c='rumeli@gmail.com';
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Interested';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=false;
        enq.Name='rumeli';
        enq.Interested__c = true;
        enq.Interaction_Done__c = true;
       
   		insert enq;
        
        
        PageReference pageRef = Page.UE_sendApplication;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('id',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_send_ApplicationForm_through_Email ag1= new UE_send_ApplicationForm_through_Email();
        
        
   		ag1.send();
        System.Test.stopTest();
    }
    
    @isTest public static void testmethod3(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        System.Test.startTest();
        
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
        
        
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Stages__c='Enquiry';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2019-20';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c='rumeli@gmail.com';
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application Link Sent';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=false;
        enq.Name='rumeli';
        enq.Interested__c = true;
        enq.Interaction_Done__c = true;
       
   		insert enq;
        
        
        PageReference pageRef = Page.UE_sendApplication;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('id',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_send_ApplicationForm_through_Email ag1= new UE_send_ApplicationForm_through_Email();
        
        
   		ag1.send();
        ag1.cancel();
        System.Test.stopTest();
    }
    
    @isTest public static void testmethod2(){
        
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        System.Test.startTest();
        
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
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
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
        enq.Stages__c='Application Link Sent';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=false;
        enq.Name='rumeli';
        
        //enqlist.add(enq);
   		insert enq;
        
        enq.Stages__c = 'Meet Done';
        enq.Interaction_Done__c = true;
        update enq;
        
        PageReference pageRef = Page.UE_sendApplication;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('id',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_send_ApplicationForm_through_Email ag1= new UE_send_ApplicationForm_through_Email();
        
   		ag1.send();
        UE_send_ApplicationForm_through_Email.fake();
        System.Test.stopTest();
    }
}