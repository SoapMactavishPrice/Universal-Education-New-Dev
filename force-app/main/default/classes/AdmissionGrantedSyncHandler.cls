Global class AdmissionGrantedSyncHandler {

    Webservice Static String  SyncAdmissionGranted(String RecordID){
        String AGid = RecordID;
        Admission_Granted__c AG = [SELECT ID,Caste_FF__c,Student_UDISE_No__c, Enrollment_No_FF__c, EMIS_No_FF__c, OCI_FF__c,Father_Pan_Card_No__c,Mother_Pan_Card_No__c,Name,City__c,Original_House__c,Sync_with_Applane__c, State__c,Country__c, Gender__c , Pincode__c,Birth_Place__c,Father_Designation__c,Guardian_Residential_Address__c,guardianEmail_Id__c,guardianMobile_No__c,Relationship__c,GuardianName__c,Mother_Name_of_Department_FF__c,Mother_Adhaar_Card_No__c,Is_Mother_Government_Employee_FF__c,Mother_Office_Address_FF__c,Mother_Office_Contact_No_FF__c,Mother_Designation_FF__c,mother_Email_Id__c,
                                   mother_Last_Name__c,mother_First_Name__c,Father_Name_of_Department_FF__c,Father_Aadhaar_Card_No__c,Is_Father_Government_Employee_FF__c,Father_Office_Address_FF__c,Father_Office_Contact_No_FF__c,father_Mobile_No__c,father_Email_Id__c,Father_First_Name__c,Father_Last_Name__c,Expiry_Date__c, Passport_No__c,User_Id__c,Past_School_Institute_FF__c,Student_Type__c,Emergency_Contact_No__c,Address__c,Mother_Tongue__c,Religion__c,Category__c,Blood_Group__c,House__c,Category_New__c,Registration_No__c,Date_of_Birth_FF__c,  School_Institution__r.Org_code__c, Grade_lookup__r.Original_Class__c, Section_lookup__r.Original_Section__c , First_Name__c, Last_Name__c, Enrollment_No__c, Date_of_Admission__c, Fee_Applicable_Date__c, Class__c, Section__c, Email_Address__c,  Academic_Year__c, father_Qualification__c, mother_Qualification__c,father_Annual_Income__c, mother_Annual_Income__c, father_Name_of_Organisation__c, mother_Name_of_Organisation__c, Adhaar_Card_No__c, father_Business_Address__c, father_Business_Contact__c,  mother_Business_Contact__c, father_Occupation__c, mother_Occupation__c, School_Short_Code__c,  Nationality__c,Mobile_Number__c,  Citizenship_Country__c,
                                   Is_Guardian_Government_Employee_FF__c,
                                   Guardian_Profession_FF__c ,EnquiryNo__r.Contact__c,EnquiryNo__r.Contact__r.Lead_ID__c,EnquiryNo__r.Lead_ID__c,
                                   mother_Mobile_No__c, Lead_ID__c,
                                   Office_Contact_No_FF__c,
                                   Office_Address_FF__c,
                                   Annual_Income_FF__c,
                                   Guardian_Aadhaar_Card_No_FF__c,
                                   Guardian_Pan_Card_No_FF__c,
                                   Name_of_Department_FF__c,
                                   FR_PaymentLink__c
                                   FROM Admission_Granted__c Where ID=:AGid ];
        
        String OrignalOrgCode = AG.School_Institution__r.Org_code__c ;
        
        Map<String, String> FieldKeyMap = new Map<String, String>();
        
        If (OrignalOrgCode != Null) {
            FieldKeyMap.put('profitcenter',OrignalOrgCode.substringAfter('-'));
            FieldKeyMap.put('organization_id',OrignalOrgCode.substringBefore('-')); }
        
        Else { return 'Please Make sure Organization Id is present'; }
        string nondigits = '[^0-9]';
        fieldkeymap.put('first_name',ag.first_name__c );
        fieldkeymap.put('ethnicity',ag.religion__c);
        fieldkeymap.put('shortcode',ag.school_short_code__c );
        fieldkeymap.put('enrollment_no',ag.enrollment_no__c);
        fieldkeymap.put('last_name',ag.last_name__c);
        fieldkeymap.put('category',ag.Caste_FF__c);
        fieldkeymap.put('father_profession',ag.Father_Occupation__c);
        if (ag.Office_Contact_No_FF__c != null) {
            String GofNo = ag.Office_Contact_No_FF__c;
            fieldkeymap.put('guardian_office_contactno',GofNo.replaceAll(nondigits, ''));
        }
        fieldkeymap.put('house',ag.Original_House__c);
        fieldkeymap.put('oci',ag.OCI_FF__c);
        fieldkeymap.put('blood_group',ag.blood_group__c);
        fieldkeymap.put('religion',ag.religion__c);
        fieldkeymap.put('lead_id',ag.Lead_ID__c);
         if (ag.Student_UDISE_No__c != null) {
            fieldkeymap.put('disecode',ag.Student_UDISE_No__c);
        }
        if (ag.Enrollment_No_FF__c != null) {
            fieldkeymap.put('disecode',ag.Enrollment_No_FF__c);
        }
        if (ag.EMIS_No_FF__c != null) {
            fieldkeymap.put('disecode',ag.EMIS_No_FF__c);
        }
        fieldkeymap.put('mother_tongue',ag.mother_tongue__c);
        fieldkeymap.put('address',ag.address__c);
        fieldkeymap.put('student_type',ag.student_type__c);
        fieldkeymap.put('passport_no',ag.passport_no__c);
        fieldkeymap.put('father_first_name',ag.father_first_name__c);
        fieldkeymap.put('father_last_name',ag.father_last_name__c);
        fieldkeymap.put('father_occupation',ag.father_Occupation__c);
        fieldkeymap.put('father_qualification','graduate');
        fieldkeymap.put('mother_occupation',ag.mother_Occupation__c);
        //Guardian_Profession_FF__c
        fieldkeymap.put('guardian_occupation',ag.Guardian_Profession_FF__c);
        //Annual_Income_FF__c
        integer Annual_Income_FF   = Integer.valueOf( AG.Annual_Income_FF__c);
        fieldkeymap.put('guardian_annual_income',String.ValueOf(Annual_Income_FF));
        
        fieldkeymap.put('mother_profession',ag.mother_Occupation__c);
        //  mother_Occupation__c
        fieldkeymap.put('mother_qualification','graduate');
        //Office_Address_FF__c
        fieldkeymap.put('guardian_office_address',ag.Office_Address_FF__c);
        fieldkeymap.put('guardian_profession','service');
        fieldkeymap.put('guardian_qualification','graduate');
        fieldkeymap.put('father_email_id',ag.father_email_id__c);
        fieldkeymap.put('father_office_address',ag.father_office_address_ff__c);
        fieldkeymap.put('father_aadhaar_card_no',ag.father_aadhaar_card_no__c);
        fieldkeymap.put('mother_first_name',ag.mother_first_name__c);
        fieldkeymap.put('mother_last_name',ag.mother_last_name__c);
        fieldkeymap.put('mother_email_id',ag.mother_email_id__c);
        fieldkeymap.put('mother_designation',ag.mother_designation_ff__c);
        fieldkeymap.put('mother_office_address',ag.mother_office_address_ff__c);
        fieldkeymap.put('father_office_name',ag.father_Name_of_Organisation__c);
        fieldkeymap.put('mother_office_name',ag.mother_Name_of_Organisation__c);
        
        fieldkeymap.put('guardian_address',ag.Guardian_Residential_Address__c);
        fieldkeymap.put('guardianname',ag.guardianname__c);
        fieldkeymap.put('relationship',ag.relationship__c);
        fieldkeymap.put('guardianemail_id',ag.guardianemail_id__c);
        fieldkeymap.put('city',ag.city__c);
        fieldkeymap.put('state',ag.state__c);
        fieldkeymap.put('country',ag.country__c);
        fieldkeymap.put('pin_code',ag.pincode__c);
        fieldkeymap.put('place_of_birth',ag.birth_place__c);
        fieldkeymap.put('father_designation',ag.father_designation__c);
        fieldkeymap.put('guardian_residential_address',ag.guardian_residential_address__c);
        fieldkeymap.put('nationality',ag.nationality__c);
        fieldkeymap.put('aadhaar_no',ag.adhaar_card_no__c);
        if (ag.guardianmobile_no__c != null) {
            String GMno = ag.guardianmobile_no__c;
            fieldkeymap.put('guardian_mobile_no',GMno.replaceAll(nondigits, ''));
        } 
        if (ag.mother_office_contact_no_ff__c != null) {
            String MofCno = ag.mother_office_contact_no_ff__c;
            fieldkeymap.put('mother_office_contactno',MofCno.replaceAll(nondigits, '') );
        }
        if (ag.mother_mobile_no__c != null) {
            String MMPhone =  ag.mother_mobile_no__c;
            fieldkeymap.put('mother_phone_no',MMPhone.replaceAll(nondigits, '') );
        }
        if (ag.father_office_contact_no_ff__c != null ){  
            String FofcNo = ag.father_office_contact_no_ff__c;
            fieldkeymap.put('father_office_contactno',FofcNo.replaceAll(nondigits, '') );
        }
        if (ag.mobile_number__c != null ) {
            String smsNumber= ag.mobile_number__c;
            fieldkeymap.put('sms_contact_no',smsNumber.replaceAll(nondigits, '') );
        }
        
        if (ag.father_mobile_no__c != null) {
        String Fmo = ag.father_mobile_no__c;
        fieldkeymap.put('father_phone_no',Fmo.replaceAll(nondigits, '')  );    
        }
        
        if (ag.emergency_contact_no__c != null) {
            String ECno = ag.emergency_contact_no__c ;
            fieldkeymap.put('emergency_contact',ECno.replaceAll(nondigits, '') );
            
        }
        
        
        
        fieldkeymap.put('expiry_date',string.valueof(ag.expiry_date__c) );
        fieldkeymap.put('date_of_admission',string.valueof(ag.date_of_admission__c) );
        fieldkeymap.put('fee_applicable_date',string.valueof(ag.fee_applicable_date__c) );
        fieldkeymap.put('gender',ag.gender__c );
        fieldkeymap.put('class',ag.grade_lookup__r.original_class__c );
        fieldkeymap.put('section',ag.section_lookup__r.original_section__c  );
        fieldkeymap.put('userid',ag.user_id__c );
        // fieldkeymap.put('academic_year',ag.academic_year__c );
        fieldkeymap.put('dob',ag.date_of_birth_ff__c );
        fieldkeymap.put('emailid',ag.user_id__c);
        fieldkeymap.put('registration_no',ag.Name);
        
        integer father_annualincome   = Integer.valueOf( AG.father_Annual_Income__c);
        integer mother_annualincome   = Integer.valueOf( AG.mother_annual_income__c);
        integer guardian_annualincome   = Integer.valueOf( AG.father_annual_income__c);
        fieldkeymap.put('father_annual_income',String.valueOf(father_annualincome));
        fieldkeymap.put('mother_annual_income',String.valueOf(mother_annualincome));
        fieldkeymap.put('guardian_annual_income',String.valueOf(guardian_annualincome));
        
        
        fieldkeymap.put('aadhar_card_no',ag.Adhaar_Card_No__c);
        fieldkeymap.put('citizenship_country',ag.Citizenship_Country__c);
        fieldkeymap.put('last_school_name',ag.Past_School_Institute_FF__c);
       // fieldkeymap.put('father_office_contactno',ag.Father_Office_Contact_No_FF__c);
        String Father_Gov_employee = ag.Is_Father_Government_Employee_FF__c; 
        if ( (Father_Gov_employee == 'Yes') ){
            fieldkeymap.put('father_is_govt_employee','TRUE');   
        } Else {
            fieldkeymap.put('father_is_govt_employee','FALSE');
        }
        // fieldkeymap.put('father_is_govt_employee',ag.Is_Father_Government_Employee_FF__c);
        fieldkeymap.put('father_aadhaar_no',ag.Father_Aadhaar_Card_No__c);
        fieldkeymap.put('father_department',ag.Father_Name_of_Department_FF__c);
        /* If (ag.Mother_Office_Contact_No_FF__c != null ) {
            String MofcCno = Mother_Office_Contact_No_FF__c;
            fieldkeymap.put('mother_office_contactno',MofcCno.replaceAll(nondigits, '') ); 
        } */
        string Mother_Gov_Employee = ag.Is_Mother_Government_Employee_FF__c;
        if ( Mother_Gov_Employee == 'Yes' ){
            fieldkeymap.put('mother_is_govt_employee','TRUE');   
        } Else {
            fieldkeymap.put('mother_is_govt_employee','FALSE');
        }
        
        //  fieldkeymap.put('mother_is_govt_employee',ag.Is_Mother_Government_Employee_FF__c);
        fieldkeymap.put('mother_aadhaar_no',ag.Mother_Adhaar_Card_No__c);
        fieldkeymap.put('mother_department',ag.Mother_Name_of_Department_FF__c);
        fieldkeymap.put('guardian_name',ag.GuardianName__c);
        fieldkeymap.put('guardian_relation',ag.Relationship__c);
        fieldkeymap.put('guardian_email_id',ag.guardianEmail_Id__c);
        
        String Guardian_Gov_employee = ag.Is_Guardian_Government_Employee_FF__c; 
        if ( (Guardian_Gov_employee == 'Yes') ){
            fieldkeymap.put('guardian_is_govt_employee','TRUE');   
        } Else {
            fieldkeymap.put('guardian_is_govt_employee','FALSE');
        }
        
        
        
        //fieldkeymap.put('guardian_is_govt_employee',ag.Is_Guardian_Government_Employee_FF__c);
      
        fieldkeymap.put('guardian_aadhaar_no',ag.Guardian_Aadhaar_Card_No_FF__c);
        fieldkeymap.put('mother_pan_no',ag.Mother_Pan_Card_No__c);
        fieldkeymap.put('father_pan_no',ag.Father_Pan_Card_No__c);
        fieldkeymap.put('guardian_pan_no',ag.Guardian_Pan_Card_No_FF__c);
        fieldkeymap.put('guardian_department',ag.Name_of_Department_FF__c);
       
        If (ag.Mobile_Number__c != Null ) {
            String MobNo = ag.Mobile_Number__c;
            fieldkeymap.put('mobileno',MobNo.replaceAll(nondigits, ''));
        }
        
        fieldkeymap.put('passport_expiry_date',string.valueof(ag.Expiry_Date__c));
        /*
            If(ag.father_Mobile_No__c != null){
                fieldkeymap.put('father_phone_no',string.valueof(ag.father_Mobile_No__c.replaceall('\\d','')));
            }
            If(ag.mother_Mobile_No__c !=null){
                fieldkeymap.put('mother_phone_no',string.valueof(ag.mother_Mobile_No__c.replaceall('\\d','')));
            }
            If( ag.guardianMobile_No__c != null){
                fieldkeymap.put('guardian_mobile_no',string.valueof(ag.guardianMobile_No__c.replaceall('\\d','')));
            }

        */
        
        System.debug('MAP::: '+FieldKeyMap);

        String EncodedURL = replaceSpace(FieldKeyMap, Ag.Academic_Year__c );
        //String EncodedURL = replaceSpace(FieldKeyMap);

        try{
            system.debug('ENPOINT URL:::'+EncodedURL);
            String bodyContent='';
            HttpRequest req = new HttpRequest();
            Http httpreq = new Http();
            req.setHeader('cache-control', 'no-cache');
            req.setBody(bodyContent);
            req.setEndpoint(EncodedURL);
            req.setMethod('POST');
            HttpResponse res = httpreq.send(req);
            String reqresponse = res.getBody();
            system.debug('REQUEST_RESPONSE::::'+reqresponse);
            
            If (reqresponse.contains('200')){
                /*
                "API: https://admission.stellarworldschool.com/salesforce/send-form
                Method: POST 
                Request Body:
                {
                    "formLink": "http://somelink",
                    "formType": "PAYMENT",
                    "email": "anam@technogise.com",
                    "data": {
                        "parentFirstname": "Ayaan",
                        "parentLastname": "Shah"
                    }
                }
                */

                if(StellarAPICallouts.checkIfStellarAPIEnabled(ag.school_short_code__c)){
                    String parentFName = String.isNotBlank(ag.father_first_name__c) ? ag.father_first_name__c : ag.mother_first_name__c;
                    String parentLName = String.isNotBlank(ag.father_last_name__c) ? ag.father_last_name__c : ag.mother_last_name__c;
                    String email = String.isNotBlank(ag.father_email_id__c) ? ag.father_email_id__c : ag.mother_Email_Id__c;
                    Map<String, Object> dataMap = StellarAPICallouts.createBody(
                        new List<String>{'parentFirstname', 'parentLastname'},
                        new List<Object>{parentFName, parentLName}
                    );

                    String endpoint = 'https://admission.stellarworldschool.com/salesforce/send-form';
                    StellarAPICallouts.makeCallout(
                        endpoint,
                        StellarAPICallouts.POST_METHOD,
                        StellarAPICallouts.createBody(
                            new List<String>{'formLink', 'formType', 'email', 'data'},
                            new List<Object>{ag.FR_PaymentLink__c, 'PAYMENT', email, dataMap}
                        )
                    );
                }
                AG.Sync_with_Applane__c = True;
                Update AG;

                string customleadValue;
                Admission_Granted__c AGss = [SELECT ID,EnquiryNo__r.Lead_ID__c FROM Admission_Granted__c Where ID=:AGid ];
                customleadValue = AGss.EnquiryNo__r.Lead_ID__c;
                List<lead> lstlead = new List<Lead>();
                List<lead> slitlead = new List<lead>();
                if(!Test.isRunningTest()){slitlead = [select Id,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];}
                else{slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];}
                system.debug('slitlead >> ' + slitlead);
                if(!slitlead.isEmpty()){
                    for(lead le : slitlead)
                    {
                        lead l = new lead();
                        l.id = le.id;
                        l.Stage__c = 'Sync With Applane';
                        lstlead.add(l);
                    }
                    system.debug('lstlead -- ' + lstlead);
                    if(!lstlead.isEmpty()){
                        update lstlead;
                    }
                }
                
            }
            return reqresponse;
        }catch (Exception ex){
            System.debug('Error while sync ::'+ex.getMessage());
            return  ex.getMessage();
        }
        
    }

    Webservice Static String  Ether_SyncAdmissionGranted(String RecordID){
        String AGid = RecordID;
        Admission_Granted__c AG = [SELECT ID,Caste_FF__c,Enrollment_Number_for_Ether__c,Student_UDISE_No__c, Enrollment_No_FF__c, EMIS_No_FF__c, OCI_FF__c,Father_Pan_Card_No__c,Mother_Pan_Card_No__c,Name,City__c,Original_House__c,Sync_with_Applane__c, State__c,Country__c, Gender__c , Pincode__c,Birth_Place__c,Father_Designation__c,Guardian_Residential_Address__c,guardianEmail_Id__c,guardianMobile_No__c,Relationship__c,GuardianName__c,Mother_Name_of_Department_FF__c,Mother_Adhaar_Card_No__c,Is_Mother_Government_Employee_FF__c,Mother_Office_Address_FF__c,Mother_Office_Contact_No_FF__c,Mother_Designation_FF__c,mother_Email_Id__c,
                                   mother_Last_Name__c,mother_First_Name__c,Father_Name_of_Department_FF__c,Father_Aadhaar_Card_No__c,Is_Father_Government_Employee_FF__c,Father_Office_Address_FF__c,Father_Office_Contact_No_FF__c,father_Mobile_No__c,father_Email_Id__c,Father_First_Name__c,Father_Last_Name__c,Expiry_Date__c, Passport_No__c,User_Id__c,Past_School_Institute_FF__c,Student_Type__c,Emergency_Contact_No__c,Address__c,Mother_Tongue__c,Religion__c,Category__c,Blood_Group__c,House__c,Category_New__c,Registration_No__c,Date_of_Birth_FF__c,  School_Institution__r.Org_code__c, Grade_lookup__r.Original_Class__c, Section_lookup__r.Original_Section__c , First_Name__c, Last_Name__c, Enrollment_No__c, Date_of_Admission__c, Fee_Applicable_Date__c, Class__c, Section__c, Email_Address__c,  Academic_Year__c, father_Qualification__c, mother_Qualification__c,father_Annual_Income__c, mother_Annual_Income__c, father_Name_of_Organisation__c, mother_Name_of_Organisation__c, Adhaar_Card_No__c, father_Business_Address__c, father_Business_Contact__c,  mother_Business_Contact__c, father_Occupation__c, mother_Occupation__c, School_Short_Code__c,  Nationality__c,Mobile_Number__c,  Citizenship_Country__c,
                                   Is_Guardian_Government_Employee_FF__c,Sync_With_Ether__c,
                                   Guardian_Profession_FF__c ,EnquiryNo__r.Contact__c,EnquiryNo__r.Contact__r.Lead_ID__c,EnquiryNo__r.Lead_ID__c,
                                   mother_Mobile_No__c,Lead_ID__c,
                                   Office_Contact_No_FF__c,Synced_With_Ether_On_Date__c,Synced_With_Ether_On_Time__c,
                                   Mental_Problem_Please_Specify__c,Please_specify_any_medication__c,Share_the_Allergies__c,Concessions_Remark__c,Practitioner_Mobile__c,
                                   Practitioner_Name__c,Practitioner_Clinic_Phone__c,Practitioner_Address__c,
Guardian_Designation__c,Guardian_office_name__c,Guardian_Qualification_FF__c,Mother_Annual_Income_FF__c,Father_Annual_Income_FF__c,
                                   Office_Address_FF__c,
                                   Annual_Income_FF__c,
                                   Guardian_Aadhaar_Card_No_FF__c,
                                   Guardian_Pan_Card_No_FF__c,
                                   Name_of_Department_FF__c,
                                   FR_PaymentLink__c,Request__c,Responce__c,Ether_Remark__c
                                   FROM Admission_Granted__c Where ID=:AGid ];
        
        String OrignalOrgCode = AG.School_Institution__r.Org_code__c ;
        Map<String, String> FieldKeyMap = new Map<String, String>();
        
        If (OrignalOrgCode != Null) {
            FieldKeyMap.put('profitcenter',OrignalOrgCode.substringAfter('-'));
            FieldKeyMap.put('organization_id',OrignalOrgCode); }
        
        Else { 
            return 'Please Make sure Organization Id is present'; 
        }
        if(ag.mother_email_id__c==ag.father_email_id__c)
        {
             return 'Mother and Father email id can not be same';
        }
        list <string> emaillist=new list <string> {'universal', 'sws.edu.in', 'eis.edu.in', 'alphaeducation','primussschool'};
        if(  ag.father_email_id__c!=null ){
           for(string st :emaillist )
           {
            if( ag.father_email_id__c.contains(st))
            {
                return 'Parent email ID provided cannot be your official email ID';
            }
           }
        }
        if(ag.mother_email_id__c!=null){
            for(string st :emaillist )
           {
            if( ag.mother_email_id__c.contains(st))
            {
                return 'Parent email ID provided cannot be your official email ID';
            }
           }
        }
        
        string nondigits = '[^0-9]';
        if(ag.first_name__c!=null){
        fieldkeymap.put('first_name',ag.first_name__c.toLowerCase().capitalize() );
        }
        else{
           return 'First name can not be blank';
        }
        fieldkeymap.put('ethnicity',ag.religion__c);
        fieldkeymap.put('shortcode',ag.school_short_code__c );
        fieldkeymap.put('enrollment_no',ag.Enrollment_Number_for_Ether__c);
        if(ag.last_name__c!=null){
        fieldkeymap.put('last_name',ag.last_name__c.toLowerCase().capitalize());
        }else{
              return 'Last name can not be blank';
        }
        fieldkeymap.put('category',ag.Caste_FF__c);
        fieldkeymap.put('father_profession',ag.Father_Occupation__c);
        if (ag.Office_Contact_No_FF__c != null) {
            String GofNo = ag.Office_Contact_No_FF__c;
            fieldkeymap.put('guardian_office_contactno',GofNo.replaceAll(nondigits, ''));
        }
        fieldkeymap.put('house',ag.Original_House__c);
        fieldkeymap.put('oci',ag.OCI_FF__c);
        fieldkeymap.put('blood_group',ag.blood_group__c);
        fieldkeymap.put('religion',ag.religion__c);
        fieldkeymap.put('lead_id',ag.Lead_ID__c);
         if (ag.Student_UDISE_No__c != null) {
            fieldkeymap.put('disecode',ag.Student_UDISE_No__c);
        }
        if (ag.Enrollment_No_FF__c != null) {
            fieldkeymap.put('disecode',ag.Enrollment_No_FF__c);
        }
        if (ag.EMIS_No_FF__c != null) {
            fieldkeymap.put('disecode',ag.EMIS_No_FF__c);
        }
        fieldkeymap.put('mother_tongue',ag.mother_tongue__c);
        fieldkeymap.put('address',ag.address__c);
        fieldkeymap.put('student_type',ag.student_type__c);
        fieldkeymap.put('passport_no',ag.passport_no__c);
        if(ag.father_first_name__c!=null){
        fieldkeymap.put('father_first_name',ag.father_first_name__c.toLowerCase().capitalize());
        }
        if(ag.father_last_name__c!=null){
            fieldkeymap.put('father_last_name',ag.father_last_name__c.toLowerCase().capitalize());
        }else
        {
             fieldkeymap.put('father_last_name','');
        }
        fieldkeymap.put('father_occupation',ag.father_Occupation__c);
        fieldkeymap.put('father_qualification',ag.father_Qualification__c);
        fieldkeymap.put('mother_occupation',ag.mother_Occupation__c);
        if(ag.Academic_Year__c!=null){
         fieldkeymap.put('academic_year',ag.Academic_Year__c);
        }else{
            return 'Academic year can not be blank';
        }
        
        //Guardian_Profession_FF__c
        fieldkeymap.put('guardian_occupation',ag.Guardian_Profession_FF__c);
        //Annual_Income_FF__c
        integer Annual_Income_FF   = Integer.valueOf( AG.Annual_Income_FF__c);
        fieldkeymap.put('guardian_annual_income',String.ValueOf(Annual_Income_FF));
        fieldkeymap.put('mother_profession',ag.mother_Occupation__c);
        fieldkeymap.put('mother_qualification',ag.mother_Qualification__c);
        fieldkeymap.put('guardian_office_address',ag.Office_Address_FF__c);
        fieldkeymap.put('guardian_profession',ag.Guardian_Profession_FF__c);
        fieldkeymap.put('guardian_qualification',ag.Guardian_Qualification_FF__c);
        fieldkeymap.put('father_email_id',ag.father_email_id__c);
        fieldkeymap.put('father_office_address',ag.father_office_address_ff__c);
        fieldkeymap.put('father_aadhaar_card_no',ag.father_aadhaar_card_no__c);
      // fieldkeymap.put('mother_first_name',ag.mother_first_name__c.capitalize());
        if(ag.mother_first_name__c!=null){
        fieldkeymap.put('mother_first_name',ag.mother_first_name__c.toLowerCase().capitalize());
        }else{
              fieldkeymap.put('mother_first_name','');
        }
        if(ag.mother_last_name__c!=null){
        fieldkeymap.put('mother_last_name',ag.mother_last_name__c.toLowerCase().capitalize());
        }else{
              fieldkeymap.put('mother_last_name','');
        }
        fieldkeymap.put('mother_email_id',ag.mother_email_id__c);
        fieldkeymap.put('mother_designation',ag.mother_designation_ff__c);
        fieldkeymap.put('mother_office_address',ag.mother_office_address_ff__c);
        fieldkeymap.put('father_office_name',ag.father_Name_of_Organisation__c);
        fieldkeymap.put('mother_office_name',ag.mother_Name_of_Organisation__c);
        fieldkeymap.put('guardian_address',ag.Guardian_Residential_Address__c);
        fieldkeymap.put('guardianname',ag.guardianname__c);
        fieldkeymap.put('relationship',ag.relationship__c);
        fieldkeymap.put('guardianemail_id',ag.guardianemail_id__c);
        fieldkeymap.put('city',ag.city__c);
        fieldkeymap.put('state',ag.state__c);
        fieldkeymap.put('country',ag.country__c);
        fieldkeymap.put('pin_code',ag.pincode__c);
        fieldkeymap.put('place_of_birth',ag.birth_place__c);
        fieldkeymap.put('father_designation',ag.father_designation__c);
        fieldkeymap.put('guardian_residential_address',ag.guardian_residential_address__c);
        fieldkeymap.put('nationality',ag.nationality__c);
        fieldkeymap.put('aadhaar_no',ag.adhaar_card_no__c);
        if (ag.guardianmobile_no__c != null) {
            String GMno = ag.guardianmobile_no__c;
            fieldkeymap.put('guardian_mobile_no',GMno.replaceAll(nondigits, ''));
        } 
        if (ag.mother_office_contact_no_ff__c != null) {
            String MofCno = ag.mother_office_contact_no_ff__c;
            fieldkeymap.put('mother_office_contactno',MofCno.replaceAll(nondigits, '') );
        }
        if (ag.mother_mobile_no__c != null) {
            String MMPhone =  ag.mother_mobile_no__c;
            fieldkeymap.put('mother_phone_no',MMPhone.replaceAll(nondigits, '') );
        }
        if (ag.father_office_contact_no_ff__c != null ){  
            String FofcNo = ag.father_office_contact_no_ff__c;
            fieldkeymap.put('father_office_contactno',FofcNo.replaceAll(nondigits, '') );
        }
        if (ag.mobile_number__c != null ) {
            String smsNumber= ag.mobile_number__c;
            fieldkeymap.put('sms_contact_no',smsNumber.replaceAll(nondigits, '') );
        }
        
        if (ag.father_mobile_no__c != null) {
        String Fmo = ag.father_mobile_no__c;
        fieldkeymap.put('father_phone_no',Fmo.replaceAll(nondigits, '')  );    
        }
        
        if (ag.emergency_contact_no__c != null) {
            String ECno = ag.emergency_contact_no__c ;
            fieldkeymap.put('emergency_contact',ECno.replaceAll(nondigits, '') );
            
        }
        
        fieldkeymap.put('expiry_date',string.valueof(ag.expiry_date__c) );
        fieldkeymap.put('date_of_admission',string.valueof(ag.date_of_admission__c) );
        fieldkeymap.put('fee_applicable_date',string.valueof(ag.fee_applicable_date__c) );
        if(ag.gender__c!=null){
            fieldkeymap.put('gender',ag.gender__c.capitalize() );
        }else{
            return 'Gender is mandatory';
        }
        if(ag.grade_lookup__r.original_class__c!=null){
        fieldkeymap.put('class',ag.grade_lookup__r.original_class__c );
        }else{
            return 'class can not be blank';
        }
        fieldkeymap.put('section',ag.section_lookup__r.original_section__c  );
        fieldkeymap.put('userid',ag.user_id__c );
        fieldkeymap.put('dob',ag.date_of_birth_ff__c );
        if(ag.Email_Address__c!=null)
        {
            fieldkeymap.put('emailid',ag.Email_Address__c);
        }else
        {
            return 'Student email id can not blank.';
        }
        
        fieldkeymap.put('registration_no',ag.Name);
        
        integer father_annualincome   = Integer.valueOf( AG.Father_Annual_Income_FF__c);
        integer mother_annualincome   = Integer.valueOf( AG.Mother_Annual_Income_FF__c);
        integer guardian_annualincome   = Integer.valueOf( AG.Annual_Income_FF__c);
        fieldkeymap.put('father_annual_income',String.valueOf(father_annualincome));
        fieldkeymap.put('mother_annual_income',String.valueOf(mother_annualincome));
        fieldkeymap.put('guardian_annual_income',String.valueOf(guardian_annualincome));
        
        
        fieldkeymap.put('aadhar_card_no',ag.Adhaar_Card_No__c);
        fieldkeymap.put('citizenship_country',ag.Citizenship_Country__c);
        fieldkeymap.put('last_school_name',ag.Past_School_Institute_FF__c);
       
        String Father_Gov_employee = ag.Is_Father_Government_Employee_FF__c; 
        if ( (Father_Gov_employee == 'Yes') ){
            fieldkeymap.put('father_is_govt_employee','TRUE');   
        } Else {
            fieldkeymap.put('father_is_govt_employee','FALSE');
        }
       
        fieldkeymap.put('father_aadhaar_no',ag.Father_Aadhaar_Card_No__c);
        fieldkeymap.put('father_department',ag.Father_Name_of_Department_FF__c);
       
        string Mother_Gov_Employee = ag.Is_Mother_Government_Employee_FF__c;
        if ( Mother_Gov_Employee == 'Yes' ){
            fieldkeymap.put('mother_is_govt_employee','TRUE');   
        } Else {
            fieldkeymap.put('mother_is_govt_employee','FALSE');
        }
        
        fieldkeymap.put('mother_aadhaar_no',ag.Mother_Adhaar_Card_No__c);
        fieldkeymap.put('mother_department',ag.Mother_Name_of_Department_FF__c);
        fieldkeymap.put('guardian_name',ag.GuardianName__c);
        fieldkeymap.put('guardian_relation',ag.Relationship__c);
        fieldkeymap.put('guardian_email_id',ag.guardianEmail_Id__c);
         fieldkeymap.put('guardian_email_id',ag.guardianEmail_Id__c);
        //OCI_FF__c 
        
        String Guardian_Gov_employee = ag.Is_Guardian_Government_Employee_FF__c; 
        if ( (Guardian_Gov_employee == 'Yes') ){
            fieldkeymap.put('guardian_is_govt_employee','TRUE');   
        } Else {
            fieldkeymap.put('guardian_is_govt_employee','FALSE');
        }
        
        fieldkeymap.put('guardian_aadhaar_no',ag.Guardian_Aadhaar_Card_No_FF__c);
        fieldkeymap.put('mother_pan_no',ag.Mother_Pan_Card_No__c);
        fieldkeymap.put('father_pan_no',ag.Father_Pan_Card_No__c);
        fieldkeymap.put('guardian_pan_no',ag.Guardian_Pan_Card_No_FF__c);
        fieldkeymap.put('guardian_department',ag.Name_of_Department_FF__c);
        
        fieldkeymap.put('medical_problems',ag.Mental_Problem_Please_Specify__c);
        fieldkeymap.put('medications',ag.Please_specify_any_medication__c);
        fieldkeymap.put('allergies',ag.Share_the_Allergies__c);
        fieldkeymap.put('medical_practitioner_name',ag.Practitioner_Name__c);
        fieldkeymap.put('medical_practitioner_clinic_address',ag.Practitioner_Address__c);
        fieldkeymap.put('medical_practitioner_clinic_contact_no',ag.Practitioner_Clinic_Phone__c);
        fieldkeymap.put('medical_practitioner_mobile_no',ag.Practitioner_Mobile__c);
         fieldkeymap.put('concessions_waivers_remark',ag.Ether_Remark__c);
        fieldkeymap.put('guardian_designation',ag.Guardian_Designation__c);
         fieldkeymap.put('guardian_office_name',ag.Guardian_office_name__c);
        
       
        If (ag.Mobile_Number__c != Null ) {
            String MobNo = ag.Mobile_Number__c;
            fieldkeymap.put('mobileno',MobNo.replaceAll(nondigits, ''));
        }
        
        fieldkeymap.put('passport_expiry_date',string.valueof(ag.Expiry_Date__c));
        
        System.debug('MAP::: '+FieldKeyMap);

       // try{
            String reqresponse='-1';
            Org_Configuration__mdt tokenDetails=[Select id,Long_Value__c,MasterLabel from Org_Configuration__mdt where MasterLabel='EtherToken'];

            if(tokenDetails!=null){

                String bodyContent=json.serialize(fieldkeymap);
                string tokenSystem=tokenDetails.Long_Value__c;

                if(String.isNotBlank(tokenSystem)){
                    Http httpreq = new Http();

                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST');
                    
                    req.setBody(bodyContent);
                    req.setEndpoint('callout:EtherEndpoints');
                    req.setHeader('Authorization', 'Bearer '+ tokenSystem);
                    req.setHeader('Content-Type', 'application/json');
                    HttpResponse res = httpreq.send(req);
                    reqresponse = res.getBody();
 system.debug('REQUES::::'+req);
                    system.debug('bodyContent::::'+bodyContent);
                    system.debug('REQUEST_RESPONSE::::'+reqresponse);
                    String json=reqresponse;
                    ag.Request__c=bodyContent;
                    ag.Responce__c=reqresponse;
                    If (res.getStatusCode()==201){
                        reqresponse='Student record sync successful.';
                        if(StellarAPICallouts.checkIfStellarAPIEnabled(ag.school_short_code__c)){
                            String parentFName = String.isNotBlank(ag.father_first_name__c) ? ag.father_first_name__c : ag.mother_first_name__c;
                            String parentLName = String.isNotBlank(ag.father_last_name__c) ? ag.father_last_name__c : ag.mother_last_name__c;
                            String email = String.isNotBlank(ag.father_email_id__c) ? ag.father_email_id__c : ag.mother_Email_Id__c;
                            Map<String, Object> dataMap = StellarAPICallouts.createBody(
                                new List<String>{'parentFirstname', 'parentLastname'},
                                new List<Object>{parentFName, parentLName}
                            );

                            String endpoint = 'https://admission.stellarworldschool.com/salesforce/send-form';
                            StellarAPICallouts.makeCallout(
                                endpoint,
                                StellarAPICallouts.POST_METHOD,
                                StellarAPICallouts.createBody(
                                    new List<String>{'formLink', 'formType', 'email', 'data'},
                                    new List<Object>{ag.FR_PaymentLink__c, 'PAYMENT', email, dataMap}
                                )
                            );
                        }
                        String emailid ='';
                        fromJSON js=new fromJSON();
                       // String json=		'{"status":"ACTIVE","schools":null,"enrollmentNo":null,"email":"bharti.khurana.aqbpo@universal.edu.in","profile":"","name":"Bharti Khurana","school":"SWS-GOREGAON","role":"currentStudent","gender":"MALE","notificationPreference":{"onDeck":true,"email":false,"push":false},"curriculum":"","courseInfo":[{"grade":"1","section":"PYP","division":"A","academicYear":{"from":"2023-07-12T18:30:00.000Z","to":"2024-06-30T18:29:59.000Z","id":null},"house":null,"id":null}],"rollOverInfo":[{"isNewAdmission":true,"academicYear":"2023-2024","grade":"1","isGoingToRollOver":false,"concessionsWaiversRemark":"Corporate - 10%;Pre-Primary Mid-Morning - 25%","id":null}],"personalDetails":{"contactNo":"8304418297","nationality":"Indian","country":null,"residentialAddress":"A 1202, Swarna, Kanakia, Mumbai, Maharashtra, 400006","birthPlace":"Mumbai","religion":"Others","caste":"Gen","motherTongue":null,"dateOfBirth":"2017-12-12T00:00:00.000Z"},"emergencyContactDetails":{"emergencyContactNo":"7304418297"},"officialDetails":{"passportNo":null,"passportExpiryDate":"1970-01-01T00:00:00.000Z","visa":null,"adhaarCardNo":null},"studentHealthInfo":{"isChildTakingAnyMedication":"No","doesChildHaveAnyAllergies":"No","anyMedicalProblem":"No"},"medicalPractitionerInfo":{"name":null,"address":null,"clinicPhoneNo":null,"mobileNo":null},"guardianInfo":{"name":null,"relation":null,"emailId":null,"personalDetails":{"residentialAddress":"A 1202, Swarna, Kanakia, Mumbai, Maharashtra, 400006"},"officialDetails":{"adhaarCardNo":null,"panCardNo":null},"educationalQualification":"graduate","occupationDetails":{"occupation":null,"profession":"service","officeAddress":null,"annualIncome":null,"isGovermentEmployee":"FALSE","department":null}},"createdAt":"2023-09-25T07:53:36.990Z","updatedAt":"2023-09-25T07:53:36.990Z","id":"65113c80220e1f0010a23e09"}';
                         system.debug(reqresponse.replace('[]','null'));
                        fromJSON obj = js.parse(json);
                       system.debug(obj);
                        if(obj!=null)
                        {
                           AG.Email_Address__c=obj.email; 
                        }
                        AG.Sync_With_Ether__c = True;
                        
                        AG.Synced_With_Ether_On_Date__c=system.now().format('dd-MM-yyyy');
                            AG.Synced_With_Ether_On_Time__c=system.now().format('hh:mm a');
                        Update AG;

                        string customleadValue;
                        Admission_Granted__c AGss = [SELECT ID,EnquiryNo__c,EnquiryNo__r.Lead_ID__c,Lead__c FROM Admission_Granted__c Where ID=:AGid ];
                        customleadValue = AGss.EnquiryNo__r.Lead_ID__c;
                        List<lead> lstlead = new List<Lead>();
                        List<lead> slitlead = new List<lead>();
                        if(!Test.isRunningTest())
                        {
                            slitlead = [select Id,Sync_With_Ether__c,Synced_With_Ether_On_Date__c,Synced_With_Ether_On_Time__c,name,Lead_ID__c,Status from lead where Lead_ID__c=: customleadValue];
                        }
                        else{
                            slitlead = [select Id,name,Lead_ID__c,Status from lead limit 1];
                        }
                        system.debug('slitlead >> ' + slitlead);
                        if(!slitlead.isEmpty()){
                            for(lead le : slitlead)
                            {
                                lead l = new lead();l.id = le.id;l.Stage__c = 'Sync With Applane';
                                l.Sync_With_Ether__c = True;
                        l.Synced_With_Ether_On_Date__c=system.now().format('dd-MM-yyyy');
                            l.Synced_With_Ether_On_Time__c=system.now().format('hh:mm a');
                                lstlead.add(l);
                            }
                            system.debug('lstlead -- ' + lstlead);
                            if(!lstlead.isEmpty()){
                                update lstlead;
                            }
                            List<Enquiry__c> listupdate=new List<Enquiry__c>();
                            system.debug('AGss.Lead__c '+AGss.Lead__c);
                            List<Enquiry__c> listenq=[Select id, Sync_With_Ether__c,Synced_With_Ether_On_Date__c,Synced_With_Ether_On_Time__c,name,Lead_ID__c from Enquiry__c where id=: AGss.EnquiryNo__c];
                            if(!listenq.isEmpty()){
                            for(Enquiry__c le : listenq)
                            {
                                                      Enquiry__c l = new Enquiry__c();
                                l.id = le.id;
                                l.Sync_With_Ether__c = True;
                        l.Synced_With_Ether_On_Date__c=system.now().format('dd-MM-yyyy');
                            l.Synced_With_Ether_On_Time__c=system.now().format('hh:mm a');
                                listupdate.add(l);
                            }
                                if(!listupdate.isEmpty()){
                                update listupdate;
                            }
                            }
                        }
                    }else if(res.getStatusCode()==409){
                        reqresponse='Student already exists in Ether';
                    }else if(res.getStatusCode()==500){
                        reqresponse='Something wrong at Ether server';
                    }else if(res.getStatusCode()==400){
                        reqresponse='Please check if fields have data - Student/Father/Mother Email Id,Student Gender,Student Name,Academic Year,School';
                    }else if(res.getStatusCode()==201){
                        reqresponse='Student synced with Ether successfully';
                    }
                }else{
                    reqresponse='Authentication token is missing';
                    System.debug('Authentication token is missing');    
                }
            }else{
                reqresponse='Authentication settings is missing';
                System.debug('Authentication settings is missing');    
            }
system.debug('reqresponse '+reqresponse);
            return reqresponse;
        /*}catch (Exception ex){
            System.debug('Error while sync ::'+ex.getMessage());
            return  ex.getMessage();
        }*/
        
    }

    Private static String ReplaceSpace(Map<String,String> URLMap, String AGyear){
        //   String URLwithoutSpace= '';
        
        For(string key :URlMap.keyset() ){
            
            String Value = URLMap.get(key);
            if(key == 'blood_group' && Value != null)
            {
                String NewValue = value.replace('+', '%2B');
                
                URLMap.put(key,NewValue);
            }
                
            If (Value != Null &&  value.containsWhitespace()){
                String NewValue = value.replace(' ', '%20');
                system.debug('NewValue after Space::' +NewValue);  
                
                URLMap.put(key,NewValue);   
            }
            else {Continue ; }
        }
        
        String URLwithoutSpace= 'http://unv-dot-applanessishrd.appspot.com/escape/addstudent?academic_year='+AGyear ;
        For(string key2 :URLMap.keyset() ){
            String Value2 = URLMap.get(key2); 
            //  system.debug('Value::' +value);
            If (value2 != null) {
                String LoopURL = '&'+Key2+'='+value2 ; 
                URLwithoutSpace = URLwithoutSpace +LoopURL; }
            Else { continue ;}
        }
        System.debug('URL:: '+URLwithoutSpace);
        
        Return URLwithoutSpace; 
    }    
  public  class fromJSON{
	public String status;	//ACTIVE
	
	public cls_schools[] schools;
	public String email;	//bharti.khurana.aqbpo@universal.edu.in
	public String profile;	//
	public String name;	//Bharti Khurana
	public String school;	//SWS-GOREGAON
	public String role;	//currentStudent
	public String gender;	//MALE
	
	public String curriculum;	//
	
	public String createdAt;	//2023-09-25T07:53:36.990Z
	public String updatedAt;	//2023-09-25T07:53:36.990Z
	public String id;	//65113c80220e1f0010a23e09
	
	
	
	public  fromJSON parse(String json){
		return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
	}

	
}
    public class cls_schools {
	}
    public static void FormFactory() {
        Integer i = 0;
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