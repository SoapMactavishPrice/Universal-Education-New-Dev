/**
* Trigger      : DisclosureTrigger
* Classes      : DisclosureTriggerHandellerCtrl,Test_DisclosureTriggerHandellerCtrl
* Devloper     : Rajesh Kumar
* Created Date : 30/12/2021
*/
@IsTest
public class Test_DisclosureTriggerHandellerCtrl {
    public static Testmethod void Uase_Case1(){
        Account acc = new Account();
        acc.Name ='Stellar World School (Bandra)';
        acc.School_Short_Code__c='STELRB';
        insert acc;
        
        Class__c cls = new Class__c();
        cls.Name = 'Grade 1';
        cls.School_Name__c = acc.Id;
        cls.School_Name_on_PDF__c = 'Stellar World School';
        cls.Original_Class__c = 'Grade 1';
        insert cls;
        
        Document sobj = new Document(
            Name = 'Test_DisclosureTriggerHandellerCtrl',        
            DeveloperName = 'Test_DisclosureTriggerHandellerCtrl',  
            IsInternalUseOnly = false,    
            FolderId = [SELECT Id, ParentId, Name, DeveloperName, IsReadonly, Type FROM Folder where DeveloperName='SharedDocuments' and Type ='Document'].id,                        
            ContentType = 'image/jpeg',     
            Description = 'Test_DisclosureTriggerHandellerCtrl',    
            Keywords = 'Test_DisclosureTriggerHandellerCtrl'      
        );
        insert sobj;
        Document documentObj;
        
        documentObj = new Document();
        documentObj.Body = Blob.valueOf('Some Document Text');
        documentObj.ContentType = 'application/pdf';
        documentObj.DeveloperName = 'my_document';
        documentObj.IsPublic = true;
        documentObj.Name = 'My Document';
        documentObj.FolderId = [select id from folder where name = 'Shared Documents'].id;
        insert documentObj;
        
        Disclosure__c disclosure = new Disclosure__c();
        disclosure.Name = 'Form C1';
        disclosure.Description__c = 'Form C1';
        disclosure.School__c = acc.Id;
        disclosure.Class__c = cls.Id;
        disclosure.Academic_Year__c = '2022-2023';
        
        disclosure.School_Institution_Logo_URL__c= 'https://universaleducation--xabit--c.documentforce.com/servlet/servlet.FileDownload?file='+documentObj.id;
        Insert disclosure;
        system.assertEquals(disclosure.Name, 'Form C1', 'Both the values should  same.');
        
        Test.startTest();
        DisclosureTriggerHandellerCtrl nDisclosureTriggerHandellerCtrl = new DisclosureTriggerHandellerCtrl();
        Test.stopTest();
    }
}