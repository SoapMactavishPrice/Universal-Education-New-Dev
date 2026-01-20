public class ST_RescheduleExtension {
    String meetingURL{get;set;}
    public boolean back{get;set;}
    public contact scontact{get;set;}
    public string customleadValue{get;set;}
    public ST_RescheduleExtension(ApexPages.StandardController Controller){
       
        String cid = Apexpages.currentpage().getParameters().get('id');
        system.debug('cid' + cid);
        scontact=[select id,Name,Re_Scheduled_Campus_Visit__c,Lead_ID__c from Contact where Id=:cid];
        String meetingType = Apexpages.currentpage().getParameters().get('meetingType');
        meetingURL='/'+cid;
        system.debug('meetingType' + meetingType);
        system.debug('meetingURL' + meetingURL);
        customleadValue = scontact.Lead_ID__c;
        if(scontact.Re_Scheduled_Campus_Visit__c==true)
        {
            back=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Re Scheduled Campus Visit Already Done.'));
        }else{
            scontact.Re_Scheduled_Campus_Visit__c=true;
            update scontact;
        }
        
    }
    public PageReference redirectToReschedule(){
        PageReference retURL = new PageReference(meetingURL);
        retURL.setRedirect(true);
        return retURL;
    }
    
}