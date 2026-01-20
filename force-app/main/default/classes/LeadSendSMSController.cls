public with sharing class LeadSendSMSController {

    public string sendTemplate {get;set;}
    public string sendTo {get;set;}
    public string contactName { get;set;}
    public string gupshupUserID{ get;set;}
    public string gupshupPassword{ get;set;}
    public string ContactID{ get;set;}
    public  LeadSendSMSController(ApexPages.StandardController controller){
        try{
            ContactID = ApexPages.currentPage().getParameters().get('id');
            system.debug('cid::'+ContactID);
            gupshupUserID='2000045203';
            gupshupPassword='universalgoogle';
            Lead contact=[select id,Name,MobilePhone,Phone,School_Institution__c,Email FROM Lead WHERE ID=:ContactID];
            System.debug('Lead::::'+contact);
            smsgupshupTemplate__c smsgupshupTemplate= [SELECT Name__c, Description__c FROM smsgupshupTemplate__c limit 1];
            System.debug('SendTemplate::::'+smsgupshupTemplate);
            sendTemplate=smsgupshupTemplate.Description__c;
            
            sendTo=contact.MobilePhone.replaceAll('\\D','');
            contactName =contact.Name;

        }catch(Exception ex){
            System.debug(ex.getMessage());
        }

    }
    public void sendsms(){
        try {
            if(sendTo == ''){
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,'Please enter sender number');
                apexpages.addmessage(msg);
            }
            else{
                string response= sendgupshupsms();
                if(response !=''){
                    System.debug(response);
                    if(response.contains('success')){
                        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'SMS has send successfully');
                        apexpages.addmessage(msg);
                        smsgupshup__c smsgupshup=new smsgupshup__c();
                        smsgupshup.Contact_ID__c=ContactID;
                        smsgupshup.Contact_Name_Number__c=contactName;
                        smsgupshup.Message__c=sendTemplate;
                        smsgupshup.Sender_Number__c=sendTo;
                        insert smsgupshup;
                    }
                    else{
                        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,response);
                        apexpages.addmessage(msg);
                    }
                }
                else {
                    apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,'SMS has not send');
                    apexpages.addmessage(msg);
                }
            }

        }catch(Exception ex)
        {
            System.debug(ex.getMessage());
        }

    }
    public string sendgupshupsms(){
        try{
            string FinalMsg= EncodingUtil.urlEncode(sendTemplate, 'UTF-8');
            string endpoint='https://enterprise.smsgupshup.com/GatewayAPI/rest?method=SendMessage&send_to='+sendTo+'&msg='+FinalMsg+'&msg_type=TEXT&userid='+ gupshupUserID+'&auth_scheme=plain&password='+ gupshupPassword+'&v=1.1&format=text';
            String bodyContent='';
            HttpRequest req = new HttpRequest();
            Http httpreq = new Http();
            req.setHeader('cache-control', 'no-cache');
            req.setBody(bodyContent);
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            HttpResponse res = httpreq.send(req);
            String reqresponse = res.getBody();
            System.debug('response:::'+reqresponse);
            return reqresponse;

        }catch (Exception ex){
            System.debug(ex.getMessage());
            return  '';
        }
    }
    public List<SelectOption> getsmsTemplates() {
        List<SelectOption> smsTemplates = new List<SelectOption>();
        try{
            for(smsgupshupTemplate__c sms :[SELECT Name__c,Description__c FROM smsgupshupTemplate__c ]){
                smsTemplates.add(new selectoption(sms.Description__c,sms.Name__c));
            }
        }catch (Exception ex)
        {
            System.debug(ex.getMessage());
        }
        return smsTemplates;

    }

}