public class EnquirySendSmSCallout {
    public static string sendTemplate {get;set;}
    public static string sendTo {get;set;}
    public static string contactName { get;set;}
    public static string gupshupUserID{ get;set;}
    public static string gupshupPassword{ get;set;}
    public static string EnquiryID{ get;set;}
     public  EnquirySendSMSCallout(){
       try{
            //EnquiryID = ApexPages.currentPage().getParameters().get('id');
            gupshupUserID='2000045203';
            gupshupPassword='universalgoogle';
            //Enquiry__c contact=[SELECT  ParentFull_Name__c,Parent_First_Name__c,Name,Mobile_No__c From Enquiry__c WHERE ID=:EnquiryID];
            smsgupshupTemplate__c smsgupshupTemplate= [SELECT Name__c, Description__c FROM smsgupshupTemplate__c limit 1];
            sendTemplate=smsgupshupTemplate.Description__c;
            //sendTo=contact.Mobile_No__c;
            //contactName =contact.ParentFull_Name__c;

        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }
    
    public static void sendsms(){
        try {
            if(sendTo == ''){
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,'Please enter sender number');
                //apexpages.addmessage(msg);
            }
           }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
        }

    }
    @future(callout=true)
    public static void sendgupshupsms(String sendTemplate1,String SendTo,String gupshupUserID1,String gupshupPassword1 ){
        System.debug('TEST2:::');
        try{
            string FinalMsg= EncodingUtil.urlEncode(sendTemplate1, 'UTF-8');
            string endpoint='https://enterprise.smsgupshup.com/GatewayAPI/rest?method=SendMessage&send_to='+sendTo+'&msg='+FinalMsg+'&msg_type=TEXT&userid='+ gupshupUserID1+'&auth_scheme=plain&password='+ gupshupPassword1+'&v=1.1&format=text';
            String bodyContent='';
            HttpRequest req = new HttpRequest();
            Http httpreq = new Http();
            req.setHeader('cache-control', 'no-cache');
            req.setBody(bodyContent);
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            HttpResponse res = httpreq.send(req);
            system.debug('response::::'+res);
            String reqresponse = res.getBody();
            System.debug('TEST4:::'+reqresponse);
            //return reqresponse;
            
        }catch (Exception ex){
            System.debug(ex.getMessage());
            //return  '';
        }
    }
}