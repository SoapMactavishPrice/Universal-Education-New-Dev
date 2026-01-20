@isTest
private class getLeadDetailsAPITest {
    @isTest
    static void testDoGet_ExistingLead_CentralizedCalling() {
        Account acc = new Account(
            Name = 'Test School',
            School_Short_Code__c = 'SSC001',
            DID_Number__c = 'DID123',
            Centralized_Calling_Team__c = true,
            Skill_Name__c = 'Math'
        );
        insert acc;

        Profile p = [SELECT Id FROM Profile WHERE Name='Communication Executive (CE)' LIMIT 1];

        User ceUser = new User(
            LastName = 'CommExec',
            Email = 'ceuser@test.com',
            Phone = '111111',
            Username = 'ceuser.test@company.com',
            Alias = 'ceuser',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert ceUser;

        Lead lead = new Lead(
            LastName ='Test Lead',
            MobilePhone ='9998887777',
            School_Short_Code__c = acc.School_Short_Code__c,
            OwnerId = ceUser.Id,
            Meet_Done__c = true,
            Company = 'Test Company'
        );
        insert lead;

        String reqBody = '{"customerNumber":"9998887777","DIDNumber":"DID123"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        getLeadDetailsAPI.doGet();
        Test.stopTest();
    }

    @isTest
    static void testDoGet_NewLead_NoCentralizedCalling() {
        Account acc = new Account(
            Name = 'Test School2',
            School_Short_Code__c = 'SSC002',
            DID_Number__c = 'DID999',
            Centralized_Calling_Team__c = false,
            Skill_Name__c = 'Science'
        );
        insert acc;

        String reqBody = '{"customerNumber":"5554443333","DIDNumber":"DID999"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        getLeadDetailsAPI.doGet();
        Test.stopTest();
    }

    @isTest
    static void testDoGet_DIDNotFound() {
        String reqBody = '{"customerNumber":"8888888888","DIDNumber":"NOTFOUND"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        getLeadDetailsAPI.doGet();
        Test.stopTest();
    }

    @isTest
    static void testDoGet_BlankInput() {
        String reqBody = '{"customerNumber":"","DIDNumber":""}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        getLeadDetailsAPI.doGet();
        Test.stopTest();
    }
}