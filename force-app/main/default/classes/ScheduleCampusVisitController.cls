/*
Created BY: Staller Team
*/
public with sharing class ScheduleCampusVisitController{
    public contact scontact{get;set;}
    public boolean back{get;set;}
    public string strschoolshortname;
    public string strtype{get;set;}
    public string fullURl{get;set;}
    public string customLabelValue{get;set;}
    public string customleadValue{get;set;}
    ID ConID = ApexPages.currentPage().getParameters().get('id');
    public ScheduleCampusVisitController(ApexPages.StandardController controller){
        system.debug('ConID >>>>>> @ > ' + ConID); 
        back = false;
    }
    public pageReference redirectMe() {
        customLabelValue = System.Label.ScheduleCampusVisit;
        system.debug('customLabelValue >>>>>> @ > ' + customLabelValue);
        scontact = new contact();
        scontact = [select id, name ,School_Short_Code__c,Lead_ID__c,Campus_Visit_Scheduled__c  from contact where id=:ConID];
        system.debug('scontact >>>>>> @ > ' + scontact);
        if(scontact != null){
            if(scontact.Campus_Visit_Scheduled__c == true){  back = true;ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Campus Visit Scheduled Already Done!!'));
            }
            else{
                if(scontact.School_Short_Code__c=='STELRB'){ fullURl = customLabelValue+'&objectType=Contact&objectId='+scontact.id+'&type=stellar-world-school-bandra-video-call-with-admission-counselor';
                }if(scontact.School_Short_Code__c=='STELRA'){fullURl = customLabelValue+'&objectType=Contact&objectId='+scontact.id+'&type=stellar-world-school-andheri-video-call-with-admission-counselor';
                }if(scontact.School_Short_Code__c=='STELRG'){ fullURl = customLabelValue+'&objectType=Contact&objectId='+scontact.id+'&type=stellar-world-school-goregaon-video-call-with-the-admission-counselor';
                }
                customleadValue = scontact.Lead_ID__c;
                scontact.Stages__c ='Campus Visit Scheduled';
                scontact.Campus_Visit_Scheduled__c = true;
                update scontact;
            }
            if(customleadValue != null){updateleads(customleadValue);
            }
        }
        system.debug('fullURl >>> ' + fullURl);
        if(fullURl != null){PageReference retURL = new PageReference(fullURl);
            retURL.setRedirect(true); return retURL;}
        else{
            PageReference retURL = new PageReference('/'+scontact.id);
            retURL.setRedirect(true);
            return retURL;
        }
    }
    public void updateleads(string leadstring) {
        system.debug('leadstring >>>>>> @ > ' + leadstring);
        List<lead> lstlead = new List<Lead>();List<lead> slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: leadstring];
        if(!lstlead.isEmpty()){for(lead le : slitlead){ lead l = new lead(); l.id = le.id;l.Stage__c = 'Campus Visit Scheduled';
                lstlead.add(l);
            }
            system.debug('lstlead -- ' + lstlead);
            if(!lstlead.isEmpty()){ update lstlead;
            }
        }
    }
}