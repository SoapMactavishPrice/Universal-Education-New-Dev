Public class razorPayOrderCreationAPI
{
    @future(callout=true)
    public static void OrderCreation(String enqid,decimal amount)
    {
        string endpoint;
        string jsonbody;
        Map<String,Universal_Application_Fee_Amount__mdt> schoolNameUAmdtMap = new Map<String,Universal_Application_Fee_Amount__mdt>();
        
        DB_Logs_Summarys__c objDBLogsSummary = new DB_Logs_Summarys__c();
        objDBLogsSummary.Object_Name__c = 'Enquiry';
        objDBLogsSummary.Processing_API__c = 'razorPayOrderCreationAPI';
        
        Enquiry__c enq = [SELECT Id,Name,School_Institution__c,School_Institution__r.School_Short_Code__c,Receipt_No__c,Order1_Id__c FROM Enquiry__c WHERE   Id = :enqid]; 
        system.debug('====enq=='+enq);
        if(enq!=null)
        {
            for (Universal_Application_Fee_Amount__mdt mdtUAFA : [SELECT Merchant_ID__c,Application_Fees__c ,Message__c,Short_Code__c,Payment_Applicable__c,Key_Id__c,
                                                                  Payment_Gateway__c,Key_Secret__c FROM Universal_Application_Fee_Amount__mdt WHERE Short_Code__c =: enq.School_Institution__r.School_Short_Code__c
                                                                  and Payment_Applicable__c =true and Payment_Gateway__c = 'RazorPay' and Key_Id__c != null and Key_Secret__c !=null]) 
            {
                schoolNameUAmdtMap.put(mdtUAFA.Short_Code__c,mdtUAFA);
            }
            if(schoolNameUAmdtMap.containsKey(enq.School_Institution__r.School_Short_Code__c))
            {
                requesrCall rq = new requesrCall();
                rq.amount = amount;
                rq.ccurrency = 'INR';
                rq.receipt = enq.Receipt_No__c;
                jsonbody = json.serialize(rq);
                jsonbody = jsonbody.replace('"ccurrency"', '"currency"'); 
                
                endpoint =Razorpay_Endpoint__c.getInstance('Create Order').Endpoint__c; 
                
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setHeader('Content-Type','application/json'); 
                req.setBody(jsonbody);
                System.debug('+++++++++++++'+jsonbody);
                String username = schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Key_Id__c;
                String password = schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Key_Secret__c;
                
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);                 
                Http http = new Http();
                HTTPResponse res = http.send(req);
                String resBody = res.getBody();
                System.debug('++++resBody++++++++'+res.getBody());
                system.debug('====status code===='+res.getStatusCode());
                
                
                if(res.getStatusCode() == 200)
                {
                    responseCall reswrap = new responseCall();
                    reswrap =  (responseCall)System.JSON.deserialize(resBody, responseCall.class); 
                    system.debug('====reswrap===='+reswrap);
                    if(reswrap != null)
                    {
                        if(reswrap.id != null)
                        {
                            system.debug('====reswrap.id=='+reswrap.id);
                            enq.Order1_Id__c = reswrap.id;
                            update enq;
                        }
                    }
                    objDBLogsSummary.Status__c = 'Success'; 
                    objDBLogsSummary.Error_Message__c = 'Success';                
                }
                else{
                    objDBLogsSummary.Status__c = 'Failure';
                    objDBLogsSummary.Error_Message__c = resBody;
                }  
                
                system.debug('====enq update==='+enq);
                //objDBLogsSummary.Received_Data__c = req;
                objDBLogsSummary.Response_Sent__c = resBody;
                insert objDBLogsSummary;
            }        
        }
    }    
    public class requesrCall
    {
        public decimal amount;
        public string ccurrency;
        public string receipt;
    }
    
    public class responseCall
    {
        public string id;
        
    }  
}