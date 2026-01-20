/**
 * Created by Admin on 2018-08-16.
 */

public with sharing class EnquirySendSMSController {

    public string sendTemplate {get;set;}
    public string sendTo {get;set;}
    public string contactName { get;set;}
    public string gupshupUserID{ get;set;}
    public string gupshupPassword{ get;set;}
    Public string Shortname{get; set;}
    public string EnquiryID{ get;set;}
    Public List<Gupshup_Credential__mdt> listCustomMetadata {get;set;}
    public  EnquirySendSMSController(ApexPages.StandardController controller){
        try{
            EnquiryID = ApexPages.currentPage().getParameters().get('id');
           /* gupshupUserID='2000045203';
            gupshupPassword='universalgoogle'; */
            Enquiry__c contact=[SELECT  ParentFull_Name__c,Parent_First_Name__c,Name,Mobile_No__c,Org_code__c From Enquiry__c WHERE ID=:EnquiryID];
            smsgupshupTemplate__c smsgupshupTemplate= [SELECT Name__c, Description__c FROM smsgupshupTemplate__c limit 1];
            Shortname = '%'+ contact.Org_code__c +'%';
            sendTemplate='';//smsgupshupTemplate.Description__c;
            sendTo=contact.Mobile_No__c.replaceAll('\\D','');
            contactName =contact.ParentFull_Name__c;
           
            listCustomMetadata = [Select id,Gupshup_Username__c,Gupshup_Password__c,SchoolShortCode__c from Gupshup_Credential__mdt where SchoolShortCode__c LIKE :Shortname];
           
           If (listCustomMetadata.size() >0 && listCustomMetadata!=null){
           gupshupUserID=listCustomMetadata[0].Gupshup_Username__c ;
           gupshupPassword=listCustomMetadata[0].Gupshup_Password__c;
           }
           else {
           apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,'Please add school');
                apexpages.addmessage(msg);
           }
           
            system.debug('SEND-TO:::::'+sendTo);
            system.debug('TEMPLATE:::'+sendTemplate);

        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }
/*    public  EnquirySendSMSController(){
       try{
            EnquiryID = ApexPages.currentPage().getParameters().get('id');
            gupshupUserID='2000045203';
            gupshupPassword='universalgoogle';
            Enquiry__c contact=[SELECT  ParentFull_Name__c,Parent_First_Name__c,Name,Mobile_No__c From Enquiry__c WHERE ID=:EnquiryID];
            smsgupshupTemplate__c smsgupshupTemplate= [SELECT Name__c, Description__c FROM smsgupshupTemplate__c limit 1];
            sendTemplate=smsgupshupTemplate.Description__c;
            sendTo=contact.Mobile_No__c;
            contactName =contact.ParentFull_Name__c;
            system.debug('INSIDE_SEND_SMS-TO:::::'+sendTo);
            system.debug('INSIDE_SEND_SMS_TEMPLATE:::'+sendTemplate);

        }catch(Exception ex){
            System.debug('Error:::'+ex.getMessage());
        }
    }*/
    
    public void sendsms(){
        try {
            if(sendTo == ''){
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,'Please enter sender number');
                apexpages.addmessage(msg);
            }
            else{
                string response= sendgupshupsms();
                System.debug('RESPONSE:::::'+response);
                if(response !=''){
                    System.debug('RESPONSE:::::'+response);
                    if(response.contains('success')){
                        apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'SMS has send successfully');
                        apexpages.addmessage(msg);
                        smsgupshup__c smsgupshup=new smsgupshup__c();
                        smsgupshup.Contact_ID__c=EnquiryID;
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
            system.debug('ENPOINT URL:::'+endpoint);
            String bodyContent='';
            HttpRequest req = new HttpRequest();
            Http httpreq = new Http();
            req.setHeader('cache-control', 'no-cache');
            req.setBody(bodyContent);
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            HttpResponse res = httpreq.send(req);
            String reqresponse = res.getBody();
            system.debug('REQUEST_RESPONSE::::'+reqresponse);
            return reqresponse;
            

        }catch (Exception ex){
            System.debug('ERROR IN SENDING SMS:::'+ex.getMessage());
            return  '';
        }
    }
    public List<SelectOption> getsmsTemplates() {
        List<SelectOption> smsTemplates = new List<SelectOption>();
        try{
            smsTemplates.add(new selectoption('','--None--'));
            for(smsgupshupTemplate__c sms :[SELECT Name__c,Description__c FROM smsgupshupTemplate__c where Name__c LIKE :Shortname ]){
                smsTemplates.add(new selectoption(sms.Description__c,sms.Name__c));
            }
        }catch (Exception ex)
        {
            System.debug(ex.getMessage());
        }
        return smsTemplates;

    }
}