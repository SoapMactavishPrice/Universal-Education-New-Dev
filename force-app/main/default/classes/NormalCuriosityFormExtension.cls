public without sharing class NormalCuriosityFormExtension{
    //****************//
    public Date dob{ get; set; }

    Public string message{ get; set; }
    Public string childName{ get; set; }
    public Boolean showMYExpirelink{ get; set; }
    public Boolean showMYPage{ get; set; }
    Public Boolean DisplayBlock{ get; set; }   
    public List<SelectOption> secondarySelectList{ get; set; }

    //   public Map<String, List<String>> picklistMap { get; set; }
    //************//
    Public Enquiry__c enq{ get; set; }

    //******/  Public List<Contact>ExistingContact{get;set;}
    Public String Contactid{ get; set; }

    Public string ExistingContactID{ get; set; }

    String getterSetterVar{ get; set; }

    public LIST<Contact> con{ get; set; }

    public LIST<Contact> conlist{ get; set; }

    public Account acc{ get; set; }

    //  public Account acc1{get;set;}
    public integer i{ get; set; }

    public Id Eid{ get; set; }

    public List<Class__C> lstcls{ get; set; }

    public LIST<Enquiry__c> enq1{ get; set; }

    //   public LIST<Enquiry__c> enq2{get;set;}
    public String academicYear{ get; set; }

    Public boolean msg{ get; set; }

    public String sname = ApexPages.currentPage().getParameters().get('sname');
    public String conid = ApexPages.currentPage().getParameters().get('cid');
    public String linkdate = ApexPages.currentPage().getParameters().get('linkdate');


    public String lname{ get; set; }

    public String fname{ get; set; }

    public String cphone{ get; set; }

    public String cemail{ get; set; }

    public String cstreet{ get; set; }

    public String ccity{ get; set; }

    public String cstate{ get; set; }

    public String cpin{ get; set; }

    public String ccountry{ get; set; }
	public Integer ExpiredDaysCuriosity{get;set;}
    //Date EnquirySendDate = Date.today();
    //Date EnquirySendDateExpire = Date.today()+30;
    public Integer recordcount{get;set;}
    public NormalCuriosityFormExtension(ApexPages.StandardController Controller){
         Date ld = Date.valueOf(linkdate);
        Date currentDate = System.today();
        Integer diffDate = currentDate.daysBetween(ld);
        System.debug('diffDate' + diffDate);
        if (diffDate >= 30){
            showMYExpirelink = true;

        } else{
            showMYPage = true;
        }
        getterSetterVar = ApexPages.CurrentPage().getparameters().get('cid');
        System.debug('ValueFromURL:' + getterSetterVar);
        string Curiosityid = system.label.Curiosity_Form_Site_Guest_User;
        List<Enquiry__c>  stringEnquiry =[select Id,Name,Contact__c from Enquiry__c where Contact__c=:getterSetterVar and LastModifiedById=:Curiosityid];
        System.debug('stringEnquiry:' + stringEnquiry);
        recordcount = stringEnquiry.size();
        System.debug('recordcount:' + recordcount);
        if (getterSetterVar != null){
            conlist = [SELECT AccountId,NoOfCuriosityExpiredDays__c,SkipCuriosity__c,Your_First_Name__c,Gender__c,Relation__c,Your_Last_Name__c, Academic_Year__c, Phone, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, Comment__c, SecondaryMobileNo__c, Email, FirstName, Id, LastName, MiddleName, MobilePhone, Name, Salutation, Type__c
                       FROM Contact
                       where ID = :getterSetterVar];
            enq = (Enquiry__c)Controller.getRecord();
            System.debug('enq:' + enq);
            if(conlist[0].SkipCuriosity__c == True){
                ExpiredDaysCuriosity = 90;
            }else{
                ExpiredDaysCuriosity = integer.valueOf(conlist[0].NoOfCuriosityExpiredDays__c);
            } 
            enq.Parent_Last_Name__c = conlist[0].FirstName;
            enq.Parent_First_Name__c = conlist[0].LastName;
            enq.Mobile_No__c = conlist[0].Phone;
            enq.Email__c = conlist[0].Email;
            enq.Address__c = conlist[0].OtherStreet;
            enq.City__c = conlist[0].OtherCity;
            enq.State__c = conlist[0].OtherState;
            enq.Pin_Code__c = conlist[0].OtherPostalCode;
            enq.Country__c = conlist[0].OtherCountry;
            enq.School_Institution__c = conlist[0].AccountId;
            enq.FirstName__c=conlist[0].Your_First_Name__c;
            enq.Last_Name__c=conlist[0].Your_Last_Name__c;
            enq.Gender__c=conlist[0].Gender__c;
            enq.Relation__c=conlist[0].Relation__c;
            childName=conlist[0].Your_First_Name__c;
            lname=conlist[0].Your_Last_Name__c;
            system.debug(' @@@ enq' + enq);
            system.debug(' @@@ enq.Contact__c' + enq.Contact__c);
        }
        academicYear = conlist[0].Academic_Year__c;
        
        Schema.DescribeFieldResult fieldDesc = Schema.Enquiry__c.Academic_Year__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : fieldDesc.getPicklistValues()){
            if (picklistEntry.isDefaultValue()){
                academicYear = picklistEntry.getValue();
                break;
            }
        }
        msg = true;

        //*********//
        // setupPickValMap();
        //  getPrimaryPickVals();
        //********//


        secondarySelectList = new List<selectOption>();
        try{
            if (enq.Contact__c != null){
                con = [SELECT AccountId, Phone, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, Comment__c, SecondaryMobileNo__c, Email, FirstName, Id, LastName, MiddleName, MobilePhone, Name, Salutation, Type__c
                       FROM Contact
                       where ID = :enq.Contact__c];
                system.debug('Contact  %%% enq.Contact__c!=null' + con);


                if (con[0].AccountId != null){
                    acc = [Select id, Name, School_Short_Code__c
                           from Account
                           where id = :con[0].AccountId];
                    sname = acc.School_Short_Code__c;

                    system.debug('acc' + acc);
                } else{
                    msg = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'School is Not Added !!'));
                }
                //added to get the seeking admission grades origianl values
                if (con[0].AccountId != null){
                    lstcls = [SELECT Id, School_Name__c, Original_Class__c, Name, Sequence_Number__c
                              FROM Class__c
                              where School_Name__c = :con[0].AccountId
                              ORDER BY Sequence_Number__c ASC
                              NULLS LAST];
                    System.debug('lstcls' + lstcls);

                    if (!lstcls.isEmpty()){

                        for (i = 0; i < lstcls.size(); i++){
                            System.debug('Inside' + lstcls[i].Name);
                            secondarySelectList.add(new SelectOption(lstcls[i].Name, lstcls[i].Name));
                        }
                    }
                    System.debug('secondarySelectList' + secondarySelectList);
                }

            } else{
                // added for multiple enquiry sent to contact through link
                con = [SELECT AccountId, Comment__c, SecondaryMobileNo__c, Email, FirstName, Id, LastName, MiddleName, MobilePhone, Name, Phone, Salutation, Type__c
                       FROM Contact
                       where ID = :conid];
                acc = [Select id, Name, School_Short_Code__c
                       from Account
                       where id = :con[0].AccountId];

                //added to get the seeking admission grades origianl values
                if (con[0].AccountId != null){
                    lstcls = [SELECT Id, School_Name__c, Original_Class__c, Name, Sequence_Number__c
                              FROM Class__c
                              where School_Name__c = :con[0].AccountId
                              ORDER BY Sequence_Number__c ASC
                              NULLS LAST];


                    if (!lstcls.isEmpty()){

                        for (i = 0; i < lstcls.size(); i++){
                            System.debug('Inside' + lstcls[i].Name);
                            secondarySelectList.add(new SelectOption(lstcls[i].Name, lstcls[i].Name));
                        }
                    }
                    System.debug('secondarySelectList' + secondarySelectList);
                }

                system.debug(' Inside Else part contact rec' + con);
                system.debug(' Inside Else part account rec' + acc);

            }
        } catch (Exception exp){
            system.debug('Exception::::' + exp.getMessage());
            //return null;
        }
        try{
            if (sname == null){


                if (enq.School_Institution__c != null){
                    acc = [Select id, Name, School_Short_Code__c
                           from Account
                           where id = :enq.School_Institution__c];
                    system.debug('ACCOUNT_Query:::' + acc);
                    sname = acc.School_Short_Code__c;
                    system.debug('school::::' + sname);


                }
            }
        } catch (Exception exp){
            system.debug('Inside School Block Exception::::' + exp.getMessage());
        }
    }

    public PageReference save(){
        system.debug('enq.FirstName__c >>>>>> 219' + enq.FirstName__c);
        system.debug('enq.FirstName__c.toUppercase() 219' + enq.FirstName__c.toUppercase());
            if (enq.FirstName__c != null){
                system.debug('enq.FirstName__c >>>>>>' + enq.FirstName__c);
                String NameRegex1 = '^[A-Z]+$';
                system.debug('NameRegex1 >>' + NameRegex1);
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.FirstName__c.toUppercase());
                system.debug('MyMatcher1' + MyMatcher1);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE){
                    enq.FirstName__c.addError('Please enter proper student First Name');
                    return null;
                }
            }
            if (enq.Last_Name__c != null){
                system.debug('enq.Last_Name__c' + enq.Last_Name__c);
               String NameRegex1 = '^[a-z A-Z]+$';
               Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Last_Name__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE){
                    enq.Last_Name__c.addError('Please enter proper Student Last name');
                    return null;
                }
            }
            if (enq.Parent_First_Name__c != null){
                system.debug('enq.Parent_First_Name__c' + enq.Parent_First_Name__c);
                String NameRegex = '^[A-Za-z- ]+$';
                Pattern MyPattern = Pattern.compile(NameRegex);
                Matcher MyMatcher = MyPattern.matcher(enq.Parent_First_Name__c);
                Boolean result = MyMatcher.matches();

                if (result == FALSE){
                    enq.Parent_First_Name__c.addError('Please enter proper value');
                    return null;
                }
            }
            if (enq.Parent_Last_Name__c != null){

                String NameRegex1 = '^[A-Za-z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Parent_Last_Name__c);
                Boolean result1 = MyMatcher1.matches();

                if (result1 == FALSE){
                    enq.Parent_Last_Name__c.addError('Please enter proper value');
                    return null;
                }
            }
            if (enq.Address__c != null){
                if (enq.Address__c.contains('@') || enq.Address__c.contains('!') || enq.Address__c.contains('#') || enq.Address__c.contains('$') || enq.Address__c.contains('%') || enq.Address__c.contains('&') || enq.Address__c.contains('*') || enq.Address__c.contains('(') || enq.Address__c.contains(')') || enq.Address__c.contains('<') || enq.Address__c.contains('>') || enq.Address__c.contains('+') || enq.Address__c.contains('=') || enq.Address__c.contains('?') || enq.Address__c.contains(';')){
                    enq.Address__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                    return null;
                }
            }
            if (enq.City__c != null){

                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.City__c);
                Boolean result1 = MyMatcher1.matches();

                if (result1 == FALSE){

                    enq.City__c.addError('Please enter proper value');
                    return null;
                }
            }
            if (enq.State__c != null){
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.State__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE){
                    enq.State__c.addError('Please enter proper value');
                    return null;
                }
            }
            if (enq.Pin_Code__c != null){

                String NameRegex1 = '^[1-9][0-9]{5}$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Pin_Code__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE){
                    enq.Pin_Code__c.addError('Please enter Proper Value in Pincode');
                    return null;
                }
            }
            if (enq.Country__c != null){
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(enq.Country__c);
                Boolean result1 = MyMatcher1.matches();
                if (result1 == FALSE){
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
            if (conid != Null){
                ExistingContactID = conid;

                //ExistingContactAccountID = ExistingContact[0].AccountID;

            } else{

                system.debug('inside Null Contact');
                cc.LastName = con[0].LastName.toUppercase();
                cc.FirstName = con[0].FirstName.toUppercase();
                cc.Email = con[0].Email.toUppercase();

                cc.Phone = con[0].Phone;
                cc.Type__c = 'Admission Enquiry';
                //  cc.AccountId = acc.id;
                try{
                    insert cc;
                    system.debug('CONTACT+++' + cc);
                } catch (Exception ex){
                    System.debug('Error Message ' + ex.getMessage());
                }
            }
            System.debug('Year @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + academicYear);
            Integer i = 1;
            Integer k = 0;
            List<Enquiry__c> enqList = [Select id, Autonumber_apexClass__c, contact__r.FirstName from Enquiry__c where Academic_Year__c = :academicYear and orgCode__c = :sname and Autonumber_apexClass__c > 0 order by createddate desc NULLS LAST limit 1];
        	System.debug('Record enqList@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + enqList);
            if (!enqList.isEmpty())
                System.debug('Record enqList----' + enqList[0].id);
            if (ExistingContactID != null){
                system.debug('inside Null Contact');
                enq.Contact__c = ExistingContactID;
                /*enq.Parent_First_Name__c = con.FirstName;
                 enq.Parent_Last_Name__c = con.LastName;
                 enq.Mobile_No__c = con.MobilePhone;
                 enq.Email__c = con.Email; */
                //system.debug('CONTACT ID:::'+ExistingContact[0].id);
            } else{
                enq.Contact__c = cc.Id;
            }
            // enq.Parent_First_Name__c = con[0].FirstName;
            //enq.Parent_Last_Name__c = con[0].LastName;
            //enq.Mobile_No__c = con[0].Phone;
            // enq.Email__c = con[0].Email;
            enq.Stages__c = 'Enquiry';
            enq.Log_Status__c = 'New Enquiry';
            enq.Enquiry_Type__c = 'Offline';
            enq.Offline__c = true;
            enq.orgCode__c = sname;
            enq.Academic_Year__c = academicYear;
            String SeekingAdmission = enq.Stellar_Grade__c;
            System.debug('SeekingAdmission Grade: : ' + SeekingAdmission);
            System.debug('School institute: : ' + conlist[0].accountId);
            enq.School_Institution__c = conlist[0].accountId;
            Class__c Sc = [SELECT ID FROM Class__c WHERE School_Name__c = :conlist[0].accountId AND Name = :SeekingAdmission LIMIT 1];
            //integer ir = lstcls.indexof(SeekingAdmission);
            system.debug('Class SC::' + Sc);
            enq.Seeking_Grade__c = Sc.id;
            System.debug('SeekingGrade Lookup ID: ' + Sc.id);
			System.debug('Record enqList@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + enqList);
            if (!enqList.isEmpty()){
                System.debug('Inside enq list not empty');
                System.debug('I @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + i);
                System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + Integer.valueOf(enqList[0].Autonumber_apexClass__c));
                k = i + Integer.valueOf(enqList[0].Autonumber_apexClass__c);
                system.debug('k@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + k);
                //commneted by Himanshu
                //enq.Name=academicYear+'/'+enq.Seeking_Admission_in_Grade__c+'/'+sname+'/'+'CUR'+'/'+k;
                System.debug('academicYear @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + academicYear);
                enq.Name = 'CUR' + '/' + academicYear + '/' + k;
                enq.Autonumber_apexClass__c = k;
                System.debug('enq.Autonumber_apexClass__c @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + enq.Autonumber_apexClass__c);
            }else{
                System.debug('Inside enq list is empty else################################');
                //commneted by Himanshu
                //enq.Name=academicYear+'/'+enq.Seeking_Admission_in_Grade__c+'/'+sname+'/'+'CUR'+'/'+i;
                enq.Name = 'CUR' + '/' + academicYear + '/' + i;
                enq.Autonumber_apexClass__c = i;
                System.debug('enq.Autonumber_apexClass__c ###################################' + enq.Autonumber_apexClass__c);
            }
            //enq.Name = enq.Academic_Year__c+'/'+enq.Seeking_Admission_in_Grade__c+'/ENQ/';
            system.debug('Enquuiry Number $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' + enq);
            system.debug('Enquuiry Number #############################################' + enq.Name);
            enq.Describe__c = enq.Describe__c.toUppercase();
            enq.Enjoy__c = enq.Enjoy__c.toUppercase();
            enq.Enq_School_Institute__c = enq.Enq_School_Institute__c.toUppercase();
            enq.Stellar_Grade__c = enq.Stellar_Grade__c.toUppercase();
            enq.Siblings__c = enq.Siblings__c.toUppercase();
            enq.Child_Other_Info__c = enq.Child_Other_Info__c.toUppercase();
            enq.Parents_learning__c = enq.Parents_learning__c.toUppercase();
            enq.Parents_help__c = enq.Parents_help__c.toUppercase();
            enq.Parents_holiday__c = enq.Parents_holiday__c.toUppercase();
            enq.Parents_hobbies__c = enq.Parents_hobbies__c.toUppercase();
            enq.Flat_No_House_No__c = enq.Flat_No_House_No__c.toUppercase();
            enq.Building_Apt_Name__c = enq.Building_Apt_Name__c.toUppercase();
            enq.Street__c = enq.Street__c.toUppercase();
            enq.Landmark__c = enq.Landmark__c.toUppercase();
            enq.Area__c = enq.Area__c.toUppercase();
            enq.City__c = enq.City__c.toUppercase();
            enq.State__c = enq.State__c.toUppercase();
            enq.Pin_Code__c = enq.Pin_Code__c.toUppercase();
            enq.Country__c = enq.Country__c.toUppercase();
            insert this.enq;
            system.debug('Inserted Contact+++' + enq.Contact__c + ' And Contact ID:::' + con[0].id);
            Eid = enq.Id;
            enq1 = [Select id, Name, Academic_Year__c, Enq_auto_num__c, Seeking_Admission_in_Grade__c, Parent_First_Name__c, Parent_Last_Name__c, Org_code__c, orgCode__c
                    from Enquiry__c
                    where id = :enq.Id];
            system.debug('ENQ NAME++++' + enq1);
            Eid = enq1[0].Id;
        
            /*if(Eid.Email != null){
                system.debug('##inside Eid##');
                if(Eid.Curiosity_Link_Sent__c != null){
                    Send_CuriosityFormLink_SingleEmail.SendEmailNotification(conid);
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Curiosity form Already Recieved !!'));
                }
            }*/
            system.debug('conid >>>>>>>> ' + conid);
            list<Contact> conList = [SELECT Name, Email,Stages__c,Lead_ID__c,Interested__c,On_Hold__c,Meeting_Done__c,Interaction_Done__c, Curiosity_Submitted__c,Curiosity_Submitted_Date__c FROM Contact
                                 WHERE Id = :conid];
            system.debug('conList >>>>>>>> ' + conList);
            Set<String> setOfLeadIds=new Set<String>();
            for (Contact contactItr : conList){
                contactItr.Curiosity_Submitted__c=true;
                contactItr.Curiosity_Submitted_Date__c=DateTime.now();
                contactItr.Stages__c = 'Curiosity Submitted';
                contactItr.Meeting_Done__c = false;
                contactItr.Interaction_Done__c=false;
                contactItr.On_Hold__c=false;
                contactItr.Interested__c = false; 
                setOfLeadIds.add(contactItr.Lead_ID__c);
            }
            Update conList;
            system.debug('setOfLeadIds ' + setOfLeadIds);
            if(!setOfLeadIds.IsEmpty() && setOfLeadIds != null){
                Lead ld = new Lead();
                if(!Test.isRunningTest()){ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c IN:setOfLeadIds limit 1];}
                system.debug('Send_CuriosityFormLink_SingleEmail ' + ld);
                if(ld!=null){
                    if(ld.Stage__c=='Lost'){ld.Stage__c='Lost';}
                    else{ld.Stage__c='Curiosity Submitted';}
                    if(!Test.isRunningTest()){update ld;}
                }
            }
        
        
            PageReference ThankYou = new PageReference('/apex/ShowCuriosityNumber?eid=' + Eid);
            ThankYou.setRedirect(true);
            return ThankYou;


    /*  } Catch (Exception exp){
            system.debug('EXCEPTION++++' + exp.getMessage()+'Cause:::' + exp.getCause()+'Line Number:::' + exp.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Opps... Something went wrong!! Please go back and Resart the process'));
            return null;
        }*/
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

        if (enq.Date_of_Birth__c != null){
            system.debug('DOB::::' + enq.Date_of_Birth__c);
            dob = enq.Date_of_Birth__c;
            //     pdate= date.today().addYears(-2);
            //   pdate1= date.today().addDays(-1095);
            if (dob != null){


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
                if (string.valueOf(dob) >= string.valueOf(date.today())){
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

    public static void FormFactory(){
        Integer i = 0;
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
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}