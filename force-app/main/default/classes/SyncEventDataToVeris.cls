public class SyncEventDataToVeris {

    @future(callout = true)
    public static void syncData(String eventdata, String clsName) {

        API_log__c api_log = new API_log__c();
        try {

            api_log.Name = 'SyncEventDataToVeris';
            api_log.Apex_Class_Name__c = 'API hit from ' + clsName;

            System.debug('SyncEventDataToVeris:>>> ');
            Map<String, Object> mapEventData = (Map<String, Object>)JSON.deserializeUntyped(eventdata);
            System.debug('SyncEventDataToVeris222:>>> ');
            String URL = System.Label.Veris_URL;
            Map < String, Object > resBodyMap = new Map < String, Object > ();
            Map < String, Object > resWrapper = new Map < String, Object > ();

            api_log.Request_Body__c = eventdata;
            api_log.Request_Date_and_Time__c = Datetime.now();

            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('POST');
            httpReq.setBody(eventdata);
            httpReq.setEndpoint(URL);
            httpReq.setTimeout(120000);
            httpReq.setHeader('x-api-key', System.Label.Veris_API_Key);

            Http h = new Http();
            HttpResponse httpRes;
            if (!Test.isRunningTest()) {
                httpRes = h.send(httpReq);
            } else {
                httpRes = new HttpResponse();
                httpRes.setHeader('Content-Type', 'application/json');
                httpRes.setBody('{"example":"test"}');
                httpRes.setStatusCode(200);
            }

            api_log.Response_Code__c = String.valueOf(httpRes.getStatusCode());
            api_log.Response_Body__c = httpRes.getBody();
            api_log.Response_Date_and_Time__c = Datetime.now();
            if (httpRes.getStatusCode() == 200) {
                //map fields from response to Wrapper class
                resBodyMap = (Map < String, Object > ) JSON.deserializeUntyped(httpRes.getBody());
                System.debug('HA 111 Response:>>> ' + resBodyMap);
                System.debug('HA 111 Response:>>> ' + String.valueOf(resBodyMap.get('invite_id')));
                System.debug('HA 111 Response:>>> ' + String.valueOf(mapEventData.get('EventId')));
                Event ent = [
                    SELECT Id, Veris_Invite_Id__c
                    FROM Event
                    WHERE Id =: String.valueOf(mapEventData.get('EventId'))
                ];
                ent.Veris_Invite_Id__c = String.valueOf(resBodyMap.get('invite_id'));
                update ent;
                resWrapper.put('resData', resBodyMap);
                api_log.API_Log_Status__c ='Success';
                
            } else {
                System.debug('RRRResponse:>>> ' + httpRes.getBody());
                // Map < String, Object > mp = (Map < String, Object > ) JSON.deserializeUntyped(httpRes.getBody());
                // if ((String) mp.get('message') != null) {
                //     resWrapper.put('ErrorMsg', (String) mp.get('message'));
                // }
                resWrapper.put('ErrorMsg', httpRes.getBody());
                api_log.API_Log_Status__c ='Failure';
            }

        } catch (Exception e) {
            System.debug('e.getLineNumber() :>>>>>>>> ' + e.getLineNumber());
            System.debug('e.getMessage() :>>>>>>>> ' + e.getMessage());
            api_log.Response_Date_and_Time__c = System.now();
            api_log.Exception_Stack_Trace__c = e.getLineNumber() +' || '+e.getMessage();
            api_log.Response_Body__c = 'Something went wrong!!';
            api_log.Response_Code__c = '400';
        }

        insert api_log;
        
    }

}