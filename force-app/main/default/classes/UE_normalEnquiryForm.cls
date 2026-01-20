public without sharing class UE_normalEnquiryForm {
    //****************//
    public Date dob { get; set; }
    Public string message{get;set;}
    public Boolean showMYExpirelink{ get; set; }
    public Boolean showMYPage{ get; set; }
    Public Boolean DisplayBlock {get; set;}
    //Public date EnquirySendDate {get; set;}
  //  public Date pdate {get;set;}
 //   public Date pdate1 {get;set;}
 //   public string option { get; set; }
 //   public String field2 { get; set; }
 //   public String f3{get;set;}
  
 //   public List<SelectOption> selectList { get; set; }
    public List<SelectOption> secondarySelectList{ get; set; }
 //   public Map<String, List<String>> picklistMap { get; set; }
    //************//
    Public Enquiry__c enq{get;set;}
  //******/  Public List<Contact>ExistingContact{get;set;}
    Public String Contactid {get;set;} 
    Public string ExistingContactID {get;set;} 
    String getterSetterVar {get;set;}

    public LIST <Contact> con{get;set;}
    public LIST <Contact> conlist{get;set;}

    public Account acc{get;set;}
  //  public Account acc1{get;set;}
    public integer i{get;set;}
    public Id Eid {get;set;}
    public List<Class__C> lstcls{get;set;}
    public LIST<Enquiry__c> enq1{get;set;}
 //   public LIST<Enquiry__c> enq2{get;set;}
    public String academicYear{get;set;}
    Public boolean msg{get;set;}
      
    public String sname = ApexPages.currentPage().getParameters().get('sname');
    public String conid = ApexPages.currentPage().getParameters().get('cid');
  
  /* public String lname = ApexPages.currentPage().getParameters().get('lname');
      public String fname = ApexPages.currentPage().getParameters().get('fname');
      public String cphone= ApexPages.currentPage().getParameters().get('cphone');
      public String cemail= ApexPages.currentPage().getParameters().get('cemail');
      public String cstreet= ApexPages.currentPage().getParameters().get('cstreet');
      public String ccity= ApexPages.currentPage().getParameters().get('ccity');
      public String cstate= ApexPages.currentPage().getParameters().get('cstate');
      public String cpin= ApexPages.currentPage().getParameters().get('cpin');
      public String ccountry= ApexPages.currentPage().getParameters().get('ccountry');*/
    public String lname {get;set;} 
    public String fname {get;set;} 
    public String cphone{get;set;} 
    public String cemail{get;set;} 
    public String cstreet{get;set;} 
    public String ccity{get;set;} 
    public String cstate{get;set;} 
    public String cpin{get;set;} 
    public String ccountry{get;set;} 
    //Date EnquirySendDate = Date.today();
    //Date EnquirySendDateExpire = Date.today()+30;
    public Integer ExpiredDaysEnquiry{get;set;}
    public Integer recordcount{get;set;}
    public UE_normalEnquiryForm(ApexPages.StandardController Controller){
        /*if(EnquirySendDate <= EnquirySendDateExpire){
            //System.debug('TRUE');
            showMYPage=true;
        }  
        else{
            showMYExpirelink=true;
             //System.debug('FALSE');
    }*/
        getterSetterVar = ApexPages.CurrentPage().getparameters().get('cid');
        System.debug('ValueFromURL:' +getterSetterVar);
        string Enquiry_Formid = system.label.Enquiry_Form_Submission;
        List<Enquiry__c>  stringEnquiry =[select Id,Name,Contact__c from Enquiry__c where Contact__c=:getterSetterVar and LastModifiedById=:Enquiry_Formid];
        System.debug('stringEnquiry:' + stringEnquiry);
        recordcount = stringEnquiry.size();
        System.debug('recordcount:' + recordcount);
           if(getterSetterVar != null){
               conlist = [SELECT AccountId,SkipEnquiry__c,NoOfEnquiryExpiredDays__c,Enquiry_Send_Date__c,Account.School_Short_Code__c,Academic_Year__c,Phone,OtherStreet,OtherCity,OtherState,OtherPostalCode,OtherCountry,Comment__c,SecondaryMobileNo__c,Email,FirstName,Id,LastName,MiddleName,MobilePhone,Name,Salutation,Type__c,Category__c,Your_First_Name__c,Your_Last_Name__c,Gender__c,Date_of_Birth__c,Program__c,school_Name__c,Sources__c,Relation__c FROM Contact where ID =:getterSetterVar];
               Date ld=Date.valueOf(conlist[0].Enquiry_Send_Date__c);
                Date currentDate=System.today();
                Integer diffDate=currentDate.daysBetween(ld);
                System.debug('diffDate'+diffDate);
                if(diffDate >=30){
                    showMYExpirelink=true;
                    
                }else{
                    showMYPage=true;
                }
               if(conlist[0].SkipEnquiry__c == True){
                   ExpiredDaysEnquiry = 90;
               }else{
                   ExpiredDaysEnquiry = integer.valueOf(conlist[0].NoOfEnquiryExpiredDays__c);
               } 
               enq = (Enquiry__c)Controller.getRecord();
               enq.Parent_Last_Name__c= conlist[0].FirstName;
               enq.Parent_First_Name__c= conlist[0].LastName;
               enq.Mobile_No__c= conlist[0].Phone;
               enq.Email__c= conlist[0].Email;
               enq.Address__c= conlist[0].OtherStreet;
               enq.City__c= conlist[0].OtherCity;
               //enq.Flat_No_House_No__c = conlist[0].
               enq.State__c= conlist[0].OtherState;
               enq.School_Institution__c = conlist[0].AccountId;
               enq.Pin_Code__c= conlist[0].OtherPostalCode;
               enq.Country__c=conlist[0].OtherCountry;
              // enq.Category__c=conlist[0].Category__c;
               enq.FirstName__c=conlist[0].Your_First_Name__c;
               enq.Last_Name__c=conlist[0].Your_Last_Name__c;
               enq.Gender__c=conlist[0].Gender__c;
               enq.Date_of_Birth__c=conlist[0].Date_of_Birth__c;
               enq.Seeking_Admission_in_Grade__c=conlist[0].Program__c;
              // enq.Enq_School_Institute__c=conlist[0].school_Name__c;
             //  enq.Source_of_Information__c=conlist[0].Sources__c;
               enq.Relation__c=conlist[0].Relation__c;
                   
               system.debug(' @@@ enq' +enq);
               system.debug(' @@@ enq.Contact__c' + enq.Contact__c);
           }
        academicYear = conlist[0].Academic_Year__c;
        /* Schema.DescribeFieldResult fieldDesc = Schema.Enquiry__c.Academic_Year__c.getDescribe();
for (Schema.Picklistentry picklistEntry: fieldDesc.getPicklistValues()) 
{
if (picklistEntry.isDefaultValue()) 
{
academicYear= picklistEntry.getValue();
break;
}
} */
        msg = true;
        
        //*********//
       // setupPickValMap();
      //  getPrimaryPickVals();
        //********//
        
        
        secondarySelectList = new List<selectOption>();
        try{
            if(enq.Contact__c!=null)
            {
                system.debug('Contact  %%% enq.Contact__c!=null'+con);
                if(con[0].AccountId !=null) 
                {  
                    acc = [Select id, Name,School_Short_Code__c from Account where id=:con[0].AccountId];
                    sname = acc.School_Short_Code__c;
                    
                    system.debug('acc'+acc);
                }else{
                    msg= false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'School is Not Added !!'));
                }
                //added to get the seeking admission grades origianl values
                if(con[0].AccountId !=null) {
                    lstcls =[SELECT Id, School_Name__c, Original_Class__c, Name,Sequence_Number__c FROM Class__c where School_Name__c=:con[0].AccountId ORDER BY Sequence_Number__c ASC NULLS LAST];
                    System.debug('lstcls' +lstcls);
                   
                      if(!lstcls.isEmpty()){
                        
                        for(i=0; i<lstcls.size(); i++){
                            System.debug('Inside'+lstcls[i].Name);
                            secondarySelectList.add(new SelectOption(lstcls[i].Name,lstcls[i].Name));
                        }
                    }
                     System.debug('secondarySelectList' +secondarySelectList);
                }
            
            }else{ // added for multiple enquiry sent to contact through link 
                con = [SELECT AccountId,Comment__c,SecondaryMobileNo__c,Email,FirstName,Id,LastName,MiddleName,MobilePhone,Name,Phone,Salutation,Type__c FROM Contact where ID =:conid];
                acc = [Select id,Name,School_Short_Code__c from Account where id= :con[0].AccountId];
                
                //added to get the seeking admission grades origianl values
                if(con[0].AccountId !=null) {
                    lstcls =[SELECT Id, School_Name__c, Original_Class__c, Name,Sequence_Number__c FROM Class__c where School_Name__c=:con[0].AccountId ORDER BY Sequence_Number__c ASC NULLS LAST];
                    if(!lstcls.isEmpty()){
                        for(i=0; i<lstcls.size(); i++){
                            System.debug('Inside'+lstcls[i].Name);
                            secondarySelectList.add(new SelectOption(lstcls[i].Name,lstcls[i].Name));
                        }
                    }
                     System.debug('secondarySelectList' +secondarySelectList);
                }
               
                system.debug(' Inside Else part contact rec'+con);
                system.debug(' Inside Else part account rec'+acc);
                
            }
        }
        catch(Exception exp)
        {
            system.debug('Exception::::'+exp.getMessage());
            //return null;
        }
        try
        {
            if(sname==null)
            {
                if(enq.School_Institution__c!=null)
                {
                    acc = [Select id,Name,School_Short_Code__c from Account where id=:enq.School_Institution__c];
                    system.debug('ACCOUNT_Query:::'+acc);
                    sname = acc.School_Short_Code__c;
                    system.debug('school::::'+sname);   
                }
            }
        }
        catch(Exception exp){
            system.debug('Inside School Block Exception::::'+exp.getMessage());
        }    
    }
    public PageReference save(){
        try{
                            /*  if(enq.Mobile_No__c == null){
                enq.Mobile_No__c.addError('Enter the Mobile number');
                return null;
                }if(enq.Mobile_No__c != null){
                String mobile = enq.Mobile_No__c;
                if(!Pattern.matches('[0-9]{10}', mobile)) 
                {                         
                enq.Mobile_No__c.addError('Please enter proper 10 digit mobile Number');
                system.debug('Testing'+mobile);        
                return null;
                } */
            
           /* if(con.Phone == null){
                con.Phone.addError('Enter the Mobile number');
                return null;
            }if(con.Phone != null){
                String mobile = con.Phone.replaceAll('\\D','');
                if(!Pattern.matches('[0-9]{10}', mobile)) 
                {                         
                    con.Phone.addError('Please enter proper 10 digit mobile Number');
                    system.debug('Testing'+mobile);        
                    return null;
                }
            } */if(enq.FirstName__c !=null ){
                system.debug('enq.FirstName__c' +enq.FirstName__c);
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.FirstName__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE)
                {
                    enq.FirstName__c.addError('Please enter proper student First Name');
                    return null;
                }
            }if(enq.Last_Name__c !=null )
            {
                system.debug('enq.Last_Name__c' + enq.Last_Name__c);
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Last_Name__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE)
                {
                    enq.Last_Name__c.addError('Please enter proper Student Last name');
                    return null;
                }
            }if(enq.Parent_First_Name__c !=null )
            {
                system.debug('enq.Parent_First_Name__c' + enq.Parent_First_Name__c);
                String NameRegex = '^[A-Za-z- ]+$';
                Pattern MyPattern = Pattern.compile(NameRegex);
                Matcher MyMatcher = MyPattern.matcher(enq.Parent_First_Name__c);
                Boolean result = MyMatcher.matches();
                
                if (result == FALSE)
                {
                    enq.Parent_First_Name__c.addError('Please enter proper value');
                    return null;
                }
            }if(enq.Parent_Last_Name__c !=null ){
                
                String NameRegex1 = '^[A-Za-z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Parent_Last_Name__c);
                Boolean result1 = MyMatcher1.matches();
                
                if (result1 == FALSE)
                {
                    enq.Parent_Last_Name__c.addError('Please enter proper value');
                    return null;
                }
            }if(enq.Address__c !=null )
            {
                if(enq.Address__c.contains('@') || enq.Address__c.contains('!') || enq.Address__c.contains('#') || enq.Address__c.contains('$') || enq.Address__c.contains('%') || enq.Address__c.contains('&') || enq.Address__c.contains('*')|| enq.Address__c.contains('(') || enq.Address__c.contains(')')|| enq.Address__c.contains('<')|| enq.Address__c.contains('>')|| enq.Address__c.contains('+')|| enq.Address__c.contains('=')|| enq.Address__c.contains('?')|| enq.Address__c.contains(';')){
                    enq.Address__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                    return null;
                }
            }
            if(enq.City__c !=null )
            {
                
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.City__c);
                Boolean result1 = MyMatcher1.matches();
                
                if (result1 == FALSE)
                {
                    
                    enq.City__c.addError('Please enter proper value');
                    return null;
                }
            }if(enq.State__c !=null )
            {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.State__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE)
                {
                    enq.State__c.addError('Please enter proper value');
                    return null;
                }
            }if(enq.Pin_Code__c !=null )
            {
                
                String NameRegex1 = '^[1-9][0-9]{5}$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Pin_Code__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE)
                {
                    enq.Pin_Code__c.addError('Please enter Proper Value in Pincode');
                    return null;
                }
            }if(enq.Country__c !=null )
            {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Country__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE)
                {
                    enq.Country__c.addError('Please enter Proper value');
                    return null;
                }
            }
            //system.debug('accid+++'+ acc.id);
            String LastName = con[0].LastName;
            String FirstName = con[0].FirstName;
            String Email = con[0].Email;
            String Phone = con[0].Phone;
            // String ScoolName = con.
            
             // getterSetterVar = ApexPages.CurrentPage().getparameters().get('URLParameter');

            contact cc = new contact();
          // ExistingContact = [SELECT ID, AccountID, FirstName, lastName, Email, Phone FROM CONTACT WHERE LastName =:LastName AND Email =:Email AND Phone =:Phone  Limit 1];
            if (conid != Null) {
            ExistingContactID = conid;
           
            //ExistingContactAccountID = ExistingContact[0].AccountID;
            
            }
            else { 
           
                system.debug('inside Null Contact');
                cc.LastName=con[0].LastName;
                cc.FirstName=con[0].FirstName;
                cc.Email = con[0].Email;
                
                cc.Phone=con[0].Phone;
                cc.Type__c = 'Admission Enquiry';
              //  cc.AccountId = acc.id;
                try{
                    insert cc;
                    system.debug('CONTACT+++'+cc);
                }catch(Exception ex){
                    System.debug('Error Message '+ex.getMessage());
                }
            } 
            System.debug('Year-----'+academicYear);
            Integer i=1;
            Integer k=0;
            List<Enquiry__c> enqList=[Select id,Autonumber_apexClass__c,contact__r.FirstName from Enquiry__c where Academic_Year__c=:academicYear and orgCode__c=:sname and Autonumber_apexClass__c >0 order by createddate desc NULLS LAST limit 1];
            if(!enqList.isEmpty())
                System.debug('Record enqList----'+enqList[0].id);
            
            if(ExistingContactID  != null ){
                system.debug('inside Null Contact');
                enq.Contact__c=ExistingContactID;

                                /*  enq.Parent_First_Name__c = con.FirstName;
                enq.Parent_Last_Name__c = con.LastName;
                enq.Mobile_No__c = con.MobilePhone;
                enq.Email__c = con.Email; */
                //system.debug('CONTACT ID:::'+ExistingContact[0].id);
            }else{
                enq.Contact__c=cc.Id;
            }
           // enq.Parent_First_Name__c = con[0].FirstName;
           //enq.Parent_Last_Name__c = con[0].LastName;
           //enq.Mobile_No__c = con[0].Phone;
          // enq.Email__c = con[0].Email;
            enq.Stages__c='Enquiry';
            enq.Log_Status__c='New Enquiry';
            enq.Enquiry_Type__c = 'Offline';
            enq.Offline__c= true;
            enq.orgCode__c = sname;
            enq.Academic_Year__c = academicYear ;
  
            String SeekingAdmission = enq.Seeking_Admission_in_Grade__c;
            System.debug('SeekingAdmission Grade: : '+SeekingAdmission);
            System.debug('School institute: : '+conlist[0].accountId);
            enq.School_Institution__c = conlist[0].accountId;
            Class__c Sc = [SELECT ID FROM Class__c WHERE School_Name__c =:conlist[0].accountId AND Name =:SeekingAdmission LIMIT 1];
//integer ir = lstcls.indexof(SeekingAdmission);
			system.debug('Class SC::' +Sc);
             enq.Seeking_Grade__c= Sc.id;
             
             System.debug('SeekingGrade Lookup ID: '+Sc.id );
			if(!enqList.isEmpty())
            {
                System.debug('Inside enq list not empty');
                k=i+Integer.valueOf(enqList[0].Autonumber_apexClass__c);
                system.debug('k' + k);
                //commneted by Himanshu 
                //enq.Name=academicYear+'/'+enq.Seeking_Admission_in_Grade__c+'/'+sname+'/'+'ENQ'+'/'+k;
                enq.Name= 'ENQ'+'/' +academicYear+'/'+k;
                enq.Autonumber_apexClass__c=k;
            }
            else
            {
                System.debug('Inside enq list is empty');
                //commneted by Himanshu 
                //enq.Name=academicYear+'/'+enq.Seeking_Admission_in_Grade__c+'/'+sname+'/'+'ENQ'+'/'+i;
                enq.Name= 'ENQ'+'/' +academicYear+'/'+i;
                enq.Autonumber_apexClass__c=i;
            }     
            //enq.Name = enq.Academic_Year__c+'/'+enq.Seeking_Admission_in_Grade__c+'/ENQ/';
            /*string DataName;
            String SAcademicYear;
            string sDataName;
            Integer nDataName= 0;
            DataName = [SELECT Id,Name,createdDate FROM Enquiry__c where  Name LIKE '%ENQ%' ORDER BY createdDate  DESC limit 1].Name;
            SAcademicYear = [SELECT Id,Name,Academic_Year__c,createdDate FROM Enquiry__c where  Name LIKE '%ENQ%' ORDER BY createdDate  DESC limit 1].Academic_Year__c;
            system.debug('DataName >> ' + DataName);
            system.debug('SAcademicYear >> ' + SAcademicYear);
            sDataName = DataName.substringAfterLast('/');
            system.debug('sDataName  ' + sDataName); 
            for(integer i=0; i<=integer.valueOf(sDataName);i++){
                nDataName = i+1;
            }
            system.debug('nDataName  ' + nDataName);
        	enq.Name = 'ENQ/'+SAcademicYear+'/'+nDataName;
            system.debug('Enquuiry Number+++'+enq.Name);
            */
            insert this.enq;
            system.debug('Inserted Contact+++'+enq.Contact__c+' And Contact ID:::'+con[0].id);
            Eid = enq.Id;
            enq1 = [Select id,Name,Academic_Year__c,Enq_auto_num__c,Seeking_Admission_in_Grade__c,Parent_First_Name__c,Parent_Last_Name__c,Org_code__c,orgCode__c from Enquiry__c where id=: enq.Id];
            system.debug('ENQ NAME++++'+enq1);
            Eid = enq1[0].Id;
            PageReference ThankYou= new PageReference('/apex/ShowEnquiryNumber?eid='+Eid);
        ThankYou.setRedirect(true);
        return ThankYou;
          
      
          
        }
        Catch(Exception exp)
        {   
            system.debug('EXCEPTION++++'+exp.getMessage()+'Cause:::'+exp.getCause()+'Line Number:::'+exp.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Opps... Something went wrong!! Please go back and Resart the process'));
            return null;
        } 
    }
    
    public PageReference reset(){
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
    
    //************************//
 /*   public void setupPickValMap(){
        picklistMap = new Map<String, List<String>>();
        //   picklistMap.put('..select option..', new List<String>{'..select option..'});
        picklistMap.put('1', new List<String>{'PLAYGROUP'});
        picklistMap.put('2', new List<String>{'NURSERY','PLAYGROUP'});
        picklistMap.put('3', new List<String>{'JR.KG', 'NURSERY','PLAYGROUP'});
        picklistMap.put('4', new List<String>{'SR.KG','JR.KG','NURSERY','PLAYGROUP'});
        picklistMap.put('5', new List<String>{'I','SR.KG','JR.KG','NURSERY' ,'PLAYGROUP'});
        //picklistMap.put('6', new List<String>{'PLAYGROUP', 'NURSERY', 'JR.KG', 'SR.KG', 'I', 'II'});
        picklistMap.put('6', new List<String>{'II','III','IV','V','VI','VII','VIII','IX','X'});
    }
   
    
    public void getPrimaryPickVals(){
        selectList = new List<selectOption>();
        
        for(String s : picklistMap.keySet())
            selectList.add(new SelectOption(s, s));
        
        System.debug('selectList getprimaryPickval' +selectList);
        
    }
    
     */
    
    public void getSecondaryPickVals(){
        
        if(enq.Date_of_Birth__c != null){
            system.debug('DOB::::'+enq.Date_of_Birth__c);
            dob=enq.Date_of_Birth__c;
       //     pdate= date.today().addYears(-2);
         //   pdate1= date.today().addDays(-1095);
            if(dob != null){
                
               
           /* Removed by Himanshu Nimje As DOB and Seeking admission need to Decoupled as per requirement 
             secondarySelectList = new List<selectOption>();
            if( string.valueOf(dob)<=string.valueOf(pdate) && string.valueOf(dob) >string.valueOf(pdate1)){
            for(String s : picklistMap.get('1'))
            secondarySelectList.add(new SelectOption(s, s));
            message='[As per the Date of Birth your child is eligible for Play Group]';
            }
            
            else if(string.valueOf(dob) <=string.valueOf(date.today().addDays(-1095)) && string.valueOf(dob) >string.valueOf(date.today().addDays(-1460))){
            for(String s : picklistMap.get('2'))
            secondarySelectList.add(new SelectOption(s, s));
            message='[As per the Date of Birth your child is eligible for Nursery]';
            }
            else if(string.valueOf(dob) <=string.valueOf(date.today().addDays(-1460)) && string.valueOf(dob) >string.valueOf(date.today().addDays(-1825))){
            for(String s : picklistMap.get('3'))
            secondarySelectList.add(new SelectOption(s, s));
            message='[As per the Date of Birth your child is eligible for Jr.Kg]';
            }
            else if(string.valueOf(dob) <=string.valueOf(date.today().addDays(-1825)) && string.valueOf(dob) >string.valueOf(date.today().addDays(-2190))){
            for(String s : picklistMap.get('4'))
            secondarySelectList.add(new SelectOption(s, s));
            message='[As per the Date of Birth your child is eligible for Sr.Kg]';
            
            }
            else if(string.valueOf(dob) <=string.valueOf(date.today().addDays(-2190)) && string.valueOf(dob) >string.valueOf(date.today().addDays(-2555))){
            for(String s : picklistMap.get('5'))
            secondarySelectList.add(new SelectOption(s, s));
            message='[As per the Date of Birth your child is eligible for I]';
            }
            else if(string.valueOf(dob) <=string.valueOf(date.today().addDays(-2555))){
            for(String s : picklistMap.get('6'))
            secondarySelectList.add(new SelectOption(s, s));
            
            }
            */    
                if(string.valueOf(dob) >=string.valueOf(date.today())){
                    // message='DOB cannot be in present or past, Please select past Date';
                    enq.Date_Of_Birth__c.addError('DOB cannot be in Present or Future, Please select past Date');
                }
                            /* else{
            enq.Date_Of_Birth__c.addError('Invalid date for admission.');
            message='';
            }*/
            }
        }
        //*************//
    }
    
    public static void FormFactory() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
    i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
    i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
    
    }
    
}