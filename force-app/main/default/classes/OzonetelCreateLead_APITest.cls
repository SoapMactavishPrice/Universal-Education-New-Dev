@isTest
private class OzonetelCreateLead_APITest {
    @isTest
    static void testDoPost_ValidInput_WithAccount() {
        // Create Account with DID_Number__c
        Account acc = new Account(Name = 'Test School', DID_Number__c = 'DID123', School_Short_Code__c = 'SSC001');
        insert acc;
        
        // Get RecordType Id for Lead with DeveloperName = 'Qualified'
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Qualified' AND SobjectType = 'Lead' LIMIT 1];
        
        // Prepare JSON request body
        String reqBody = '{"FirstName":"John","LastName":"Doe","Phone":"1234567890","Email":"john@example.com","DIDNumber":"DID123"}';
        
        // Setup REST request & response
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        OzonetelCreateLead_API.doPost();
        Test.stopTest();
    }
    
    @isTest
    static void testDoPost_ValidInput_NoAccount() {
        String reqBody = '{"FirstName":"Alice","LastName":"Smith","Phone":"9876543210","Email":"alice@example.com"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        OzonetelCreateLead_API.doPost();
        Test.stopTest();
    }
    
    @isTest
    static void testDoPost_MissingLastName() {
        String reqBody = '{"FirstName":"Jake","Phone":"1112223333","Email":"jake@example.com"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        OzonetelCreateLead_API.doPost();
        Test.stopTest();
    }
    
    @isTest
    static void testDoPost_MissingPhone() {
        String reqBody = '{"FirstName":"Jake","LastName":"Johnson","Email":"jake@example.com"}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqBody);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        OzonetelCreateLead_API.doPost();
        Test.stopTest();
    }
}