@isTest public class UE_ShowEnq_NumberTest {
	
    @isTest public static void testmethod1(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Ebenezer International School Nashik';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
       
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
    }
    
     @isTest public static void testmethod2(){
         
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         
        Account acc = new Account();
        acc.Name ='St. John'+'\''+'s Universal School';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
    }
    
    @isTest public static void testmethod3(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Ebenezer International School Bangalore';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
    }
    
     @isTest public static void testmethod4(){
         
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         
        Account acc = new Account();
        acc.Name ='Silver Oak Universal School';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
    }
    
     @isTest public static void testmethod5(){
         
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         
        Account acc = new Account();
        acc.Name ='Primus Public School';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
    }
    
     @isTest public static void testmethod6(){
         
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         
        Account acc = new Account();
        acc.Name ='Alpha Plus Matriculation';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
    }
    
    @isTest public static void testmethod7(){
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Account acc = new Account();
        acc.Name ='Alpha Cambridge School (IGCSE)';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
    }
    
     @isTest public static void testmethod8(){
         
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         
        Account acc = new Account();
        acc.Name ='Alpha Wisdom Vidyashram (CBSE)';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@gmail.com';
    	con.Type__c='Admission Enquiry';
    	insert con;
        
        //List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
       	enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        
        //enqlist.add(enq);
   		insert enq;
   		
        
        
        PageReference pageRef = Page.ShowEnquiryNumber;
		Test.setCurrentPage(pageRef);
		Apexpages.currentpage().getparameters().put('eid',enq.Id);
		ApexPages.StandardController sc1 = new ApexPages.StandardController(enq);
		UE_ShowEnq_Number ag1= new UE_ShowEnq_Number(sc1);
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