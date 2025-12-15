@isTest
public class smsgupshupTemplateControllerTest {

    Static testmethod void SMSgupshup(){
        
        smsgupshupTemplate__c sm = new smsgupshupTemplate__c();
        sm.Description__c = 'tetst description';
       	sm.Name__c='test name';
        insert sm;
        
       ApexPages.StandardController sc = new ApexPages.StandardController(sm);
        PageReference myVfPage = Page.smsgupshupTemplate;
		Test.setCurrentPage(myVfPage);
       smsgupshupTemplateController uf= new smsgupshupTemplateController(sc);
       
       uf.Save();
        
    }
   
}