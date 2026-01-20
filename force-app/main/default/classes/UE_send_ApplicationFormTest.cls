@isTest
public class UE_send_ApplicationFormTest {
    @isTest
    public static void aftestmethod(){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
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
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
        Enquiry__c eq=new Enquiry__c(Mobile_No__c='1234567890',Name='test',Email__c='test@gmail.com',Stages__c='Application Under Review',Application_Sent__c=FALSE,Interaction_Done__c=TRUE,Application_Received__c=TRUE,Contact__c=con.Id);
        insert eq;
        PageReference pageRef = Page.UE_sendApplication;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(eq.Id));
        UE_send_ApplicationForm_through_Email temp= new UE_send_ApplicationForm_through_Email();
        temp.send();
        temp.cancel();
        eq.Stages__c='Application submitted';
        //update eq
        //eq.Stages__c='Application (Rejected)';
        //update eq;
        eq.Application_Sent__c=FALSE;
        eq.Interaction_Done__c=FALSE;
        eq.Application_Received__c=FALSE;
        update eq;
        temp.send();
        temp.cancel();
        eq.Stages__c='Application (Rejected)';
        eq.Email__c=null;
        update eq;
        temp.send();
        temp.cancel();
        eq.Stages__c='Application Link Sent';
        eq.Application_Sent__c=FALSE;
        update eq;
        temp.send();
        temp.cancel();
        
        
    }
    /* @isTest
public static void aftestmethod2(){
UE_send_ApplicationForm_through_Email temp1= new UE_send_ApplicationForm_through_Email();
temp1.send();
temp1.cancel();
}*/
    
    @isTest
    public static void aftestmethod2(){
        
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
        
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
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
        Enquiry__c eq=new Enquiry__c(Mobile_No__c='1234567890',Name='test',Email__c='test@gmail.com',Stages__c='Application Under Review',Application_Sent__c=FALSE,Interaction_Done__c=TRUE,Application_Received__c=TRUE,Contact__c=con.Id);
        insert eq;
        PageReference pageRef = Page.UE_sendApplication;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(eq.Id));
        UE_send_ApplicationForm_through_Email temp= new UE_send_ApplicationForm_through_Email();
        temp.send();
        temp.cancel();
        eq.Stages__c='Interested';
        //update eq
        //eq.Stages__c='Application (Rejected)';
        //update eq;
        eq.Application_Sent__c=true;
        eq.Interaction_Done__c=true;
        eq.Application_Received__c=true;
        eq.Interested__c = true;
        update eq;
        temp.send();
        temp.cancel();
        eq.Stages__c='Meet Done';
        eq.Email__c='test@email.com';
        update eq;
        temp.send();
        temp.cancel();
        eq.Stages__c='Application Link Sent';
        eq.Application_Sent__c=FALSE;
        update eq;
        temp.send();
        temp.cancel();
    }
}