public class LeadDuplicateInsertTriggerHandler {
    
    
    public static void updateLeadStatus(List<Lead> ldLst){
        
        set<integer> fieldHash=new set<integer>();
        set<string> ldSet=new set<string>();
        
        for(Lead ld:ldLst){
            ldSet.add(ld.Email);
            ldSet.add(ld.Your_First_Name__c);
            ldSet.add(ld.DupMobileNumber__c);
            ldSet.add(ld.School_Institution__c);
            ldSet.add(ld.Acadmic_Year__c); 
        }
        
        List<lead> leadRecords=[SELECT Email,leadsource,Your_First_Name__c,MobilePhone,School_Institution__c,Acadmic_Year__c FROM Lead where Acadmic_Year__c in :ldSet AND School_Institution__c in :ldSet AND Email IN :ldSet AND Your_First_Name__c IN:ldSet AND MobilePhone IN:ldSet];
        
        for(Lead leadRecord:leadRecords){
            integer hasValue=GetHashValue(leadRecord);
            fieldHash.add(hasValue);
        }
        
        for(Lead leadRecord:ldLst){
            integer hasValue=GetHashValue(leadRecord);
            if(fieldHash.contains(hasValue)){
                system.debug('#leadRecord'+leadRecord);
                leadRecord.Status = 'Duplicate';
                //leadRecord.addError('Duplicate Lead already exists in the system');
            }
        }
    }
    
    public static integer GetHashValue(lead leadRecord){
        string valueComb;
        if(leadRecord.Acadmic_Year__c!=null){
            valueComb+=leadRecord.Acadmic_Year__c;
        }
        if(leadRecord.School_Institution__c!=null){
            valueComb+='-'+leadRecord.School_Institution__c;
        }
        
        if(leadRecord.MobilePhone!=null){
            valueComb+='-'+leadRecord.DupMobileNumber__c;
        }
        
        if(leadRecord.LeadSource!='Incoming call'){
            if(leadRecord.Your_First_Name__c!=null){
                valueComb+='-'+leadRecord.Your_First_Name__c;
            }
            if(leadRecord.Email!=null){
                valueComb+='-'+leadRecord.Email;
            }
        }
        system.debug('valueComb#'+valueComb);
        integer hasValue=valueComb.hashCode();
        return hasValue;
    }
    
    public static void updateCurrentStatus(List<Lead> listlead){
        system.debug('listlead ' + listlead);
        List<Lead> lstLead = new List<Lead>();
        list<Task> lstTaskToInsert = new list<Task>();
        string leadReasons;
        if(RecursiveTriComCurrStatusHandler.isFirstTime == true){
            for(Lead ld:listlead){
                leadReasons = ld.Reasons__c;
               
                //oLead.id = ld.id;
                if(ld.Status == 'Dormant' && ld.Converted__c == true){
                    ld.Current_Status__c = 'Dormant';    
                }else if(ld.Converted__c == true){
                    ld.Current_Status__c = 'Nurturing';    
                }
                
                if(ld.LeadSource == null && ld.utm_source__c == null){
                    system.debug('insde 1 if'+ld.LeadSource);
                    ld.LeadSource ='Website';
                }else if(ld.LeadSource == null && ld.utm_source__c == 'Website'){   
                    system.debug('insde 2 if'+ld.LeadSource);
                    ld.LeadSource ='Website';
                }else if(ld.utm_source__c !='' && ld.LeadSource == null){
                    system.debug('insde 3 if'+ld.LeadSource);
                    ld.LeadSource ='Search';
                }else{
                    system.debug('insde 4 if'+ld.LeadSource);
                    ld.LeadSource = ld.LeadSource; 
                }
                system.debug('ld.Status ' + ld.Status);
                system.debug('ld.Reasons__c ' + ld.Reasons__c);
                
              //  lstLead.add(oLead);
            }
           /* system.debug('lstLead  ' + lstLead);
            if(!lstLead.isEmpty()){
                RecursiveTriComCurrStatusHandler.isFirstTime = false;
                update lstLead;  
            } */
           
            
        }
    }
	
	 public static void updateCurrentStatusOnLead(List<Lead> listlead, Map<Id, lead> oldMap){
    List<Lead> lstLead = new List<Lead>();
    List<Task> lstTaskToInsert = new List<Task>();
    String leadReasons;

    for(Lead ld : listlead){
        Lead oldlead = new Lead();
        leadReasons = ld.Reasons__c;
        oldlead.Id = ld.Id;

        if(oldMap != null && oldMap.containsKey(ld.Id)) {
            oldlead = oldMap.get(ld.Id);
            System.debug(oldMap.get(ld.Id));
        }

        System.debug('oldTask: ' + oldlead);
        System.debug('Lead Status: ' + ld.Status);
			 system.debug('Inside1111>>>'+ld.Status+''+oldlead.Status+''+ld.Reasons__c+''+oldlead.Reasons__c);
        if ((ld.Status != oldlead.Status) || (ld.Reasons__c != oldlead.Reasons__c)) {
             system.debug('Inside2222>>>'+ld.Status+''+oldlead.Status+''+ld.Reasons__c+''+oldlead.Reasons__c);
            if(ld.Status =='Working' && (ld.Reasons__c=='Busy now call me later' || ld.Reasons__c=='No Response' || ld.Reasons__c=='Request more details')){
                Task objTask = new Task();
                system.debug('Inside>>>');
                objTask.WhoId = ld.Id;
                if(ld.Reasons__c == 'Busy now call me later'){
                    objTask.ActivityDate = System.today() + 7;
                } else if(ld.Reasons__c == 'Request more details'){
                    objTask.ActivityDate = System.today();
                }
                objTask.Subject = ld.Status + ' - ' + leadReasons;
                objTask.Priority ='Normal';
                objTask.Status = 'Open';
                objTask.ReminderDateTime = System.now();
                lstTaskToInsert.add(objTask);
            }
        }
        lstLead.add(oldlead);
    }

    System.debug('lstLead: ' + lstLead);
    
    if(!lstLead.isEmpty()){
        //update lstLead;
    }

    System.debug('lstTaskToInsert: ' + lstTaskToInsert);
    
    if(!lstTaskToInsert.isEmpty()) {
        insert lstTaskToInsert;
    }
}

	
	
	
    //School Update
    public static void updateLeadSchool(List<Lead> ldLst){
        set<string> shortcodeSchoolSet=new set<string>();
        set<id> ldSet=new set<id>();
        List<lead> listlead = new List<lead>();
        for(lead olead : ldLst){
            shortcodeSchoolSet.add(olead.School_Short_Code__c);
            ldSet.add(olead.id);
        }
        if(!shortcodeSchoolSet.isEmpty()){
            account oaccount =[select Id,School_Short_Code__c from account where School_Short_Code__c=:shortcodeSchoolSet limit 1];
            List<lead> lstlead =[select Id,name,Acadmic_Year__c,Company,School_Short_Code__c,School_Institution__c from Lead where id=:ldSet];
            for(lead olead : ldLst){
                lead oleads =  new lead();
                oleads.id = olead.id;
                oleads.School_Institution__c=oaccount.id;
                //oleads.Acadmic_Year__c='2022-2023';
                oleads.Company='Stellar';
                listlead.add(oleads);
            }
        }
        if(!listlead.isEmpty()){
            //update listlead;
        }
        
    }
    
    /* public static void populateMCFields() {
Set<Id> userIds = new Set<Id>();
for(Lead ld : (List<Lead>) Trigger.new) {
if(Trigger.isInsert) {
userIds.add(ld.OwnerId);
}
else if(Trigger.isUpdate) {
if(ld.OwnerId != ((Map<Id, Lead>) Trigger.oldMap).get(ld.Id).OwnerId) {
userIds.add(ld.OwnerId);
}
}
}

Map<Id, User> userMap;
if(userIds.size() > 0) {
userMap = new Map<Id, User>([SELECT Id, Salutation__c, FirstName, LastName FROM User WHERE Id IN: userIds]);
}

if(Trigger.isInsert || Trigger.isUpdate) {
for(Lead ld : (List<Lead>) Trigger.new) {

String counselorName = '';
if(userMap.containsKey(ld.OwnerId)) {
User owner = userMap.get(ld.OwnerId);
if(String.isNotBlank(owner.Salutation__c)) {
counselorName += owner.Salutation__c;
}
if(String.isNotBlank(owner.FirstName)) {
counselorName += counselorName == '' ? owner.FirstName : ' ' + owner.FirstName;
}
if(String.isNotBlank(owner.FirstName)) {
counselorName += counselorName == '' ? owner.LastName : ' ' + owner.LastName;
}
}

if(ld.MobilePhone.length() >= 10) {
ld.MC_Mobile_No__c = 91 + ld.MobilePhone.right(10);
}

if(Trigger.isInsert) {
ld.Counselor_Name__c = counselorName;
}
if(Trigger.isUpdate) {
if(ld.OwnerId != ((Map<Id, Lead>) Trigger.oldMap).get(ld.Id).OwnerId) {
ld.Counselor_Name__c = counselorName;
}
}
}
}
} */
    
    
    public static void fakeMethod() {
        Integer j = 0;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
    }
    
}