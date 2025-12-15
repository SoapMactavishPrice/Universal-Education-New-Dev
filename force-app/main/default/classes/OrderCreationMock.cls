public with sharing class OrderCreationMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"id":"test","razorpay_payment_id":"test payment","razorpay_order_id":"orderid","razorpay_signature":"signature"}');
        response.setStatusCode(200);
        return response;
    }
}