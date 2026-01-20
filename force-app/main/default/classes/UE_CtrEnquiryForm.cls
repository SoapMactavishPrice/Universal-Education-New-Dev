public class UE_CtrEnquiryForm {
    /***** for Grade Validation based on DOB ****/
    public Date dob	{ get; set; }
    public Date pdate {get;set;}
    public Date pdate1 {get;set;}
    public string option { get; set; }
    public String field2 { get; set; }
    public String f3{get;set;}
    Public string message{get;set;}
    public List<SelectOption> selectList { get; set; }
    public List<SelectOption> secondarySelectList{ get; set; }
    public Map<String, List<String>> picklistMap { get; set; }
    /***** ***** **** ***** *****/
    
    Public Enquiry__c enq{get;set;}
    public Contact con{get;set;}
    public Account acc{get;set;}
    public id eid {get;set;}
    public String academicYear{get;set;}
    
    
    
    public LIST<Enquiry__c> enq1{get;set;}
    //public LIST<Enquiry__c> enq2{get;set;}
    
    public String sname = ApexPages.currentPage().getParameters().get('sname');
    
    public UE_CtrEnquiryForm(ApexPages.StandardController Controller){
        enq = (Enquiry__c)Controller.getRecord();
        
        Schema.DescribeFieldResult fieldDesc = Schema.Enquiry__c.Academic_Year__c.getDescribe();
        for (Schema.Picklistentry picklistEntry: fieldDesc.getPicklistValues()) 
        {
            if (picklistEntry.isDefaultValue()) 
            {
                academicYear= picklistEntry.getValue();
                break;
            }
        } 
        
        setupPickValMap();
        getPrimaryPickVals();
        
        con=new Contact();
        if(enq.Contact__c!=null)
        {    
            con = [SELECT AccountId,Comment__c,SecondaryMobileNo__c,Email,FirstName,Id,LastName,
                   MiddleName,MobilePhone,Name,Phone,Salutation,Type__c FROM Contact where ID =:enq.Contact__c];
            system.debug('$$$$$$'+con);
            if(con.AccountId !=null) 
            {  
                acc = [Select id, Name from Account where id=:con.AccountId];
            }
            
        }
        
    }
    public PageReference save(){
        try{
            if(enq.Contact__c==null)
            {
                if(enq.Mobile_No__c==null)
                {
                    enq.Mobile_No__c.addError('Enter the Mobile number');
                    return null;
                }if(enq.Mobile_No__c != null)
                {
                    String mobile = enq.Mobile_No__c.replaceAll('\\D','');
                    if(!Pattern.matches('[0-9]{10}', mobile)) 
                    {                         
                        enq.Mobile_No__c.addError('Please enter proper 10 digit mobile Number');
                        system.debug('Testing');        
                        return null;
                    } 
                }if(enq.FirstName__c !=null ){
                    
                    String NameRegex1 = '^[a-z A-Z]+$';
                    Pattern MyPattern1 = Pattern.compile(NameRegex1);
                    Matcher MyMatcher1 = MyPattern1.matcher(enq.FirstName__c);
                    Boolean result1 = MyMatcher1.matches();
                    system.debug('RESULT+++'+result1); 
                    
                    if (result1 == FALSE)
                    {
                        enq.FirstName__c.addError('Please enter proper student First Name');
                        return null;
                    }
                }if(enq.Last_Name__c !=null ){
                    
                    String NameRegex1 = '^[a-z A-Z]+$';
                    Pattern MyPattern1 = Pattern.compile(NameRegex1);
                    Matcher MyMatcher1 = MyPattern1.matcher(enq.Last_Name__c);
                    Boolean result1 = MyMatcher1.matches();
                    system.debug('RESULT+++'+result1); 
                    
                    if (result1 == FALSE)
                    {
                        enq.Last_Name__c.addError('Please enter proper Student Last name');
                        return null;
                    }
                }if(enq.Parent_First_Name__c !=null ){
                    String NameRegex = '^[A-Za-z]+$';
                    Pattern MyPattern = Pattern.compile(NameRegex);
                    Matcher MyMatcher = MyPattern.matcher(enq.Parent_First_Name__c);
                    Boolean result = MyMatcher.matches();
                    system.debug('RESULT+++'+result); 
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
                    system.debug('RESULT+++'+result1); 
                    
                    if (result1 == FALSE)
                    {
                        enq.Parent_Last_Name__c.addError('Please enter proper value');
                        return null;
                    }
                }if(enq.Email__c !=null ){
                    
                    String NameRegex1 = '[a-zA-Z0-9._]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}';
                    Pattern MyPattern1 = Pattern.compile(NameRegex1);
                    Matcher MyMatcher1 = MyPattern1.matcher(enq.Email__c);
                    Boolean result1 = MyMatcher1.matches();
                    system.debug('RESULT+++'+result1);
                    if (result1 == FALSE)
                    {
                        
                        enq.Email__c.addError('Please enter Proper Email Id');
                        return null;
                    }
                }if(enq.Address__c !=null )
                {
                    if(enq.Address__c.contains('@') || enq.Address__c.contains('!') || enq.Address__c.contains('#') || enq.Address__c.contains('$') || enq.Address__c.contains('%') || enq.Address__c.contains('&') || enq.Address__c.contains('*')|| enq.Address__c.contains('(') || enq.Address__c.contains(')')|| enq.Address__c.contains('<')|| enq.Address__c.contains('>')|| enq.Address__c.contains('+')|| enq.Address__c.contains('=')|| enq.Address__c.contains('?')|| enq.Address__c.contains(';')){
                        enq.Address__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                        return null;
                    }
                }if(enq.City__c !=null ){
                    
                    String NameRegex1 = '^[a-z A-Z]+$';
                    Pattern MyPattern1 = Pattern.compile(NameRegex1);
                    Matcher MyMatcher1 = MyPattern1.matcher(enq.City__c);
                    Boolean result1 = MyMatcher1.matches();
                    system.debug('RESULT+++'+result1); 
                    if (result1 == FALSE)
                    {
                        enq.City__c.addError('Please enter proper value');
                        return null;
                    }
                }if(enq.State__c !=null ){
                    
                    String NameRegex1 = '^[a-z A-Z]+$';
                    Pattern MyPattern1 = Pattern.compile(NameRegex1);
                    Matcher MyMatcher1 = MyPattern1.matcher(enq.State__c);
                    Boolean result1 = MyMatcher1.matches();
                    system.debug('RESULT+++'+result1); 
                    if (result1 == FALSE)
                    {
                        enq.State__c.addError('Please enter proper value');
                        return null;
                    }
                }if(enq.Pin_Code__c !=null ){
                    
                    String NameRegex1 = '^[1-9][0-9]{5}$';
                    Pattern MyPattern1 = Pattern.compile(NameRegex1);
                    Matcher MyMatcher1 = MyPattern1.matcher(enq.Pin_Code__c);
                    Boolean result1 = MyMatcher1.matches();
                    system.debug('RESULT+++'+result1);
                    if (result1 == FALSE)
                    {
                        enq.Pin_Code__c.addError('Please enter Proper Value in Pincode');
                        return null;
                    }
                }if(enq.Country__c !=null ){
                    
                    String NameRegex1 = '^[a-z A-Z]+$';
                    Pattern MyPattern1 = Pattern.compile(NameRegex1);
                    Matcher MyMatcher1 = MyPattern1.matcher(enq.Country__c);
                    Boolean result1 = MyMatcher1.matches();
                    system.debug('RESULT+++'+result1);
                    
                    if (result1 == FALSE)
                    {
                        enq.Country__c.addError('Please enter Proper value');
                        return null;
                    }
                }
                
                acc = [Select id,Name,School_Short_Code__c from Account where School_Short_Code__c =: sname];
                con.AccountId = acc.id;
                con.LastName=enq.Parent_Last_Name__c;
                con.FirstName=enq.Parent_First_Name__c;
                con.Email = enq.Email__c;
                con.Phone=enq.Mobile_No__c;
                con.Type__c = 'Admission Enquiry';
            }
            if(!test.isRunningTest())   insert con;
            system.debug('CONTACT+++'+con);
            
            System.debug('Year-----'+academicYear);
            Integer i=1;
            Integer k=0;
            List<Enquiry__c> enqList=[Select id,Autonumber_apexClass__c from Enquiry__c where Academic_Year__c=:academicYear and orgCode__c=:sname and Autonumber_apexClass__c >0 order by createddate desc NULLS LAST limit 1];
            if(!enqList.isEmpty())
                System.debug('Record----'+enqList[0].id);
            
            
            
            enq.Contact__c=con.Id;  
            enq.Stages__c='Enquiry';
            enq.Log_Status__c='New Enquiry';
            enq.Online__c=True;
            enq.orgCode__c = sname;
            
            if(!enqList.isEmpty())
            {
                
                k=i+Integer.valueOf(enqList[0].Autonumber_apexClass__c);
                enq.Name=academicYear+'/'+enq.Seeking_Admission_in_Grade__c+'/'+sname+'/'+'ENQ'+'/'+k;
                enq.Autonumber_apexClass__c=k;
            }
            else
            {
                enq.Name=academicYear+'/'+enq.Seeking_Admission_in_Grade__c+'/'+sname+'/'+'ENQ'+'/'+i;
                enq.Autonumber_apexClass__c=i;
            }
            
            system.debug('Enquuiry Number+++'+enq.Name);
            insert enq;
            
            return new pageReference('/ShowEnquiryNumber?eid='+enq.Id); 
            
        }Catch(Exception exp){
            system.debug('EXCEPTION::::'+exp.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Opps... Something went wrong!! Please go back and Resart the process'));
            return null;
        }
    }
    
    public PageReference cancle(){
        PageReference newpage = new PageReference('/enquiry/makeNewEnquiry?sname='+sname);
        newpage.setRedirect(true);
        return newpage;
    }
    
    public PageReference reset(){
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
    
    Public PageReference makeNewEnquiry(){
        String sid= sname;
        PageReference newpage = new PageReference('/enquiry/UE_AdmissionFormVF?sname='+sname);
        newpage.setRedirect(true);
        return newpage;
        
    }
    
    Public PageReference forgotEnquiry(){
        
        PageReference newpage = new PageReference('/enquiry/forgetEnquiryNumber?sname='+sname);
        newpage.setRedirect(true);
        return newpage;
        
    }
    //Method for ForgetEnquiry ?
    Public PageReference getEnquiryNumber(){
        
        if(enq.Mobile_No__c == null && enq.Email__c == null)
        {
            enq.Mobile_No__c.addError('Enter the registered Mobile number');
            enq.Email__c.addError('Enter the registered Email ID');
            
            return null;
        }
        if(enq.Mobile_No__c != null)
        {
            String mobile = enq.Mobile_No__c.replaceAll('\\D','');
            
            if(!Pattern.matches('[0-9]{10}', mobile)) 
            {                         
                enq.Mobile_No__c.addError('Please enter proper 10 digit mobile Number');
                system.debug('Testing');        
                return null;
            } 
        }
        
        if(enq.Email__c != null)
        {
            String NameRegex1 = '[a-zA-Z0-9._]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}';
            Pattern MyPattern1 = Pattern.compile(NameRegex1);
            Matcher MyMatcher1 = MyPattern1.matcher(enq.Email__c);
            Boolean result1 = MyMatcher1.matches();
            system.debug('RESULT+++'+result1);
            if (result1 == FALSE)
            {
                
                enq.Email__c.addError('Please enter Proper Email Id');
                return null;
            } 
        }
        try{
            if((enq.Mobile_No__c == null && enq.Email__c == null) || (enq.Mobile_No__c == '' && enq.Email__c == ''))
            {
                enq.Mobile_No__c.addError('Please enter proper 10 digit mobile Number');
                enq.Email__c.addError('Please enter proper Email ID');
                return null;
            }
            if(enq.Mobile_No__c != null || enq.Email__c != null )
            {
                if(enq.Mobile_No__c != null)
                {
                    String mobile = enq.Mobile_No__c.replaceAll('\\D','');
                    
                    if(!Pattern.matches('[0-9]{10}', mobile)) 
                    {                         
                        enq.Mobile_No__c.addError('Please enter proper 10 digit mobile Number');
                        system.debug('Testing');        
                        return null;
                    } 
                }
                if(enq.Email__c !=null ){
                    
                    if(!Pattern.matches('[a-zA-Z0-9._]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', enq.Email__c)){
                        enq.Email__c.addError('Please enter proper Email ID');
                        system.debug('Testing');        
                        return null;
                    }
                    
                }
                
                
                if(enq.Mobile_No__c != null)
                {
                    string mob = enq.Mobile_No__c.replaceAll('\\D','');
                    enq1=[Select id,Name,Academic_Year__c,Mobile_No__c,School_Name__c,Student_Full_Name__c,Seeking_Admission_in_Grade__c,Parent_First_Name__c,
                          Parent_Last_Name__c,Org_code__c,Email__c,CreatedDate,orgCode__c from Enquiry__c where Mobile_No__c=: mob and orgCode__c=:sname ORDER BY CreatedDate ];
                    
                    if(enq1.size()==0)
                    {
                        system.debug('Enquiry Mobile++++'+enq1);
                        enq.Mobile_No__c.addError('No record Found!! Please fill the registered Mobile Number with us.');
                        return null;
                    }
                    
                }
                if(enq.Email__c != null)
                {
                    enq1=[Select id,Name,Academic_Year__c,Mobile_No__c,School_Name__c,Student_Full_Name__c,Seeking_Admission_in_Grade__c,Parent_First_Name__c,
                          Parent_Last_Name__c,Org_code__c,Email__c,CreatedDate,orgCode__c from Enquiry__c where Email__c=: enq.Email__c and orgCode__c=:sname ORDER BY CreatedDate ];
                    if(enq1.size()==0)
                    {
                        system.debug('Enquiry Email++++'+enq1);
                        enq.Email__c.addError('No record Found!! Please fill the registered Email ID');
                        return null;
                    }
                }
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'kindly provide one of the value of Email or Mobile Number'));
                return null;
            }
            
        }catch(Exception exp){
            system.debug('ERROR::::'+exp.getMessage());
            enq.Mobile_No__c.addError('No record found !! Please Enter correct Mobile Number.');
            enq1=null;
            
            
        }
        
        return null;
    }
    
    
    public void setupPickValMap(){
        picklistMap = new Map<String, List<String>>();
        //   picklistMap.put('..select option..', new List<String>{'..select option..'});
        picklistMap.put('1', new List<String>{'PLAYGROUP'});
        picklistMap.put('2', new List<String>{'NURSERY','PLAYGROUP'});
        picklistMap.put('3', new List<String>{'JR.KG','PLAYGROUP', 'NURSERY'});
        picklistMap.put('4', new List<String>{'SR.KG','PLAYGROUP', 'NURSERY', 'JR.KG'});
        picklistMap.put('5', new List<String>{'I','PLAYGROUP', 'NURSERY', 'JR.KG', 'SR.KG'});
        // picklistMap.put('6', new List<String>{'PLAYGROUP', 'NURSERY', 'JR.KG', 'SR.KG', 'I', 'II'});
        picklistMap.put('6', new List<String>{'II','III','IV','V','VI','VII','VIII','IX','X','XI','XII'});
    }
    
    public void getPrimaryPickVals(){
        selectList = new List<selectOption>();
        
        for(String s : picklistMap.keySet())
            selectList.add(new SelectOption(s, s));
        
    }
    
    
    public void getSecondaryPickVals(){
        system.debug('DOB::::'+enq.Date_of_Birth__c);
        if(enq.Date_of_Birth__c != null){
            system.debug('DOB::::'+enq.Date_of_Birth__c);
            dob=enq.Date_of_Birth__c;
            pdate= date.today().addYears(-2);
            pdate1= date.today().addDays(-1095);
            if(dob != null){
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
                else{
                    enq.Date_Of_Birth__c.addError('Invalid date for admission.');
                    message='';
                }
            }
        }
        
    }
    
}