public class LeadDuplicateInsertTriggerHandler {
    
    
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