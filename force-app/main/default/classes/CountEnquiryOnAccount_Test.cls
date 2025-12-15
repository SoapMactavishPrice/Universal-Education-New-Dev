@isTest
public class CountEnquiryOnAccount_Test {
     public static testmethod void counttrigger(){
          Account acc=new Account();
        	acc.Name='abc';
        	acc.Total_No_of_Enquiry_Form_Recived__c=100;
        	acc.Number_of_Application_Form_Sent__c=80;
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
         
         Enquiry__c ee=new Enquiry__c();
         ee.School_Institution__c=acc.Id;
         ee.Last_Name__c='sds';
         ee.FirstName__c= 'Test';
         ee.Contact__c=con.Id;
         insert ee;
         
         ee.City__c='kolkata';
         update ee;
       
    }
    

}