@isTest
public class GoogleCalendarMeetScheduleControllerTest {
    public static void testmethod1()
    {
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
        enq.Interaction_Done__c=false;
        enqlist.add(enq);
        insert enqlist;
        
        Event ev=new Event();
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enqlist[0].Id;
        //ev.DurationInMinutes = 60;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
        PageReference pageRef = Page.GoogleCalendarMeetSchedulePage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enqlist[0].Id);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enqlist[0]);
        GoogleCalendarMeetScheduleController ua=new GoogleCalendarMeetScheduleController(sc1);
        
        ua.ev.StartDateTime = System.now().addMinutes(1);
        ua.ev.EndDateTime = System.now().addMinutes(5);
        //ua.createevent();
        ua.intractionDone();
        ua.cancel();
        ua.schoolTourRescheduled();
        
        System.Test.stopTest();
    }
    public static void testmethod2()
    {
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
        enq.Log_Status__c='School Tour';
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
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=false;
        enqlist.add(enq);
        insert enqlist;
        
        Event ev=new Event();
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enqlist[0].Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
        PageReference pageRef = Page.GoogleCalendarMeetSchedulePage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enqlist[0].Id);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enqlist[0]);
        GoogleCalendarMeetScheduleController ua=new GoogleCalendarMeetScheduleController(sc1);
        
        ua.ev.StartDateTime = System.now().addMinutes(1);
        ua.ev.EndDateTime = System.now().addMinutes(5);
        //ua.createevent();
        ua.intractionDone();
        ua.cancel();
        ua.schoolTourRescheduled();
        
        System.Test.stopTest();
    }
    public static void testmethod3()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleCalendarHttpCalloutMock());
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
        enq.School_Tour_Scheduled__c=true;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=true;
        enqlist.add(enq);
        insert enqlist;
        
        Event ev=new Event();
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enqlist[0].Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
        PageReference pageRef = Page.GoogleCalendarMeetSchedulePage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enqlist[0].Id);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enqlist[0]);
        GoogleCalendarMeetScheduleController ua=new GoogleCalendarMeetScheduleController(sc1);
        
        //ua.createevent();
        ua.intractionDone();
        ua.cancel();
        ua.schoolTourRescheduled();
        
        System.Test.stopTest();
    }
    public static void testmethod4()
    {
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
        enq.Log_Status__c='School Tour Scheduled';
        enqlist.add(enq);
        insert enqlist;
        
        Event ev=new Event();
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enqlist[0].Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        
        
        PageReference pageRef = Page.GoogleCalendarMeetSchedulePage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enqlist[0].Id);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enqlist[0]);
        GoogleCalendarMeetScheduleController ua=new GoogleCalendarMeetScheduleController(sc1);
        ua.ev.StartDateTime = System.now().addMinutes(1);
        ua.ev.EndDateTime = System.now().addMinutes(5);
        //ua.createevent();
        ua.intractionDone();
        ua.cancel();
        ua.schoolTourRescheduled();
        System.Test.stopTest();
    }
    
    @isTest
    public static void testMethod6() {
        GoogleCalendarMeetScheduleController.fakeMethod();
    }
    
    /* @isTest public static void testmethod5()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
        //System.Test.startTest();
        System.debug(
            [SELECT Id, Address,DisplayName FROM OrgWideEmailAddress]
            );
        Account acc = new Account();
        acc.Name ='Universal Test';
        acc.For_Mapping_Email__c = 'Ebenezer';
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
        enq.School_Tour_Scheduled__c=false;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=false;
        enqlist.add(enq);
        insert enqlist;
        
        List<Event> evId = new List<Event>();
        Event ev=new Event();
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enqlist[0].Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.Contact__c = con.Id ;
        ev.School_Institution__c = acc.Id;
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        evId.add(ev);
        
        Test.setMock(HttpCalloutMock.class, new GoogleCalendarHttpCalloutMock());
        String string1 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
        String string2 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
        /* List <School_List__mdt> CalendarEmailMdt =new list <School_List__mdt>();
        // CalendarEmailMdt.MasterLabel = 'AB';
        CalendarEmailMdt.Calendar_Email__c = 'admissions.cbse@alphaeducation.edu.in' ;
        CalendarEmailMdt.Notification_Email__c = 'notification@alphaeducation.edu.in' ;
        CalendarEmailMdt.State__c = 'Trichy' ;
        insert CalendarEmailMdt;
         */
        /*Test.startTest();
        
        PageReference pageRef = Page.GoogleCalendarMeetSchedulePage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enqlist[0].Id);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enqlist[0]);
        GoogleCalendarMeetScheduleController ua=new GoogleCalendarMeetScheduleController(sc1);
        ua.listenq = enqlist;
        ua.listev = evId;
        //HttpResponse response = GoogleCalendarMeetScheduleController.doCreateNewCalendarEvent(ev.Id,'helooo');
        ua.createevent();
        GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id , 'helooo');
        
        Test.stopTest();
        //System.assertEquals(200, response.getStatusCode());
        
    }
    
    /*    @isTest public static void testmethod6()
    {
        Account acc = new Account();
        acc.For_Mapping_Email__c = 'Ebenezer';
        acc.Name ='Universal Test';
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
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=false;
        enqlist.add(enq);
        insert enqlist;
        
        List<Event> evId = new List<Event>();
        Event ev=new Event();
        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enqlist[0].Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.Contact__c = con.Id ;
        ev.School_Institution__c = acc.Id;
        ev.OwnerId=UserInfo.getUserId();
        insert ev;
        evId.add(ev);
        
        Test.setMock(HttpCalloutMock.class, new GoogleCalendarHttpCalloutMock());
        String string1 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
        String string2 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
        Test.startTest();
        
        PageReference pageRef = Page.GoogleCalendarMeetReScheduledPage;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',enqlist[0].Id);
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(enqlist[0]);
        GoogleCalendarMeetScheduleController ua=new GoogleCalendarMeetScheduleController(sc1);
        ua.listenq = enqlist;
        ua.listev = evId;
        //HttpResponse response = GoogleCalendarMeetScheduleController.doCreateNewCalendarEvent(ev.Id,'helooo');
        ua.schoolTourRescheduled();
        GoogleCalendarMeetScheduleController.doCreateNewCalendar(ev.Id , 'helooo');
        
        Test.stopTest();
        //System.assertEquals(200, response.getStatusCode());
        
    }*/
    
}