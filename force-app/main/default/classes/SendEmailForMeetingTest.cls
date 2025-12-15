@isTest
public class SendEmailForMeetingTest {
   @isTest public static void testmethod1()
    {
System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        Contact con = new Contact();
        User u;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        Enquiry__c enq = new Enquiry__c();
        Event ev=new Event();
        Lead lead = new Lead(Email = 'test@gmail.com', LastName = 'test', Company = 'test');

        System.runAs (thisUser) {
            INSERT lead;
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
            acc.For_Mapping_Email__c = 'Ebenezer';
            acc.Name ='Universal Test';
            acc.Website = 'www.addfd.com';
            acc.BillingStreet = 'ss';
            acc.BillingState = 'Maha';
            acc.BillingCity = 'dd';
            acc.BillingCountry = 'India';
            acc.BillingPostalCode = '22222222';
            insert acc;

            con.FirstName = 'Test_First_name';
            con.Lead__c = lead.Id;
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
        enq.Lead__c = lead.Id;
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
        insert enq;

        ev.Description='abcdefg';
        ev.Subject='Call';
        ev.WhatId=enq.Id;
        ev.StartDateTime=system.now();
        ev.EndDateTime=system.now();
        ev.OwnerId=UserInfo.getUserId();
        ev.School_Institution__c = acc.Id;
        ev.Contact__c = con.Id;
        insert ev;
        }
        //SELECT Id, DeveloperName, FolderId, FolderName, IsActive, Body, HtmlValue, Subject FROM EmailTemplate
        EmailTemplate e = new EmailTemplate (developerName = 'test', TemplateType= 'Text', FolderId = UserInfo.getUserId(),Name = 'test',
                                             Subject = 'TestSubject',Body= 'Hello Email Template',IsActive = true);
        OrgWideEmailAddress[] addresses = [SELECT Id, Address,DisplayName from OrgWideEmailAddress];
        test.startTest();
        insert e;
        System.debug('-=-=-'+e);
        List<String> emailIds = new List<String>{con.Email};
        SendEmailForMeeting.sendEmailMeetingToParent(emailIds,ev.Id,enq.Pin_Code__c,'test');
        test.stopTest();
    }

}