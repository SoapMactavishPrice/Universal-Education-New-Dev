@isTest public class NewEventControllerTest {
     public static testmethod void testmethod1()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
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
        enqlist.add(enq);
        insert enqlist;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Enquiry__c = enq.Id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Date_of_Birth__c = date.valueOf('2000-02-04');
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
      af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Application_Form_Declaration__c = true;
        insert af1;
        
        Admission_Form__c ad=new Admission_Form__c();
        ad.Registration_No__c = '2021-2022/REG/1';
        ad.Application_Form__c = af1.Id;
        ad.Enquiry_No__c = enq.Id;
		ad.Observation_Done__c = false;
        ad.Called_for_Observation__c=false;
        ad.School_Institution__c=acc.Id;
        ad.Application_Form__c = af1.Id;
        insert ad;
                       
        Event ev=new Event();        
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=ad.Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
      /*ad.Called_for_Observation__c = true;
        ad.Status__c = 'Called for Observation';
        update ad;*/
        
        PageReference pageRef = Page.AddEvent;
         Test.setCurrentPage(pageRef);
          Apexpages.currentpage().getparameters().put('id',ad.Id);

         ApexPages.StandardController sc1 = new ApexPages.StandardController(ev);
         NewEventController ua=new NewEventController(sc1);
         ua.ev.StartDateTime = system.now();
         ua.ev.EndDateTime = system.now();
         ua.createevent();
         ua.alreadycalledforobservation();
         ua.cancel();  
    }
    

    public static testmethod void testmethod2()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account acc=new Account();
        acc.Name='Test';
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
        enqlist.add(enq);
        insert enqlist;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Enquiry__c = enq.Id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Date_of_Birth__c = date.valueOf('2000-02-04');
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Application_Form_Declaration__c = true;
        insert af1;
        
        Admission_Form__c ad=new Admission_Form__c();
        ad.Registration_No__c = '2021-2022/REG/1';
        ad.Enquiry_No__c = enq.Id;
        ad.Called_for_Observation__c=false;
        ad.Observation_Done__c = false;
        ad.School_Institution__c=acc.Id;
        ad.Application_Form__c = af1.Id;
        insert ad;
        
	/*d.Called_for_Observation__c= true
        ad.Status__c='Called for Observation';
      //ad.Observation_Re_scheduled__c=True;
        update ad;  */
       
        Event ev=new Event();        
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=ad.Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
                       
         PageReference pageRef = Page.AddEvent;
         Test.setCurrentPage(pageRef);
          Apexpages.currentpage().getparameters().put('id',ad.Id);
        
         ApexPages.StandardController sc1 = new ApexPages.StandardController(ev);
         NewEventController ua=new NewEventController(sc1);
         ua.ev.StartDateTime = system.now();
         ua.ev.EndDateTime = system.now();
         ua.observationOnline();
         ua.alreadycalledforobservation();
         ua.cancel(); 
        
    }   
     public static testmethod void testmethod3()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
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
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='School Tour Scheduled';
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
        enq.School_Tour_Scheduled__c=true;
        enq.School_Tour_Re_Scheduled__c=true;
        enq.Interaction_Done__c=false;
        enqlist.add(enq);
        insert enqlist;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Enquiry__c = enq.Id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Date_of_Birth__c = date.valueOf('2000-02-04');
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
      af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Application_Form_Declaration__c = true;
        insert af1;
        
        Admission_Form__c ad=new Admission_Form__c();
        ad.Registration_No__c = '2021-2022/REG/1';
        ad.Application_Form__c = af1.Id;
        ad.Enquiry_No__c = enq.Id;
        ad.Observation_Done__c = false;
        ad.Called_for_Observation__c=true;
        ad.School_Institution__c=acc.Id;
        ad.Application_Form__c = af1.Id;
        insert ad;
                       
        Event ev=new Event();        
        ev.Description='abcdefg';
        ev.Contact__c = enq.Contact__c;
        ev.Enquiry_Email__c = enq.Email__c;
        ev.Subject='Call';
        ev.WhatId=ad.Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
      /*ad.Called_for_Observation__c = true;
        ad.Status__c = 'Called for Observation';
        update ad;*/
             Test.setMock(HttpCalloutMock.class, new GoogleCalendarHttpCalloutMock());
        String string1 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
        String string2 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
        
        PageReference pageRef = Page.AddEvent;
         Test.setCurrentPage(pageRef);
          Apexpages.currentpage().getparameters().put('id',ad.Id);

         ApexPages.StandardController sc1 = new ApexPages.StandardController(ev);
         NewEventController ua=new NewEventController(sc1);
         ua.ev.StartDateTime = system.now();
         ua.ev.EndDateTime = system.now();
         ua.ObservationOnlineRescheduled();
         ua.scheduleobservationfirst();
         ua.cancel();  
    }
		  public static testmethod void testmethod5()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
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
        enqlist.add(enq);
        insert enqlist;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Enquiry__c = enq.Id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Date_of_Birth__c = date.valueOf('2000-02-04');
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
      af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Application_Form_Declaration__c = true;
        insert af1;
        
        Admission_Form__c ad=new Admission_Form__c();
        ad.Registration_No__c = '2021-2022/REG/1';
        ad.Application_Form__c = af1.Id;
        ad.Enquiry_No__c = enq.Id;
        ad.Observation_Done__c = true;
        ad.Called_for_Observation__c=false;
        ad.School_Institution__c=acc.Id;
        ad.Application_Form__c = af1.Id;
        insert ad;
                       
        Event ev=new Event();        
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=ad.Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
      /*ad.Called_for_Observation__c = true;
        ad.Status__c = 'Called for Observation';
        update ad;*/
        
        PageReference pageRef = Page.AddEvent;
         Test.setCurrentPage(pageRef);
          Apexpages.currentpage().getparameters().put('id',ad.Id);

         ApexPages.StandardController sc1 = new ApexPages.StandardController(ev);
         NewEventController ua=new NewEventController(sc1);
         ua.ev.StartDateTime = system.now();
         ua.ev.EndDateTime = system.now();
         ua.ObservationRescheduled();
         ua.scheduleobservationfirst();
         ua.alreadycalledforobservation();
         ua.cancel();  
    }
    
    	  public static testmethod void testmethod4()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
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
        enqlist.add(enq);
        insert enqlist;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Enquiry__c = enq.Id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Date_of_Birth__c = date.valueOf('2000-02-04');
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
       af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Application_Form_Declaration__c = true;
        insert af1;
        
        Admission_Form__c ad=new Admission_Form__c();
        ad.Registration_No__c = '2021-2022/REG/1';
        ad.Application_Form__c = af1.Id;
        ad.Enquiry_No__c = enq.Id;
        ad.Observation_Done__c = false;
        ad.Called_for_Observation__c=true;
        ad.School_Institution__c=acc.Id;
        ad.Application_Form__c = af1.Id;
        insert ad;
                       
        Event ev=new Event();        
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=ad.Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
      /*ad.Called_for_Observation__c = true;
        ad.Status__c = 'Called for Observation';
        update ad;*/
        
        PageReference pageRef = Page.AddEvent;
         Test.setCurrentPage(pageRef);
          Apexpages.currentpage().getparameters().put('id',ad.Id);

         ApexPages.StandardController sc1 = new ApexPages.StandardController(ev);
         NewEventController ua=new NewEventController(sc1);
         ua.ev.StartDateTime = system.now();
         ua.ev.EndDateTime = system.now();
         ua.createevent();
         ua.observationOnline();
         ua.ObservationOnlineRescheduled();
         ua.ObservationRescheduled();
         ua.alreadycalledforobservation();
         ua.scheduleobservationfirst();
         ua.cancel();  
    }
     public static testmethod void testmethod6()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account acc=new Account();
        acc.Name='Test';
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
        enqlist.add(enq);
        insert enqlist;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Enquiry__c = enq.Id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Date_of_Birth__c = date.valueOf('2000-02-04');
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
       af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Application_Form_Declaration__c = true;
        insert af1;
        
        Admission_Form__c ad=new Admission_Form__c();
        ad.Registration_No__c = '2021-2022/REG/1';
        ad.Application_Form__c = af1.Id;
        ad.Enquiry_No__c = enq.Id;
        ad.Called_for_Observation__c=false;
        ad.Observation_Re_scheduled__c=false;
        ad.School_Institution__c=acc.Id;
        ad.Application_Form__c = af1.Id;
        insert ad;
                       
        Event ev=new Event();        
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=ad.Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
      /*ad.Called_for_Observation__c = true;
        ad.Status__c = 'Called for Observation';
        update ad;*/
        
         PageReference pageRef = Page.AddEvent;
         Test.setCurrentPage(pageRef);
         Apexpages.currentpage().getparameters().put('id',ad.Id);
        
         ApexPages.StandardController sc1 = new ApexPages.StandardController(ev);
         NewEventController ua=new NewEventController(sc1);
         ua.ev.StartDateTime = system.now();
         ua.ev.EndDateTime = system.now();
         ua.createevent();
         ua.observationOnline();
         ua.ObservationOnlineRescheduled();
         ua.ObservationRescheduled();
         NewEventController.fakeMethod();
         ua.cancel();  
    }
}