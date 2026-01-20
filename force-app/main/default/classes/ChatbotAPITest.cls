@isTest
private class ChatbotAPITest {
    
    @testSetup
    static void setup() {
        Id qualifiedRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Qualified').getRecordTypeId();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User testUser = new User(
            Alias = 'tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser' + System.currentTimeMillis() + '@example.com'
        );
        insert testUser;
        
        Account testAccount = new Account();
        testAccount.Name = 'Test School';
        testAccount.School_Short_Code__c = 'STELRA';
        insert testAccount;

        Account testAccount2 = new Account();
        testAccount2.Name = 'Test School B';
        testAccount2.School_Short_Code__c = 'STELRB';
        insert testAccount2;
        
        LeadUser__c leadUser = new LeadUser__c();
        leadUser.Name = 'Test User';
        leadUser.SchoolCode__c = 'STELRA';
        insert leadUser;
        
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.DuplicateRuleHeader.allowSave = true;
        dmlOpts.DuplicateRuleHeader.runAsCurrentUser = false;

        Lead testLead = new Lead();
        testLead.FirstName = 'Test';
        testLead.LastName = 'Lead';
        testLead.MobilePhone = '1234567890';
        testLead.Company = 'Chatbot Lead';
        testLead.RecordTypeId = qualifiedRecordTypeId;
        testLead.School_Short_Code__c = 'STELRB';
        testLead.Acadmic_Year__c = '2026-2027';
        testLead.setOptions(dmlOpts);
        insert testLead;

        Lead testLead2 = new Lead();
        testLead2.FirstName = 'Test';
        testLead2.LastName = 'Lead';
        testLead2.MobilePhone = '1234567878';
        testLead2.Company = 'Chatbot Lead';
        testLead2.RecordTypeId = qualifiedRecordTypeId;
        testLead2.School_Short_Code__c = 'STELRA';
        testLead2.Acadmic_Year__c = '2026-2027';
        testLead2.setOptions(dmlOpts);
        insert testLead2;
    }
    
    @isTest
    static void testGetLeadAPI_Success() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/get/lead';
        req.httpMethod = 'GET';
        req.addParameter('mobileNumber', '1234567890');
        req.addParameter('schoolCode', 'STELRB');
        req.addParameter('academicYear', '2026-2027');
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotGetLeadAPI.getLeadDetail();
        ChatbotGetLeadAPI.dummyMethod();
        Test.stopTest();
    }
    
    @isTest
    static void testGetLeadAPI_NewLead() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/get/lead';
        req.httpMethod = 'GET';
        req.addParameter('mobileNumber', '9999999999');
        req.addParameter('schoolCode', 'STELRA');
        req.addParameter('academicYear', '2026-2027');
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotGetLeadAPI.getLeadDetail();
        Test.stopTest();
    }
    
    @isTest
    static void testGetLeadAPI_MissingParam() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/get/lead';
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotGetLeadAPI.getLeadDetail();
        Test.stopTest();
    }
    
    @isTest
    static void testCreateLeadAPI_Success() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/create/lead';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"MobileNumber":"9876543210"}');
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotCreateLeadAPI.createLead();
        Test.stopTest();
    }
    
    @isTest
    static void testCreateLeadAPI_MissingMobile() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/create/lead';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{}');
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotCreateLeadAPI.createLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_Success() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        String requestBody = '{"leadId":"' + testLead.Id + '","schoolShortCode":"TEST","grade":"10","firstName":"John","lastName":"Doe","childFirstName":"Child","academicYear":"2024"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_MissingLeadId() {
        String requestBody = '{"schoolShortCode":"TEST"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_LeadNotFound() {
        String requestBody = '{"leadId":"00Q000000000000AAA"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_PartialUpdate() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        String requestBody = '{"leadId":"' + testLead.Id + '","firstName":"Jane"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_AccountLookupSuccess() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        String requestBody = '{"leadId":"' + testLead.Id + '","schoolShortCode":"STELRA"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_AccountNotFound() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        String requestBody = '{"leadId":"' + testLead.Id + '","schoolShortCode":"INVALID"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_ValidEmail() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        String requestBody = '{"leadId":"' + testLead.Id + '","email":"test@example.com"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_InvalidEmail() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        String requestBody = '{"leadId":"' + testLead.Id + '","email":"invalidemail"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_OwnerAssignment() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        String requestBody = '{"leadId":"' + testLead.Id + '","schoolShortCode":"STELRA","grade":"10"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateLeadAPI_SameSchoolCode() {
        Lead testLead = [SELECT Id, School_Short_Code__c FROM Lead LIMIT 1];
        testLead.School_Short_Code__c = 'STELRA';
        update testLead;
        
        String requestBody = '{"leadId":"' + testLead.Id + '","schoolShortCode":"STELRA","grade":"10"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/chatbot/update/lead';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(requestBody);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        ChatbotUpdateLeadAPI.updateLead();
        Test.stopTest();
    }
}