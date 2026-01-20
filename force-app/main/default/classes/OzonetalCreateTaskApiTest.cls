@isTest
private class OzonetalCreateTaskApiTest {
    
    @isTest
    static void testDoPost() {
        Lead l = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Ozonetel Lead',
            MobilePhone = '9876543210'
        );
        insert l;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/ozonetal/create/task';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"9876543210","subject":"Test","status":"Completed","priority":"Normal","agentStatus":"Available","agentId":"123","agentNumber":456,"callBackTime":"2024-01-01T10:00:00Z","callEndTime":"2024-01-01T10:05:00Z","callObject":"obj1","callStartTime":"2024-01-01T10:00:00Z","callType":"Inbound","campaignName":"Test Campaign","customerStatus":"Active","did":"1234","disposition":"Completed","dispositionDescription":"Test Desc","duration":300,"monitorUcid":"ucid1","audioFile":"audio.mp3","schoolCode":"SCH01","skillName":"Sales","transferType":"Type1","transferTo":"Agent2","ucid":"ucid123","uui":"uui123"}');
        
        RestContext.request = req;
        RestContext.response = res;
        
        OzonetalCreateTaskApi.doPost();
    }
    
    @isTest
    static void testDoPostError() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/ozonetal/create/task';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":""}');
        
        RestContext.request = req;
        RestContext.response = res;
        
        OzonetalCreateTaskApi.doPost();
    }
    
    @isTest
    static void testDoPostNoLead() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/ozonetal/create/task';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"1111111111"}');
        
        RestContext.request = req;
        RestContext.response = res;
        
        OzonetalCreateTaskApi.doPost();
    }
}