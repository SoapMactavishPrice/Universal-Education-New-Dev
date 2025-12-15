@isTest
public class Test_commonCalss {
    @testSetup static void setup()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account acc = new Account();
        acc.For_Mapping_Email__c = 'Ebenezer';
        acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHSC';
        insert acc;

        Account nAccount = [SELECT Id, Name, Website, School_Short_Code__c, School_Email__c FROM Account limit 1];
        Lead nLead = new Lead();
        //nLead.Acadmic_Year__c = '2022-2023';
        nLead.Company = 'Test';
        nLead.LastName = 'Mr. Jenn jenny';
        nLead.Stage__c = 'New';
        nLead.Reasons__c = 'Not Applicable';
        nLead.School_Institution__c = nAccount.id;
        //nLead.School_Short_Code__c = 'UHSC';
        //insert nLead;

        List<Id> conListId= new List<Id>();

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;

        String ConID= con.Id;


        conListId.add(con.Id);



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
        enq.Application_Sent__c=false;
        enq.School_Tour_Scheduled__c=false;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=true;
        enqlist.add(enq);
        insert enqlist;

        smsgupshupTemplate__c sms = new smsgupshupTemplate__c();
        sms.Name__c = 'OTP';
        sms.Description__c = 'Your OTP for using the Universal Admission Enquiry System is %code%';
        insert sms;
    }
    @isTest 
    public static void TestScheduleCampusVisitController()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        //Lead nlead = [select Id,LastName from Lead limit 1];
        Test.startTest();
        con.Stages__c ='Application submitted';
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        ScheduleCampusVisitController nScheduleCampusVisitController = new ScheduleCampusVisitController(sc);
        nScheduleCampusVisitController.redirectMe();
        //nScheduleCampusVisitController.updateleads(nlead.Id);
        test.stopTest();
    }
    @isTest 
    public static void TestScheduleVideoCallCtrl()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        //Lead nlead = [select Id,LastName from Lead limit 1];
        Test.startTest();
        con.Stages__c ='Application submitted';
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        ScheduleVideoCallCtrl nScheduleVideoCallCtrl = new ScheduleVideoCallCtrl(sc);
        nScheduleVideoCallCtrl.redirectMe();
        //nScheduleCampusVisitController.updateleads(nlead.Id);
        test.stopTest();
    }
    @isTest 
    public static void TestReScheduleVideoCallCtrl()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        //Lead nlead = [select Id,LastName from Lead limit 1];
        Test.startTest();
        con.Stages__c ='Application submitted';
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        ReScheduleVideoCallCtrl nReScheduleVideoCallCtrl = new ReScheduleVideoCallCtrl(sc);
        nReScheduleVideoCallCtrl.ReScheduleVideoCal();
        //nScheduleCampusVisitController.updateleads(nlead.Id);
        test.stopTest();
    }
    @isTest 
    public static void TestSchoolTourControllerCon0()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        Test.startTest();
        con.Campus_Visit_Scheduled__c=false;
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        SchoolTourControllerCon nSchoolTourControllerCon = new SchoolTourControllerCon(sc);
        nSchoolTourControllerCon.createevent();
        test.stopTest();
    }
    @isTest 
    public static void TestSchoolTourControllerCon1()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        Test.startTest();
        con.Campus_Visit_Scheduled__c=true;
        con.Meeting_Done__c = false;
        con.Re_Scheduled_Campus_Visit__c=true;
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        SchoolTourControllerCon nSchoolTourControllerCon = new SchoolTourControllerCon(sc);
        nSchoolTourControllerCon.schoolTourRescheduled();
        test.stopTest();
    }
     @isTest 
    public static void TestSchoolTourControllerCon2()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        Test.startTest();
        con.Campus_Visit_Scheduled__c=true;
        con.Meeting_Done__c = false;
        con.Re_Scheduled_Campus_Visit__c=false;
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        SchoolTourControllerCon nSchoolTourControllerCon = new SchoolTourControllerCon(sc);
        nSchoolTourControllerCon.intractionDone();
        test.stopTest();
    }
     @isTest 
    public static void TestSchoolTourControllerCon3()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        Test.startTest();
        con.Campus_Visit_Scheduled__c=true;
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        SchoolTourControllerCon nSchoolTourControllerCon = new SchoolTourControllerCon(sc);
        nSchoolTourControllerCon.noShowCheck();
        nSchoolTourControllerCon.cancel();
        test.stopTest();
    }
     @isTest 
    public static void TestSchoolTourControllerCon4()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        Test.startTest();
        con.Stages__c = 'Meet Done';
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        SchoolTourControllerCon nSchoolTourControllerCon = new SchoolTourControllerCon(sc);
        nSchoolTourControllerCon.noHoldEnq();
        test.stopTest();
    }
     @isTest 
    public static void TestSchoolTourControllerCon5()
    {
        contact con = [select Id,FirstName from Contact where FirstName='Test_First_name' limit 1];
        Test.startTest();
        con.Stages__c = 'Meet Done';
        con.Meeting_Done__c=true;
        Update con;
        ApexPages.CurrentPage().getparameters().put('id', con.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        SchoolTourControllerCon nSchoolTourControllerCon = new SchoolTourControllerCon(sc);
        nSchoolTourControllerCon.enqInterested();
        test.stopTest();
    }
}