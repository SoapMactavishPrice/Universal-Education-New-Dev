@isTest
public with sharing class SMSHistoryShareTriggerHandlerTest {

    static testmethod void test1(){
    
    Account ac = new Account();
    ac.name ='TestABC';
    ac.School_Short_Code__c='1234';
    ac.School_Email__c='abc@gmail.com';
    ac.Website='test.com';
    insert ac;
    
    Lead ld = new Lead();
    
    ld.lastname='Test';
    ld.company='360DC';
    ld.MobilePhone='123456789';
    ld.School_Short_Code__c='1234';
    ld.School_Institution__c=ac.id;
    
    insert ld;
    
    Lead ld1 = new Lead();
    
    ld1.lastname='Test';
    ld1.company='360DC';
    ld1.MobilePhone='123456789';
    ld1.School_Short_Code__c='1234';
    ld1.School_Institution__c=id.valueOf(ac.id);
    
    insert ld1;
    

    SchoolIdAndGroupId__c sch = new SchoolIdAndGroupId__c();
        sch.Name=ac.id;
        sch.GroupId__c=UserInfo.getUserId();
        sch.GroupName__c='Alpha Education';
        sch.School_Name__c='Alpha Beginnings';
           insert   sch;
    tdc_tsw__message__c obj = new tdc_tsw__message__c();
    
    obj.name ='Incoming';
        obj.tdc_tsw__Related_Object__c ='Lead';
        obj.tdc_tsw__Message_Text_New__c ='Test Message By 360';
        obj.tdc_tsw__Sender_Number__c ='447862125715';
        obj.tdc_tsw__ToNumber__c ='+918289046406';
        obj.tdc_tsw__lead__c=ld.id;
     //   lstMsg.add(obj);
         insert obj;
    
      tdc_tsw__message__c obj1 = new tdc_tsw__message__c();
    
    obj1.name ='Incoming';
        obj1.tdc_tsw__Related_Object__c ='Lead';
        obj1.tdc_tsw__Message_Text_New__c ='Test Message By 360';
        obj1.tdc_tsw__Sender_Number__c ='447862125715';
        obj1.tdc_tsw__ToNumber__c ='+918289046406';
        obj1.tdc_tsw__lead__c=ld1.id;
     //   lstMsg.add(obj);
         insert obj1;
    
    }

}