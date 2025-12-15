@isTest
public class Techno_LeadconvertTest {
    public static testmethod void leadtest(){
       
        Account acc=new Account();
        acc.Name='xyz';
        
        insert acc;
        
         id leadids=Apexpages.currentPage().getparameters().get('id'); 
        lead ld=new lead();
        ld.LastName='bc';
        ld.FirstName='yx';
        ld.LeadSource='website';
        ld.Status='unqualified';
        ld.MobilePhone='98765432';
        ld.Phone='752555667';
        ld.School_Institution__c=acc.Id;
        ld.Stellar_Seeking_Admission_in_Grade__c='Nursery';
        ld.Converted__c=false;
        ld.Email='dd@gmail.com';
        ld.Company='vs';
        ld.Reasons__c = 'Others';
        insert ld;
      
        Contact con = new Contact();  
            con.LastName=ld.Name;
            con.Email=ld.Email;
            con.MobilePhone=ld.MobilePhone;
            con.AccountId = ld.School_Institution__c;
            con.Phone = ld.Phone;
           // con.Type__c ='Admission Enquiry';
            //az.add() ;
         PageReference pageRef = Page.LeadConvert;
          Test.setCurrentPage(pageRef);
          Apexpages.currentpage().getparameters().put('id',ld.Id);
        
         ApexPages.StandardController sc = new ApexPages.StandardController(ld);
         Techno_Leadconvert az=new Techno_Leadconvert(sc);
         az.createContact();
        ld.Status='qualified';
        ld.Converted__c=true;
        update ld;
        
    }

}