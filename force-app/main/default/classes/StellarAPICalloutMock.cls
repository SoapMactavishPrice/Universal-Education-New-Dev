public with sharing class StellarAPICalloutMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        // response.setBody('{"example":"test"}');
        response.setStatusCode(200);
        return response;
    }
}