@isTest	
public class CountAdmissionGrantedOnAccountTest {
    @isTest public static void CountAdmissionGrantedOn(){
           Account a1=new Account();
        a1.Name='name';
        a1.Total_number_of_Contacts__c=10;
        a1.Total_No_of_Enquiry_Form_Recived__c=9;
        a1.Total_No_of_Application_Form_Received__c=11;
        a1.School_Email__c='abc@gmail.com';
        a1.Type='Partner';
        insert a1;
        
        Admission_Granted__c ag=new Admission_Granted__c();
        ag.Last_Name__c='asc';
        ag.School_Institution__c=a1.Id;
        insert ag;
        ag.Adhaar_Card_No__c='123434545432';
        update ag;
    }
}