@istest
public class InteractionOnlineCtrl_Test {
	@testSetup
    static void DataFactory(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
        Account acc = new Account();
        acc.For_Mapping_Email__c = 'Ebenezer';
        acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHSC';
        insert acc;
		
        Lead nLead = new Lead();
        //nLead.Acadmic_Year__c = '2022-2023';
        nLead.Company = 'Test';
        nLead.LastName = 'Mr. Jenn jenny';
        nLead.Stage__c = 'New';
        nLead.Reasons__c = 'Not Applicable';
        nLead.School_Institution__c = acc.id;
       // insert nLead;
        
        List<Id> conListId= new List<Id>();

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
       	con.Lead_ID__c=nLead.id;
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

    }
    
    @isTest
    static void InteractionOnlineController(){
        try
        {
        Enquiry__c Enquiry = [select Id,FirstName__c,Email__c from Enquiry__c limit 1];
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', Enquiry.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Enquiry);
        CalledForInteractionOnlineController nCalledForInteractionController = new CalledForInteractionOnlineController(sc);
       CalledForInteractionOnlineController.FormFactory();
        nCalledForInteractionController.CalledForInteraction();
        nCalledForInteractionController.alreadytourscheduled();
        nCalledForInteractionController.InteractionOnlineRescheduled();
        nCalledForInteractionController.IntractionDoneEnquiry();
       // nCalledForInteractionController.IntractionDoneEnquiry
        nCalledForInteractionController.cancel();
        test.stopTest();
        }
        catch(exception w)
        {
            
        }
    } 
}