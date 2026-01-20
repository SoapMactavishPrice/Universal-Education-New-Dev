@isTest
global class EnquirySendSMSControllerMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('SMS has send successfully');
         response.setStatusCode(200);
        return response;
    }
}