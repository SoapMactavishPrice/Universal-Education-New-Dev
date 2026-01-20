@isTest
public class duplicateentryonenquiry_test {
    
    public static testmethod void duplicatetrigger() {
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
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        
        Enquiry__c ee1=new  Enquiry__c();
        ee1.Name='rajys';
        ee1.Mobile_No__c='847663262';
        //ee.Enquiry__c='';
        ee1.FirstName__c='raj';
        ee1.Last_Name__c='ys';
        ee1.Parent_Last_Name__c='xyz';
        ee1.Parent_First_Name__c='abc';
        ee1.Email__c='xyz@gmail.com';
        ee1.Contact__c=con.Id;
        
        insert  ee1;
        
        Enquiry__c ee=new  Enquiry__c();
        ee.Name='rajys';
        ee.Mobile_No__c='847663262';
        //ee.Enquiry__c='';
        ee.FirstName__c='raj';
        ee.Last_Name__c='ys';
        ee.Parent_Last_Name__c='xyz';
        ee.Parent_First_Name__c='abc';
        ee.Email__c='xyz@gmail.com';
        ee.Enquiry__c=ee1.Id;
        ee.Contact__c=con.Id;
        insert  ee; 
        test.stopTest();
        
        /*Enquiry__c e1=[select id,Name,Mobile_No__c,Enquiry__c,FirstName__c,Last_Name__c,Parent_Last_Name__c,Parent_First_Name__c,
Email__c from Enquiry__c where Id=:ee.Id ];

if(e1.Mobile_No__c==ee.Mobile_No__c && e1.FirstName__c==ee.FirstName__c && e1.Last_Name__c==ee.Last_Name__c && 
e1.Parent_First_Name__c==ee.Parent_First_Name__c && e1.Parent_Last_Name__c==ee.Parent_Last_Name__c && e1.Email__c==ee.Email__c)
e1.Enquiry__c=ee.Id; */
    }
}