@isTest
public class UE_CtrAddQuesAnswerTest {

    static testMethod void UE_CtrEnquiryFormTest() {
    
           

 List <Q_A__c> listQ = new List<Q_A__c>();
 
  Q_A__c qa = new Q_A__c();
 qa.Questions__c = 'test_question';
        
 listQ.add(qa);
 Q_A__c qa1 = new Q_A__c();
 qa1.Questions__c='Test Account1' ;
 listQ.add(qa1);

 insert  listQ;
 
 Test.startTest();
  Test.setCurrentPage(Page.UE_AddQuesAnswer);
  ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listQ);
  stdSetController.setSelected(listQ);
  UE_CtrAddQuesAnswer ext = new UE_CtrAddQuesAnswer(stdSetController);
        ext.addrow();
        ext.delRow();
        
        ext.save();
        ext.cancel();
 Test.stopTest();
 }
}