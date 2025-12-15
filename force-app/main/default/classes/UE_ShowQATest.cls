@isTest
public class UE_ShowQATest {
    
    static testMethod void showQA(){
        FAQs__c fq = new FAQs__c();
        fq.FAQ_Link__c = 'www.google.com';
        insert fq;
       
        Q_A__c qa = new Q_A__c();
        qa.FAQ__c = fq.Id;
        qa.Questions__c = 'test_question';
        qa.Answer__c = 'Test_answer';
        insert qa; 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(qa);
        UE_ShowQA sw= new UE_ShowQA(sc);
        sw.search();
        sw.searchfaq ='test';
        sw.show1=true;

    }

}