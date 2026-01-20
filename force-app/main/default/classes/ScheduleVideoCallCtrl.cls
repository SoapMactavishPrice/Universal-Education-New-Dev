/*
Created BY: Staller Team
*/
public with sharing class ScheduleVideoCallCtrl{
    public contact scontact{get;set;}
        public boolean back{get;set;}
    public string strschoolshortname;
        public string fullURl{get;set;}
    public string strtype{get;set;}
    public string customLabelValue{get;set;}
    public string customleadValue{get;set;}
    ID ConID = ApexPages.currentPage().getParameters().get('id');
    public ScheduleVideoCallCtrl(ApexPages.StandardController controller){
    	
        back = false;
    }
    public pageReference redirectMe() {
        system.debug('ConID >>>>>> @ > ' + ConID); 
        customLabelValue = System.Label.ScheduleVideoCall;
        system.debug('customLabelValue >>>>>> @ > ' + customLabelValue);
        scontact = new contact();
        scontact = [select id, name ,School_Short_Code__c,Lead_ID__c,Video_Call_Scheduled__c,VC_Scheduled_Date_Time__c,Video_Call_Scheduled_On__c  from contact where id=:ConID];
        system.debug('scontact >>>>>> @ > ' + scontact);
        if(scontact != null){
            customleadValue = scontact.Lead_ID__c; 
            if(scontact.Video_Call_Scheduled__c == true){back = true;ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Video Call Scheduled Already Done!!'));
            }
            else{
                if(scontact.School_Short_Code__c=='STELRB'){fullURl = customLabelValue+'&objectType=Contact&objectId='+scontact.id+'&type=stellar-world-school-bandra-video-call-with-admission-counselor';
                }if(scontact.School_Short_Code__c=='STELRA'){fullURl = customLabelValue+'&objectType=Contact&objectId='+scontact.id+'&type=stellar-world-school-andheri-video-call-with-admission-counselor';
                }if(scontact.School_Short_Code__c=='STELRG'){fullURl = customLabelValue+'&objectType=Contact&objectId='+scontact.id+'&type=stellar-world-school-goregaon-video-call-with-the-admission-counselor';
                }
                scontact.Re_Scheduled_Campus_Visit__c=true;
                //scontact.VC_Scheduled_Date_Time__c=Date.today();
                //scontact.Video_Call_Scheduled_On__c=Date.today();
                scontact.Stages__c = 'Video Call Scheduled';
                update scontact;
            }
            if(customleadValue != null){updateleads(customleadValue);
            }
        }
       if(fullURl != null){PageReference retURL = new PageReference(fullURl);retURL.setRedirect(true);
            return retURL;}
        else{
            PageReference retURL = new PageReference('/'+scontact.id);
            retURL.setRedirect(true);
            return retURL;
        }
    }
    public void updateleads(string leadstring) {
       system.debug('leadstring >>>>>> @ > ' + leadstring);
        List<lead> lstlead = new List<Lead>();List<lead> slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: leadstring];
        if(!lstlead.isEmpty()){for(lead le : slitlead){
                lead l = new lead();l.id = le.id;l.Stage__c = 'Video Call Scheduled';lstlead.add(l);
            }
            system.debug('lstlead -- ' + lstlead);
            if(!lstlead.isEmpty()){update lstlead;
            }
        }
    }
}