@isTest
public class AdmissiGrantTriggerHandlerTest {

    private static Id leadId;
    private static String leadAutoNumber;

    @testSetup
    static void setupData() {
        // Create a Lead record
        Lead ld = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Current_Status__c = 'Won'
        );
        insert ld;

        leadId = ld.Id;

        // Fetch the auto-generated Lead_ID__c
        ld = [SELECT Lead_ID__c FROM Lead WHERE Id = :leadId LIMIT 1];
        leadAutoNumber = ld.Lead_ID__c;

        // Create Admission_Granted__c with required Lead__c
        Admission_Granted__c adm = new Admission_Granted__c(
            Name = 'Test Admission',
            Status__c = 'New',
            Lead__c = leadId
        );
        insert adm;
    }

    @isTest
    static void testUpdateCurrentStatus() {
        List<Admission_Granted__c> admissionList = [
            SELECT Id, Status__c, Lead_ID__c FROM Admission_Granted__c LIMIT 1
        ];

        System.assert(!admissionList.isEmpty(), 'No Admission_Granted__c records found');

        Admission_Granted__c adm = admissionList[0];
        adm.Status__c = 'Dormant';
        update adm;

        RecursiveTriComCurrStatusHandler.isFirstTime = true;

        Test.startTest();
        AdmissiGrantTriggerHandler.updateCurrentStatus(admissionList);
        Test.stopTest();

        List<Lead> leadList = [SELECT Current_Status__c FROM Lead WHERE Id = :leadId LIMIT 1];
        
    }

    @isTest
    static void testNoUpdateWhenNotDormant() {
        List<Admission_Granted__c> admissionList = [
            SELECT Id, Status__c, Lead_ID__c FROM Admission_Granted__c LIMIT 1
        ];

        System.assert(!admissionList.isEmpty(), 'No Admission_Granted__c records found');

        Admission_Granted__c adm = admissionList[0];
        adm.Status__c = 'New';
        update adm;

        RecursiveTriComCurrStatusHandler.isFirstTime = true;

        Test.startTest();
        AdmissiGrantTriggerHandler.updateCurrentStatus(admissionList);
        Test.stopTest();

        List<Lead> leadList = [SELECT Current_Status__c FROM Lead WHERE Id = :leadId LIMIT 1];
      
    }
}