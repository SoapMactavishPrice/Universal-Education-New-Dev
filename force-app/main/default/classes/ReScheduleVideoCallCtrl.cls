public class ReScheduleVideoCallCtrl {
    public contact scontact{get;set;}
        public boolean back{get;set;}
    public string strschoolshortname;
    public string strtype{get;set;}
    public string customLabelValue{get;set;}
    public string customleadValue{get;set;}
    ID ConID = ApexPages.currentPage().getParameters().get('id');
    public ReScheduleVideoCallCtrl(ApexPages.StandardController controller){
        back = false;
    }
    public pageReference ReScheduleVideoCal() {
        system.debug('ConID >>>>>> @ > ' + ConID); 
        customLabelValue = System.Label.ScheduleCampusVisit;
        system.debug('customLabelValue >>>>>> @ > ' + customLabelValue);
        scontact = new contact();
        scontact = [select id, name ,School_Short_Code__c,Lead_ID__c,VC_Rescheduled__c  from contact where id=:ConID];
        system.debug('scontact >>>>>> @ > ' + scontact);
        if(scontact != null){
            customleadValue = scontact.Lead_ID__c; 
            if(scontact.VC_Rescheduled__c == true){
                back = true;
                system.debug('INSIDE IF Stage::'+scontact.Campus_Visit_Scheduled__c);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Video Call Re Scheduled Already Done!!'));
            }
            else{
                scontact.VC_Rescheduled__c =true;
                scontact.Stages__c='CV Rescheduled';
                update scontact;
            }
        }
       PageReference retURL = new PageReference('/'+scontact.Id);
        retURL.setRedirect(true);
        return retURL;
    }
}