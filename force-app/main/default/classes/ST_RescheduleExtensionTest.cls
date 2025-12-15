@isTest
public class ST_RescheduleExtensionTest {
    @isTest public static void testreschedulephonecall()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account acc = new Account();
        acc.For_Mapping_Email__c = 'Ebenezer';
        
        acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHSC';
        
        insert acc;
        
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
        test.startTest();
        Apexpages.currentpage().getparameters().put('id',con.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(con);
        
        ST_RescheduleExtension r = new ST_RescheduleExtension(sc1);
        r.redirectToReschedule();
        test.stopTest();
        
    }
}