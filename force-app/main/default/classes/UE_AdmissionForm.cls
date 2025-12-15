public class UE_AdmissionForm {
    
    Public Application_Form__c adf{get;set;}
    public Contact con{get;set;}
    public Account acc{get;set;}
    public Admission_Form__c form{get;set;}
    public LIST<Admission_Form__c> app{get;set;}
    public boolean editMode{get;set;}
    public String academicYear{get;set;}
    public String accountName{get;set;}
    
    public UE_AdmissionForm(ApexPages.StandardController Controller){
        form = (Admission_Form__c)Controller.getRecord();
        
        Schema.DescribeFieldResult fieldDesc = Schema.Admission_Form__c.Academic__c.getDescribe();
        for (Schema.Picklistentry picklistEntry: fieldDesc.getPicklistValues()) 
        {
            if (picklistEntry.isDefaultValue()) 
            {
                academicYear= picklistEntry.getValue();
                break;
            }
        } 
        
        
        
        editMode = false;
        
        adf=new Application_Form__c();
        try{
            if(form.Application_Form__c!=null)
            {    
                adf = [SELECT Academic_Year__c,Address__c,Adhaar_Card_No__c,Father_Annual_Income__c,Mother_Anual_Income__c,First_Name__c,
                       Application_Form_Declaration__c,Name,Birth_Place__c,Blood_Group__c,Father_Business_Address__c,
                       Mother_Business_Address__c,Father_Business_Contact__c,Mother_Business_Contact__c,Category__c,Count__c,
                       Do_have_another_child_with_us__c,Email_Address__c,Guardian_Email_ID__c,Enquiry__c,Enquiry_Number__c,
                       Expiry_Date__c,Father_Datail_captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_Occupation__c,
                       Father_Phone__c,Father_Qualification__c,Mother_First_Name__c,Father_First_Name__c,Having_Children__c,
                       Mother_Last_Name__c,Last_Name__c,Guardian_Mobile_No__c,Mobile_Number__c,Mother_Detail_Captured__c,
                       Mother_Email_Id__c,Mother_Occupation__c,Mother_Phone__c,Mother_Qualification__c,Mother_Tongue__c,
                       Guardian_Name__c,Father_Name_of_Organisation__c,Mother_Name_of_Organisation__c,Nationality__c,Passport_No__c,
                       Reason_of_this_School__c,Relationship__c,Religion__c,Residence_No__c,School_Short_Code__c,School_Institution__c,		
                       Seeking_Admission_for_another_Child__c,Seeking_Admission_in_Grade__c,Student_Name__c FROM Application_Form__c  where ID =:form.Application_Form__c];
                system.debug('Admission_Form_Detail::::'+adf);
                
                
                
            }
        }Catch(Exception exp){
            system.debug('Error Occured'+exp.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Something went wrong.'));
        }
    }
    public PageReference save(){
        try{
            System.debug('Inside the Try Block');
            
            	Integer i=1;
            	Integer k=0;
                List<Admission_Form__c> appList=[Select id,Autonumber_apexClass__c from Admission_Form__c where Academic__c=:academicYear and School_Short_Code__c=:form.School_Short_Code__c and Autonumber_apexClass__c >0 order by createddate desc NULLS LAST limit 1];
                if(!appList.isEmpty())
                System.debug('Record----'+appList[0].id);
                
                if(!appList.isEmpty())
                {
                    
                    k=i+Integer.valueOf(appList[0].Autonumber_apexClass__c);
                    form.Name=adf.Academic_Year__c+'/'+adf.Seeking_Admission_in_Grade__c+'/'+adf.School_Short_Code__c+'/'+'REG'+'/'+k;
                    form.Autonumber_apexClass__c=k;
                }
                else
                {
                    form.Name=adf.Academic_Year__c+'/'+adf.Seeking_Admission_in_Grade__c+'/'+adf.School_Short_Code__c+'/'+'REG'+'/'+i;
                    form.Autonumber_apexClass__c=i;
                    system.debug('number:::'+form.Name);
                }
            
            
            
            form.Enquiry_Number__c=adf.Enquiry_Number__c;						//Enquiry No
            form.First_Name__c = adf.First_Name__c;
            form.Last_Name__c = adf.Last_Name__c;
            form.Academic__c = adf.Academic_Year__c;
            form.Address__c=adf.Address__c;
            form.Adhaar_Card_No__c=adf.Adhaar_Card_No__c;
            form.fatherAnnualincome__c=adf.Father_Annual_Income__c;
            //form.Name= adf.Name;
            form.Application_Form__c = adf.id;
            form.motherAnnual_Income__c=adf.Mother_Anual_Income__c;
            form.Birth_Place__c=adf.Birth_Place__c;
            form.Blood_Group__c=adf.Blood_Group__c;
            form.Business_Address__c=adf.Father_Business_Address__c;
            form.motherBusiness_Address__c=adf.Mother_Business_Address__c;
            form.Business_Address__c=adf.Father_Business_Address__c;
            form.fatherBusiness_Contact__c=adf.Father_Business_Contact__c;
            form.motherBusiness_Contact__c=adf.Mother_Business_Contact__c;
            form.Category__c=adf.Category__c;
          	form.Application_No__c = adf.Name;										//Application No.
            form.Email_Address__c=adf.Email_Address__c;
            form.GuardianEmail_Id__c=adf.Guardian_Email_ID__c;
            form.GuardianMobile_No__c=adf.Guardian_Mobile_No__c;
            form.GuardianName__c=adf.Guardian_Name__c;
            form.Expiry_Date__c=adf.Expiry_Date__c;
            form.Father_Detail_Captured__c=adf.Father_Datail_captured__c;
            form.Father_Email_Id__c=adf.Father_Email_Id__c;
            form.Father_Last_Name__c=adf.Father_Last_Name__c;
            form.Father_occupation__c=adf.Father_Occupation__c;
            form.Father_Phone__c=adf.Father_Phone__c;
            form.Father_Qualification__c=adf.Father_Qualification__c;
            form.FatherFirst_Name__c=adf.Father_First_Name__c;
            form.fatherName_of_Organisation__c=adf.Father_Name_of_Organisation__c;
         	form.Registration_Date__c = system.today();
            form.Last_Name__c=adf.Last_Name__c;
            form.Mobile_Number__c=adf.Mobile_Number__c;
            form.fatherName_of_Organisation__c=adf.Father_Name_of_Organisation__c;
            form.Mother_Detail_Captured__c=adf.Mother_Detail_Captured__c;
            form.Mother_Email_Id__c=adf.Mother_Email_Id__c;
            form.motherLast_Name__c=adf.Mother_Last_Name__c;
            form.motherFirst_Name__c=adf.Mother_First_Name__c;
            form.Mother_Occupation__c=adf.Mother_Occupation__c;
            form.Mother_Phone__c=adf.Mother_Phone__c;
            form.Mother_Qualification__c=adf.Mother_Qualification__c;
            form.Mother_Tongue__c=adf.Mother_Tongue__c;
            form.motherName_of_Organisation__c=adf.Mother_Name_of_Organisation__c;
            form.Nationality__c=adf.Nationality__c;
            form.PassPort_No__c=adf.Passport_No__c;
            form.Reason_of_this_School__c=adf.Reason_of_this_School__c;
            form.Relationship__c=adf.Relationship__c;
            form.Religion__c=adf.Religion__c;
            form.Residence_No__c=adf.Residence_No__c;
            form.School_Institution__c=adf.School_Institution__c;
            form.Student_Name__c=adf.Student_Name__c;
           // form.Seeking_Admission_for_another_Child__c=adf.Seeking_Admission_for_another_Child__c;
            form.Seeking_Admission_in_Grade__c=adf.Seeking_Admission_in_Grade__c;
            form.School_Short_Code__c = adf.School_Short_Code__c;
           // form.Name= adf.Academic_Year__c+'/'+adf.Seeking_Admission_in_Grade__c+'/'+adf.School_Short_Code__c+'/REG/'+form.Count__c;		//Registration No
            
            insert form;
            
           	//app = [Select id, Name,Seeking_Admission_in_Grade__c,School_Short_Code__c,Enquiry_Number__c,Academic__c,Count__c from Admission_Form__c where id =:form.Id];
            //system.debug('ADDMISSION DATA:::::'+app);
            
            //app[0].Name = app[0].Academic__c+'/'+app[0].Seeking_Admission_in_Grade__c+'/'+app[0].School_Short_Code__c+'/REG/'+app[0].Count__c;
            //update app;
            //system.debug('Updated Addmission NUMBER:::::'+app[0].Name); 
            //    }
        }Catch(exception exp){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Admission and document both is not approved yet.'));
            system.debug('Exception'+exp.getMessage());
            
        }
        
        return new pageReference('/'+form.Id);
        // return new pageReference('/showApplicationNumber?eid='+app[0].Id);
        
        
    }
    public PageReference cancle(){ 
        return new PageReference('/'+adf.Id);
    }
    public void toggleEditMode(){
        editMode = !editMode;
        system.debug('EDITBUTTON+++'+editMode);
    }
    
}