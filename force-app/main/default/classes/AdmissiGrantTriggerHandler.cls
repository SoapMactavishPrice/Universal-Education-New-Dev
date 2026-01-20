public class AdmissiGrantTriggerHandler {
    public static void updateCurrentStatus(List<Admission_Granted__c> listAdmissionGranted){
        system.debug('listAdmissionGranted ' + listAdmissionGranted);
        set<string> Admission_GrantedLeadId = new set<string>();
        List<Admission_Granted__c> lstAdmission_Granted = new List<Admission_Granted__c>();
        if(RecursiveTriComCurrStatusHandler.isFirstTime == true){
            for(Admission_Granted__c oAdmission_Granted : listAdmissionGranted){
                if(oAdmission_Granted.Status__c == 'Dormant'){
                    Admission_GrantedLeadId.add(oAdmission_Granted.Lead_ID__c);   
                }
            }
            system.debug('Admission_GrantedLeadId >> ' + Admission_GrantedLeadId);
            if(!Admission_GrantedLeadId.IsEmpty()){
                List<Lead> ldLists = [SELECT Id,Lead_ID__c,Current_Status__c FROM Lead where Lead_ID__c =:Admission_GrantedLeadId]; 
                List<Lead> listLead = new List<Lead>();
                for(Lead ld:ldLists){
                    Lead oLead = new Lead();
                    oLead.id = ld.id;
                    oLead.Current_Status__c = 'Dormant';    
                    listLead.add(oLead);
                }
                system.debug('listLead  ' + listLead);
                if(!listLead.isEmpty()){
                    RecursiveTriComCurrStatusHandler.isFirstTime = false;
                    update listLead;  
                }                 
            }
        }
    }
    
    public static void updateRemark(List<Admission_Granted__c> listAdmissionGranted,Map < Id, Admission_Granted__c > oMap)
    {
        List<Admission_Granted__c> toBeUpdate=new List<Admission_Granted__c>();
        for(Admission_Granted__c ag:listAdmissionGranted){
            Admission_Granted__c ags=oMap.get(ag.id);
            if((ags.Concessions_Dependent__c!=ag.Concessions_Dependent__c)|| ( ags.Concessions_Independent__c!=ag.Concessions_Independent__c)){
                string str='';
                string strremark='';
                if(ag.Concessions_Dependent__c!=null || ag.Concessions_Independent__c!=null )
                {
                    str='The following additional concessions will be applied to the Tuition Fees: ';
                }
                {
                    if(ag.Concessions_Dependent__c!=null)
                    {
                        str+='\n' +ag.Concessions_Dependent__c;
                        strremark+=ag.Concessions_Dependent__c ;
                        
                    }
                    else
                    {
                        str=str; 
                        strremark=strremark;
                    }
                    
                    if(ag.Concessions_Dependent__c!=null)
                    {
                        if(ag.Concessions_Independent__c!=null){
                            str=str+'\n' +ag.Concessions_Independent__c;
                             strremark=strremark+';' +ag.Concessions_Independent__c;
                        }
                        else{
                            str=str;
                            strremark=strremark;
                        }
                        
                    }
                    else
                    {
                        if(ag.Concessions_Independent__c!=null){
                            str=str+ag.Concessions_Independent__c;
                             strremark=strremark+ag.Concessions_Independent__c;
                        }else{
                            str=str;
                             strremark=strremark;
                        }
                    }
                    
                    
                    Admission_Granted__c acc  = new Admission_Granted__c(Id = ag.Id);
                    str=str.replace(';', '\n');
                    acc.Concessions_Remark__c=str;
                    acc.Ether_Remark__c=strremark;
                    
                    toBeUpdate.add(acc);
                }
                
            }
            if(toBeUpdate.Size()>0)
            {
                update toBeUpdate;
            }
        }
    }
   /* public static void fakeMethod() {
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
    } */
}