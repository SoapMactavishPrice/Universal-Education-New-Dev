//Purpose for sendSms through Lead Object

@isTest
global class MockHttpResponseGeneratorOtp implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://enterprise.smsgupshup.com/GatewayAPI/rest?method=SendMessage&send_to=8197318304&msg=Dear Parent, School other Contact Numbers are +91 8080040602 / 3 / 4&msg_type=TEXT&userid=2000045203&auth_scheme=plain&password=universalgoogle&v=1.1&format=text',req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('cache-control', 'no-cache');
        res.setBody('success | 918197318304 | 4174550753077256253-21653603429236536');
        
        res.setStatusCode(200);
        system.debug('Res::'+res);
        return res;
    }
}