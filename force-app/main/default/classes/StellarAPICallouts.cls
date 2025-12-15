public with sharing class StellarAPICallouts {

    public static final String POST_METHOD = 'POST';
    public static final String GET_METHOD = 'GET';
    public static final String PUT_METHOD = 'PUT';
    

    public static String makeCallout(String endpoint, String method, Object body) {
        method = String.isNotBlank(method) ? method.toUpperCase() : 'GET';
        Http httpobj = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // request.setHeader('Authorization', authHeader);
        if(body != null){
            System.debug('theBody: '+JSON.serialize(body));
            request.setBody(JSON.serialize(body));
        }
        // request.setTimeout(20000);
        HttpResponse response = httpobj.send(request);
        System.debug('response: '+response);
        System.debug('response.getBody: '+response.getBody());
        return response.getBody();
    }

    public static Map<String, Object> createBody(List<String> keyList, List<Object> valueList){
        Map<String, Object> requestBody = new Map<String, Object>();
        for(Integer indexCounter = 0 ; indexCounter < keyList.size() ; indexCounter++){
            requestBody.put(keyList[indexCounter], valueList[indexCounter]);
        }
        return requestBody;
    }

    public static Boolean checkIfStellarAPIEnabled(String schoolShortCode) {
        List<School_List__mdt> schoolListmeta = [SELECT Id, Enable_Stellar__c, MasterLabel, DeveloperName FROM School_List__mdt WHERE DeveloperName = :schoolShortCode];
        if(schoolListmeta != null && !schoolListmeta.isEmpty() && schoolListmeta[0].Enable_Stellar__c) return true;
        return false;
    }
}
/* 
System.debug(StellarAPICallouts.checkIfStellarAPIEnabled(null));
API: https://admission.stellarworldschool.com/salesforce/send-form
Method: POST 
Request Body:
{
    "formLink": "http://somelink",
    "formType": "ENQUIRY",
    "email": "raghav@technogise.com",
    "data": {
    "parentFirstname": "Raghav",
    "parentLastname": "Sharma"
    }
}

*/