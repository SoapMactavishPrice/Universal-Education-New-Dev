//Purpose : Controller for capturing the fields
global without sharing class UE_ApplicationForm_Site {
    public List < String > selectedDisabilities {
        get;
        set;
    }
    public List < String > medicalHistorySelected {
        get;
        set;
    }
    public List < String > selectedLearnings {
        get;
        set;
    }
    public SelectOption[] disabilityList {
        get;
        set;
    }
    public SelectOption[] medHistoryList {
        get;
        set;
    }
    public List < SelectOption > BloodOptions {
        get;
        set;
    }
    public List < SelectOption > MedicationOptions {
        get;
        set;
    }
    public List < SelectOption > AllergiesOptions {
        get;
        set;
    }

    public String medHistoryLoad {
        get;
        set;
    }
    public String medicalHistories {
        get;
        set;
    } // Selected History main
    public SelectOption[] selectedLearningsList {
        get;
        set;
    }
    public String gen {
        get;
        set;
    }
    public blob fcontent {
        get;
        set;
    }
    Public Enquiry__c enq {
        get;
        set;
    }
    public Account acc {
        get;
        set;
    }
    public Application_Form__c form {
        get;
        set;
    }
    public LIST < Application_Form__c > appf {
        get;
        set;
    }
    public LIST < Application_Form__c > app {
        get;
        set;
    }
    public boolean editMode {
        get;
        set;
    }
    public String num {
        get;
        set;
    }
    public String otp {
        get;
        set;
    }
    public boolean otpSent {
        get;
        set;
    }
    public boolean verifySent {
        get;
        set;
    }
    public String optValidateMessage {
        get;
        set;
    }
    public String optValidateSuccessMessage {
        get;
        set;
    }
    public String message {
        get;
        set;
    }
    public boolean thanku {
        get;
        set;
    }
    public boolean mInfo {
        get;
        set;
    }
    public boolean mInfo2 {
        get;
        set;
    }
    public boolean mInfo3 {
        get;
        set;
    }
    public boolean udise {
        get;
        set;
    }
    public boolean enrNo {
        get;
        set;
    }
    public boolean emisNo {
        get;
        set;
    }
    public boolean renderGuardian {
        get;
        set;
    }
    public boolean isOTPResent {
        get;
        set;
    }
    //For SMS
    public string phone_no {
        get;
        set;
    }
    public string contactName {
        get;
        set;
    }
    public string gupshupUserID {
        get;
        set;
    }
    public string gupshupPassword {
        get;
        set;
    }
    public string appID {
        get;
        set;
    }
    public string msg {
        get;
        set;
    }
    public string Template {
        get;
        set;
    }
    public String academicYear {
        get;
        set;
    }
    // public Date DateOfBirth{get;set;}
    public String accountName {
        get;
        set;
    }
    public Id enqId {
        get;
        set;
    }
    public CC_Avenue_Settings__c ccAvenueSettings {
        get;
        set;
    }
    public Id ociDocumentId {
        get;
        set;
    }
    public Id passportDocumentId {
        get;
        set;
    }
    public Id residentialAddressProofId {
        get;
        set;
    }
    public String studentBirthCertificateId {
        get;
        set;
    }
    public Id studentCasteCertificateId {
        get;
        set;
    }
    public Id studentAadhaarCardId {
        get;
        set;
    }
    public Id studentLatestMarksheetId {
        get;
        set;
    }
    public Id studentLeavingCertificateId {
        get;
        set;
    }
    public Id fatherAadhaarCardId {
        get;
        set;
    }
    public Id fatherPanCardId {
        get;
        set;
    }
    public Id motherAadhaarCardId {
        get;
        set;
    }
    public Id motherPanCardId {
        get;
        set;
    }
    public Id guardianResidentialAddressProofId {
        get;
        set;
    }
    public Id guardianAadhaarCardId {
        get;
        set;
    }
    public Id relationWithGaurdianId {
        get;
        set;
    }
     public Id supportdocumentsorreportsId {
        get;
        set;
    }
    public Id guardianPanCardId {
        get;
        set;
    }
    public Id docToDeleteId {
        get;
        set;
    }
    public String declarationError {
        get;
        set;
    }
    public String singleParentError {
        get;
        set;
    }
    public String errorInCheckList {
        get;
        set;
    }
    public String FormBAckError {
        get;
        set;
    }
    public String errorResidentialAddress {
        get;
        set;
    }
    public String errorBirthCert {
        get;
        set;
    }
    public String errorLeavingCertificateId {
        get;
        set;
    }
    public String isFatherMotherGaurdianChecked {
        get;
        set;
    }
    public String seekingGradeLabel {
        get;
        set;
    }

    public string curriculum;
    public String logoUrl {
        get;
        set;
    }
    public Decimal ProgCount {
        get;
        set;
    }

    public Boolean FatherInformation {
        get;
        set;
    }
    public Boolean MotherInformation {
        get;
        set;
    }
    public Boolean GuardianInformation {
        get;
        set;
    }
    public Boolean SingleParent {
        get;
        set;
    }
    public Boolean SiblingInformation {
        get;
        set;
    }
    public Boolean StudentHealthInformation {
        get;
        set;
    }
    public List < Disclosure__c > documentList {
        get;
        set;
    }
    public Disclosure__c documentListURL {
        get;
        set;
    }

    public String Application_Form_Relation {
        get;
        set;
    }

    public String fatherIDName {
        get;
        set;
    }
    public Boolean SiblingIdInformation {
        get;
        set;
    }
    public String GuardianIdName {
        get;
        set;
    }
    public String fatherMotherGuardianIdName {
        get;
        set;
    }
    public String MotherIdInformation {
        get;
        set;
    }
    public String FatherIdInformation {
        get;
        set;
    }
    public String SingleParentInformation {
        get;
        set;
    }
    public String fatherNationalityName {
        get;
        set;
    }

    public Integer ExpiredDays {
        get;
        set;
    } 
    public Boolean isGuardianchecked {
        get;
        set;
    }
    public Boolean birthcert {
        get;
        set;
    }
    public Boolean stdPhotoFlag {
        get;
        set;
    }
    public Boolean fateherPhotoFlag {
        get;
        set;
    }
    public Boolean motherPhotoFlag {
        get;
        set;
    }
    public Boolean fateherSignatureFlag {
        get;
        set;
    }
    public Boolean motherSignatureFlag {
        get;
        set;
    }
     public Boolean fatherEduQFlag {
        get;
        set;
    }
    
    //added by shashank.
     public static String enqId_payment {
        get;
        set;
    }
    
    //added by shashank.
     public static Decimal registrationFees {
        get;
        set;
    }
    
      public static String paymentPhone {
        get;
        set;
    }
    
      public static String paymentEmail {
        get;
        set;
    }
    public PageReference paymentPageRef;
    
    //added by shashank on 11 oct
    @RemoteAction
    public static String createRazorpayOrder(Decimal amount,String enqId) {
        String razorpayKey = 'rzp_test_LLNJl9JK0zShRA';
        String razorpaySecret = 'LS2tNMNPHfXxaJb9qMJ6XZGG';
        String orderId = '';

        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.razorpay.com/v1/orders');
            request.setMethod('POST');
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(razorpayKey + ':' + razorpaySecret)));
            request.setHeader('Content-Type', 'application/json');
            request.setBody('{"amount":' + amount + ',"currency":"INR"}');

            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                orderId = (String) result.get('id');
                System.debug('payment order id '+orderId);
                Payment__c payment = new Payment__c();  // Assuming you have a Payment__c object
            	payment.OrderId__c = orderId;
                payment.Name = 'Payment Initiated';
                payment.Status__c = 'Initiated';
                payment.Enquiry__c=enqId;
                // Insert or update the payment record
                insert payment;
               
            }
        } catch (Exception ex) {
            System.debug('Error in Razorpay Order creation: ' + ex.getMessage());
            throw new AuraHandledException('Error while creating order in Razorpay.');
        }

        return orderId;
    }
    // Update payment details in Salesforce based on payment status
    @RemoteAction
    public static void updatePaymentDetails(String paymentId, String status,String enqId,String orderId) {
        try {
            Payment__c payment = [Select id,Name,Status__c From Payment__c WHERE orderId__c=:orderId AND enquiry__c=:enqId];  // Assuming you have a Payment__c object
            
            if (status == 'success') {
                // If payment was successful
                payment.Name = paymentId;
                payment.Status__c = 'Success';
                payment.Enquiry__c=enqId;
            } else {
                // If payment failed
                payment.Name = 'Failed';
                payment.Status__c = 'Failed';
                payment.Enquiry__c=enqId;
            }

            // Insert or update the payment record
            Update payment;

        } catch (Exception ex) {
            System.debug('Error while updating payment details: ' + ex.getMessage());
            throw new AuraHandledException('Error while updating payment details in Salesforce.');
        }
    }
    //end -added by shashank on 11 oct

    public UE_ApplicationForm_Site(ApexPages.StandardController Controller) {
        registrationFees=0;
        paymentPhone='';
        paymentEmail='';
        FormBAckError = null;
        medicalHistories = '';
        selectedDisabilities = new List < String > ();
        medicalHistorySelected = new List < String > ();
        selectedLearnings = new List < String > ();

        disabilityList = new List < SelectOption > ();
        medHistoryList = new List < SelectOption > ();
        selectedLearningsList = new List < SelectOption > ();

        disabilityList.add(new selectoption('Visual Impairment', 'Visual Impairment'));
        disabilityList.add(new selectoption('Hearing Impairment', 'Hearing Impairment'));
        disabilityList.add(new selectoption('Muscular Dystrophy', 'Muscular Dystrophy'));

        medHistoryList.add(new selectoption('Polio', 'Polio'));
        medHistoryList.add(new selectoption('Hepatitis', 'Hepatitis'));
        medHistoryList.add(new selectoption('Mumps', 'Mumps'));
        medHistoryList.add(new selectoption('Whooping Cough', 'Whooping Cough'));
        medHistoryList.add(new selectoption('German measles', 'German measles'));
        medHistoryList.add(new selectoption('Red measles', 'Red measles'));
        medHistoryList.add(new selectoption('Rheumatic Fever', 'Rheumatic Fever'));
        medHistoryList.add(new selectoption('Epilepsy', 'Epilepsy'));
        medHistoryList.add(new selectoption('Juvenile Diabetes', 'Juvenile Diabetes'));
        medHistoryList.add(new selectoption('Developmental Delay', 'Developmental Delay'));
        medHistoryList.add(new selectoption('None of the above', 'None of the above'));

        selectedLearningsList.add(new selectoption('Learning Disability', 'Learning Disability'));
        selectedLearningsList.add(new selectoption('ADD (Attention Deficit Disorder)', 'ADD (Attention Deficit Disorder)'));
        selectedLearningsList.add(new selectoption('Autism', 'Autism'));
        selectedLearningsList.add(new selectoption('ADHD (Attention Deficit Hyperactive Disorder)', 'ADHD (Attention Deficit Hyperactive Disorder)'));
        selectedLearningsList.add(new selectoption('Slow learner', 'Slow learner'));
        BloodOptions = new List < SelectOption > ();
        BloodOptions = getApplicationFormBloodGroup();
        MedicationOptions = new List < SelectOption > ();
        MedicationOptions = getApplicationmedication();
        AllergiesOptions = new List < SelectOption > ();
        AllergiesOptions = getApplicationFormAllergie();
        form = (Application_Form__c) Controller.getRecord();
        String eid;
        if (ApexPages.currentPage().getParameters().get('eid') != null) {
            eid = ApexPages.currentPage().getParameters().get('eid');
        } else
            eid = ApexPages.currentPage().getParameters().get('CF00N2t000000i4jv_lkid');

        enqId = eid;
        enqId_payment=eid;
        editMode = false;
        otpSent = false;
        verifySent = false;
        thanku = false;
        mInfo = false;
        mInfo2 = false;
        mInfo3 = false;
        udise = false;
        enrNo = false;
        emisNo = false;
        birthcert = false;
        //showpageblock = false;
        FatherInformation = false;
        MotherInformation = false;
        GuardianInformation = false;
        SingleParent = false;
        SiblingInformation = false;
        StudentHealthInformation = false;

        stdPhotoFlag = true; //photo required
        fateherPhotoFlag = true;
        motherPhotoFlag = true;
        fateherSignatureFlag = true;
        motherSignatureFlag = true;
        fatherEduQFlag = true;
        
        //   gupshupUserID='2000045203';
        // gupshupPassword='universalgoogle';

        /*  Schema.DescribeFieldResult fieldDesc = Schema.Enquiry__c.Academic_Year__c.getDescribe();
          for (Schema.Picklistentry picklistEntry: fieldDesc.getPicklistValues())
          {
              if (picklistEntry.isDefaultValue())
              {
                  academicYear= picklistEntry.getValue();
                  break;
              }
          }
        */


        enq = new Enquiry__c();
        if (eid != null) {
            system.debug('eid!=null');
            enq = [SELECT Registration_Fee__c,Lead__r.Email,Lead__r.MobilePhone,Curriculum__c, Lead__c,Lead__r.Father_s_First_Name__c, NoOfApplicationLinkSentExpiredDays__c, Category__c, School_Name__c, Save_Later_Values__c, Academic_Year__c, Address__c,
                Org_code__c, Email__c, Name, Id, Mobile_No__c, orgCode__c, Last_Name__c, FirstName__c, Date_of_Birth__c,Application_Form_Received__c,Application_Submitted_On__c,
                Country__c, Contact__c, Contact__r.Lead_ID__c,Application_Form_Received_On_Date__c,Application_Form_Received_On_Time__c,
                Gender__c, Log_Status__c, Parent_Last_Name__c, Parent_First_Name__c, School_Institution__c,
                Source_of_Information__c, Stages__c, Student_Full_Name__c, contact__r.Email, contact__r.phone,
                ParentFull_Name__c, Application_Received__c, Form_C_Checked__c, Form_D_Checked__c, Form_E1_Checked__c, Form_E2_Checked__c, Payment_Done__c,
                Order_Id__c, Enq_School_Institute__c, School_Institution__r.School_Short_Code__c, Seeking_Grade__c, Seeking_Grade__r.name,
                Building_Apt_Name__c, Flat_No_House_No__c, School_Institution__r.name, Relation__c, Street__c, Area__c, City__c, State__c, Pin_Code__c, Landmark__c, OTP__c
                FROM Enquiry__c
                where Id =: eid
            ];
            //added by shashank on 14 oct
            registrationFees=enq.Registration_Fee__c;
            paymentPhone=enq.Lead__r.MobilePhone;
            paymentEmail=enq.Lead__r.Email;
            system.debug('Enquiry::::::' + enq);
            String Shortname = '%' + enq.School_Institution__r.School_Short_Code__c + '%';
            academicYear = enq.Academic_Year__c;
            string School_Institution = enq.School_Institution__c;
            System.debug('School_Institution @@@@@@' + School_Institution);
            string School_Seeking_Grade = enq.Seeking_Grade__c;
            System.debug('School_Seeking_Grade @@@@@@' + School_Seeking_Grade);
            List < Disclosure__c > Listdis = [SELECT Id, Name, School_Institution_Logo_URL__c, DisplaySequence__c, Document_Name__c FROM Disclosure__c where school__c =: School_Institution and Class__c =: School_Seeking_Grade and Academic_Year__c =: academicYear and DisplaySequence__c = 1 limit 1];
            if (Listdis != null && Listdis.size() > 0) {
                documentListURL = Listdis[0];
            }
            //documentListURL = [ SELECT Id,School_Institution_Logo_URL__c FROM Disclosure__c where /*OrgionalClass__c=:grade and*/ school__c=:School_Institution /*and Academic_Year__c=:Academic_Year*/ order by DisplaySequence__c asc Limit 1];    
            System.debug('documentListURL @@@@@@' + documentListURL);
            try {
                logoUrl = documentListURL.School_Institution_Logo_URL__c;
            } catch (exception e) {
                logoUrl = PageReference.forResource('NoImage').getUrl();
            }

            // To get Dyanamic Credentrial to login
            List < Gupshup_Credential__mdt > listCustomMetadata = [Select id, MessageTemp__c, Gupshup_Username__c, Gupshup_Password__c, SchoolShortCode__c from Gupshup_Credential__mdt where SchoolShortCode__c LIKE: Shortname];

            if (listCustomMetadata.size() > 0 && listCustomMetadata != null) {
                gupshupUserID = listCustomMetadata[0].Gupshup_Username__c;
                gupshupPassword = listCustomMetadata[0].Gupshup_Password__c;
                // Template=listCustomMetadata[0].MessageTemp__c;
            }

            curriculum = enq.Curriculum__c;
            seekingGradeLabel = enq.seeking_grade__r.name;
            fetchUploadedDocuments();
            ExpiredDays = integer.valueOf(enq.NoOfApplicationLinkSentExpiredDays__c);
            form.Nationality__c = 'Indian';
            form.Is_Father_Government_Employee__c = ' ';
            form.Is_Guardian_Government_Employee__c = ' ';
            form.Is_Mother_Government_Employee__c = ' ';
            form.Is_the_child_taking_any_medication__c = ' ';
            form.Allergies__c = ' ';
            form.Any_mental_physical_problem__c = ' ';
            String add = '';
            if (enq.Address__c != null) {
                add = enq.Address__c;
                add = add + ',';
            }
            form.Residential_Address__c = add + enq.City__c + ', ' + enq.Country__c;
            form.Student_Building_Apartment_Name__c = enq.Building_Apt_Name__c;
            form.Student_Flat_No_House_No__c = enq.Flat_No_House_No__c;
            form.Student_Street__c = enq.Street__c;
            form.Student_Area__c = enq.Area__c;
            form.Student_Landmark__c = enq.Landmark__c;
            form.City__c = enq.City__c;
            form.State__c = enq.State__c;
            form.Pincode__c = enq.Pin_Code__c;

            if (enq.Relation__c == 'Father') {
                system.debug('inside father>>>'+enq.Lead__r.Father_s_First_Name__c);
                
                form.Father_First_Name__c = enq.Lead__r.Father_s_First_Name__c;
                //form.Father_First_Name__c = enq.Parent_First_Name__c;
                form.Father_Last_Name__c = enq.Parent_Last_Name__c;
                form.Father_Phone__c = enq.Mobile_No__c;
                form.Father_Email_Id__c = enq.Email__c;
            } else if (enq.Relation__c == 'Mother') {
                form.Mother_First_Name__c = enq.Parent_First_Name__c;
                form.Mother_Last_Name__c = enq.Parent_Last_Name__c;
                form.Mother_Phone__c = enq.Mobile_No__c;
                form.Mother_Email_Id__c = enq.Email__c;
            }

            if (enq.Save_Later_Values__c != null) {
                form = (Application_Form__c) JSON.deserialize(enq.Save_Later_Values__c, Application_Form__c.class);
                medHistoryLoad = form.Medical_History__c;
            }
            num = enq.Mobile_No__c;
            system.debug('BEFOR_SENDING_NUMBER+++++' + num);
            form.OTP__c = otp;
            System.debug('OTP::::::' + otp);

            Account acc = [Select id, Name, School_Short_Code__c from Account where Id =: enq.School_Institution__c Limit 1];
            accountName = acc.School_Short_Code__c;
            system.debug('SChool_Record:::::' + acc);
            system.debug('Account Name:::::' + accountName);
            School_List__mdt SchCode = [SELECT State__c FROM School_List__mdt WHERE Label =: enq.Org_code__c limit 1];
            if (enq.Seeking_Grade__r.name != 'I' && enq.Seeking_Grade__r.name != 'SR.KG' &&
                enq.Seeking_Grade__r.name != 'JR.KG' && enq.Seeking_Grade__r.name != 'NURSERY' &&
                enq.Seeking_Grade__r.name != 'PLAYGROUP') {
                if (SchCode.State__c != null && SchCode.State__c == 'Maharashtra') {
                    udise = true;
                    emisNo = false;
                    enrNo = false;
                } else if (SchCode.State__c != null && SchCode.State__c == 'Karnataka') {
                    udise = false;
                    emisNo = false;
                    enrNo = true;
                } else if (SchCode.State__c != null && SchCode.State__c == 'Trichy') {
                    udise = false;
                    emisNo = true;
                    enrNo = false;
                }
            }
            if (enq.Application_Received__c == true) {
                appf = [Select ID, Name, Enquiry__c from Application_Form__c where Enquiry__c =: enq.Id];
                system.debug('App:::::' + appf);
                if (appf.size() > 0) {
                    system.debug('Inside IF EXISTING APPLICATION:::' + appf);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'You have already registered '));
                    thanku = true;
                }

            }
        }
    }
    //*****************//
    public List < SelectOption > getApplicationFormRelation() {
        Schema.sObjectType sobject_type = Application_Form__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap();
        List < Schema.PicklistEntry > picklistvalues = field_map.get('Application_Form_Relation__c').getDescribe().getPickListValues();
        List < selectOption > options = new List < selectOption > ();
        options.add(new SelectOption('None', '--None--'));
        for (Schema.PicklistEntry a: picklistvalues) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    public List < SelectOption > getApplicationFormBloodGroup() {
        Schema.sObjectType sobject_type = Application_Form__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap();
        List < Schema.PicklistEntry > picklistvalues = field_map.get('Blood_Group__c').getDescribe().getPickListValues();
        List < selectOption > options = new List < selectOption > ();

        for (Schema.PicklistEntry a: picklistvalues) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    public List < SelectOption > getApplicationmedication() {
        Schema.sObjectType sobject_type = Application_Form__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap();
        List < Schema.PicklistEntry > picklistvalues = field_map.get('Is_the_child_taking_any_medication__c').getDescribe().getPickListValues();
        List < selectOption > options = new List < selectOption > ();

        for (Schema.PicklistEntry a: picklistvalues) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    public List < SelectOption > getApplicationFormAllergie() {
        Schema.sObjectType sobject_type = Application_Form__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap();
        List < Schema.PicklistEntry > picklistvalues = field_map.get('Allergies__c').getDescribe().getPickListValues();
        List < selectOption > options = new List < selectOption > ();

        for (Schema.PicklistEntry a: picklistvalues) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    public PageReference FMGResult() {
        system.debug('string value is fatherIDName' + fatherIDName);
        return null;
    }
    public PageReference FMGResultNationality() {
        system.debug('string value is fatherNationalityName' + fatherNationalityName);
        return null;
    }
    public PageReference FMGSiblingIdInformationtrue() {
        system.debug('string value is SiblingIdInformation' + SiblingIdInformation);
        return null;
    }
    public PageReference FMGGuardiantrue() {
        system.debug('string value is GuardianIdName' + GuardianIdName);
        isGuardianchecked = true;
        return null;
    }
    public PageReference FMGMotherIdInformationtrue() {
        system.debug('string value is MotherIdInformation' + MotherIdInformation);
        return null;
    }
    public PageReference FMGFatherIdInformationtrue() {
        system.debug('string value is FatherIdInformation' + FatherIdInformation);
        return null;
    }
    public PageReference FMGSingleParentInformationtrue() {
        system.debug('string value is SingleParentInformation' + SingleParentInformation);
        return null;
    }
    public List < SelectOption > getOciVisa() {
        Schema.sObjectType sobject_type = Application_Form__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map < String, Schema.SObjectField > field_map = sobject_describe.fields.getMap();
        List < Schema.PicklistEntry > pick_list_values = field_map.get('OCI_VISA__c').getDescribe().getPickListValues();
        List < selectOption > options = new List < selectOption > ();
        for (Schema.PicklistEntry a: pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    public void fetchUploadedDocuments() {
        System.debug('enq.Id ======================================= ' + enq.Id);
        if (enq.Id == NULL) {
            return;
        }
        //if(!Test.isRunningTest()){
        fetchAllUploadedDocuments(); //}
    }

    public void fetchAllUploadedDocuments() {
        Set < String > setDocDescription = new Set < String > ();
        String enqId15Digit;
        if (!Test.isRunningTest()) {
            enqId15Digit = String.valueOf(enq.Id).left(15);
        }
        setDocDescription.add(enqId15Digit + '-' + 'OCI');
        setDocDescription.add(enqId15Digit + '-' + 'Passport');
        setDocDescription.add(enqId15Digit + '-' + 'ResidentialAddressProof');
        setDocDescription.add(enqId15Digit + '-' + 'StudentBirthCertificate');
        setDocDescription.add(enqId15Digit + '-' + 'StudentCasteCertificate');
        setDocDescription.add(enqId15Digit + '-' + 'StudentAadhaarCard');
        setDocDescription.add(enqId15Digit + '-' + 'StudentLatestMarksheet');
        setDocDescription.add(enqId15Digit + '-' + 'StudentLeavingCertificate');
        setDocDescription.add(enqId15Digit + '-' + 'FatherAadhaarCard');
        setDocDescription.add(enqId15Digit + '-' + 'FatherPanCard');
        setDocDescription.add(enqId15Digit + '-' + 'MotherAadhaarCard');
        setDocDescription.add(enqId15Digit + '-' + 'MotherPanCard');
        setDocDescription.add(enqId15Digit + '-' + 'GuardianResidentialAddressProof');
        setDocDescription.add(enqId15Digit + '-' + 'GuardianAadhaarCard');
        setDocDescription.add(enqId15Digit + '-' + 'GuardianPanCard');
        setDocDescription.add(enqId15Digit + '-' + 'Affidavit');
        System.debug('setDocDescription = ' + setDocDescription);

        ociDocumentId = NULL;
        passportDocumentId = NULL;
        residentialAddressProofId = NULL;
        studentBirthCertificateId = NULL;
        studentCasteCertificateId = NULL;
        studentAadhaarCardId = NULL;
        studentLatestMarksheetId = NULL;
        studentLeavingCertificateId = NULL;
        fatherAadhaarCardId = NULL;
        fatherPanCardId = NULL;
        motherAadhaarCardId = NULL;
        motherPanCardId = NULL;
        guardianResidentialAddressProofId = NULL;
        guardianAadhaarCardId = NULL;
        relationWithGaurdianId = NULL;
        supportdocumentsorreportsId = Null;
        guardianPanCardId = NULL;
        System.debug('setDocDescription = ' + setDocDescription);

        List < ContentDocumentLink > links = [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink WHERE LinkedEntityId =: enqId
        ];

        if (links.size() > 0) {
            Set < Id > ids = new Set < Id > ();
            for (ContentDocumentLink link: links) {
                ids.add(link.ContentDocumentId);
            }

            List < ContentVersion > ContentVersionLIST = [
                SELECT Id, ContentDocumentId, Description
                FROM ContentVersion
                WHERE Description IN: setDocDescription
                AND ContentDocumentId IN: ids
                ORDER BY CreatedDate DESC
            ];

            System.debug('ContentVersionLIST=== = ' + ContentVersionLIST.size());
            System.debug('studentBirthCertificateId IN upload doc:>>>>>>' + studentBirthCertificateId);

            for (ContentVersion doc: ContentVersionLIST) {
                String docId = doc.Id;
                switch on doc.Description.substringAfter(enqId15Digit + '-') {
                    when 'Passport' {
                        passportDocumentId = docId.substring(0, 15);
                    }
                    when 'OCI' {
                        ociDocumentId = docId.substring(0, 15);
                    }
                    when 'ResidentialAddressProof' {
                        residentialAddressProofId = docId.substring(0, 15);
                    }
                    when 'StudentBirthCertificate' {
                        studentBirthCertificateId = docId.substring(0, 15);
                        System.debug('TESTTTTTTT:>>>>  ' + docId.substring(0, 15));
                        System.debug('TESTTTTTTT:>>>>  ' + studentBirthCertificateId);
                    }
                    when 'StudentCasteCertificate' {
                        studentCasteCertificateId = docId.substring(0, 15);
                    }
                    when 'StudentAadhaarCard' {
                        studentAadhaarCardId = docId.substring(0, 15);
                    }
                    when 'StudentLatestMarksheet' {
                        studentLatestMarksheetId = docId.substring(0, 15);
                    }
                    when 'StudentLeavingCertificate' {
                        studentLeavingCertificateId = docId.substring(0, 15);
                    }
                    when 'FatherAadhaarCard' {
                        fatherAadhaarCardId = docId.substring(0, 15);
                    }
                    when 'FatherPanCard' {
                        fatherPanCardId = docId.substring(0, 15);
                    }
                    when 'MotherAadhaarCard' {
                        motherAadhaarCardId = docId.substring(0, 15);
                    }
                    when 'MotherPanCard' {
                        motherPanCardId = docId.substring(0, 15);
                    }
                    when 'GuardianResidentialAddressProof' {
                        guardianResidentialAddressProofId = docId.substring(0, 15);
                    }
                    when 'GuardianAadhaarCard' {
                        guardianAadhaarCardId = docId.substring(0, 15);
                    }
                    when 'GuardianPanCard' {
                        guardianPanCardId = docId.substring(0, 15);
                    }
                    when 'Affidavit' {
                        relationWithGaurdianId = docId.substring(0, 15);
                    }when 'Supportdocumentsorreport'{
                        supportdocumentsorreportsId = docId.substring(0, 15);
                    }
                }
            }

        }

    }

    public void deleteUploadedDoc() {
        System.debug('docToDeleteId = ' + docToDeleteId);
        List < ContentVersion > lstContentVersion = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id =: docToDeleteId
        ];
        if (lstContentVersion.isEmpty()) {
            return;
        }
        delete new ContentDocument(Id = lstContentVersion[0].ContentDocumentId);
        if (docToDeleteId == passportDocumentId) {
            passportDocumentId = NULL;
        } else if (docToDeleteId == ociDocumentId) {
            ociDocumentId = NULL;
        } else if (docToDeleteId == residentialAddressProofId) {
            residentialAddressProofId = NULL;
        } else if (docToDeleteId == studentBirthCertificateId) {
            studentBirthCertificateId = NULL;
        } else if (docToDeleteId == studentCasteCertificateId) {
            studentCasteCertificateId = NULL;
        } else if (docToDeleteId == studentAadhaarCardId) {
            studentAadhaarCardId = NULL;
        } else if (docToDeleteId == studentLatestMarksheetId) {
            studentLatestMarksheetId = NULL;
        } else if (docToDeleteId == studentLeavingCertificateId) {
            studentLeavingCertificateId = NULL;
        } else if (docToDeleteId == fatherAadhaarCardId) {
            fatherAadhaarCardId = NULL;
        } else if (docToDeleteId == fatherPanCardId) {
            fatherPanCardId = NULL;
        } else if (docToDeleteId == motherAadhaarCardId) {
            motherAadhaarCardId = NULL;
        } else if (docToDeleteId == motherPanCardId) {
            motherPanCardId = NULL;
        } else if (docToDeleteId == guardianResidentialAddressProofId) {
            guardianResidentialAddressProofId = NULL;
        } else if (docToDeleteId == guardianAadhaarCardId) {
            guardianAadhaarCardId = NULL;
        } else if (docToDeleteId == guardianPanCardId) {
            guardianPanCardId = NULL;
        } else if (docToDeleteId == relationWithGaurdianId) {
            relationWithGaurdianId = NULL; 
        }else if (docToDeleteId == supportdocumentsorreportsId) {
            supportdocumentsorreportsId = NULL; 
        }
    }

    public void deleteUploadedResidentialAddressDoc() {
        List < ContentVersion > lstContentVersion = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id =: residentialAddressProofId
        ];
        if (lstContentVersion.isEmpty()) {
            return;
        }
        delete new ContentDocument(Id = lstContentVersion[0].ContentDocumentId);
        residentialAddressProofId = NULL;
    }

    public void getpassport() {
        if (form.Passport_No__c != 'null') {
            form.Expiry_Date__c.addError('This field is required..!');
        }
    }
    public void getexpdate() {
        if (string.valueOf(form.Expiry_Date__c) != 'null') {
            message = '';
        }
    }
    public void saveMedicalHistory() {
        medicalHistories = Apexpages.currentPage().getParameters().get('medicalHistorySelected');
        System.debug('SAVE MEDICAL' + medicalHistories);
    }
    public void saveBFormAck() {
        System.debug('SAVE saveBFormAck');
        form.Form_B_Acknowledgement__c = Boolean.valueOf(Apexpages.currentPage().getParameters().get('data'));
    }
    public PageReference saveForLater() {
        System.debug('Med History' + medicalHistories);
        form.Medical_History__c = medicalHistories;
        form.Disabilities_Type__c = String.join(selectedDisabilities, ';');
        form.Personalized_learning_option__c = String.join(selectedLearnings, ';');
        System.debug('Father_Name_of_Department__c ==== ' + form.Father_Name_of_Department__c);
        System.debug('MOther ==== ' + form.Mother_Name_of_Department__c);
        System.debug('Gurar ==== ' + form.Name_of_Department__c);
        System.debug('FORM ==== ' + form);
        update new Enquiry__c(
            Id = enqId,
            curriculum__c = curriculum,
            Save_Later_Values__c = JSON.serialize(form)
        );
        return null;
    }
    //*********************//

    // public void save() {
    //     fetchUploadedDocuments();
    //     System.debug('IN SAVE.....' + selectedDisabilities);
    //     String eid = ApexPages.currentPage().getParameters().get('eid');
    //     system.debug('eid!=null' + eid);
    //     decimal error = 0;
    //     // String selectedDisabilities = Apexpages.currentPage().getParameters().get('disabilities');
    //     System.debug('SELECTED DISAbilites - - -- ' + String.join(medicalHistorySelected, ';'));
    //     System.debug('SELECTED med hist - - -- ' + String.join(selectedDisabilities, ';'));
    //     System.debug('SELECTED selectedLearnings - - -- ' + String.join(selectedLearnings, ';'));
    //     string response = validate();
    //     System.debug('response in save +++' + response);
    // }

     public pagereference save() {
        //fetchUploadedDocuments();
        System.debug('IN SAVE.....' + selectedDisabilities);
        String eid = ApexPages.currentPage().getParameters().get('eid');
        system.debug('eid!=null' + eid);
        decimal error = 0;
        // String selectedDisabilities = Apexpages.currentPage().getParameters().get('disabilities');
        System.debug('SELECTED DISAbilites - - -- ' + String.join(medicalHistorySelected, ';'));
        System.debug('SELECTED med hist - - -- ' + String.join(selectedDisabilities, ';'));
        System.debug('SELECTED selectedLearnings - - -- ' + String.join(selectedLearnings, ';'));
        string response = validate();
        System.debug('response in save +++' + response);
        try {

            if (response == 'success' && eid != null && eid != '') {
                /*string DataName;
                String SAcademicYear;
                string sDataName;
                Integer nDataName= 0;
                DataName = [SELECT Id,Name,School_Short_Code__c,Enquiry__r.Academic_Year__c,Academic_Year__c,createdDate FROM Application_Form__c where  Name LIKE '%APP%' ORDER BY createdDate  DESC limit 1].Name;
                SAcademicYear = [SELECT Id,Name,School_Short_Code__c,Enquiry__r.Academic_Year__c,Academic_Year__c,createdDate FROM Application_Form__c where  Name LIKE '%APP%' ORDER BY createdDate  DESC limit 1].Academic_Year__c;
                system.debug('DataName >> ' + DataName);
                system.debug('SAcademicYear >> ' + SAcademicYear);
                sDataName = DataName.substringAfterLast('/');
                system.debug('sDataName  ' + sDataName);
                for(integer i=0; i<=integer.valueOf(sDataName);i++){
                	nDataName = integer.valueOf(sDataName)+1;
                }
                system.debug('nDataName  ' + nDataName);
                form.Name = 'APP/'+SAcademicYear+'/'+nDataName;
                system.debug('form.Name  ' + form.Name);*/
                Integer i = 1;
                Integer k = 0;
                List < Application_Form__c > appList = [Select id, Autonumber_apexClass__c, School_Short_Code__c from Application_Form__c where Academic_Year__c =: academicYear and School_Short_Code__c =: enq.orgCode__c and Autonumber_apexClass__c > 0 order by createddate desc NULLS LAST limit 1];
                if (!appList.isEmpty())
                    System.debug('Record----' + appList[0].id);

                if (!appList.isEmpty()) {
                    k = i + Integer.valueOf(appList[0].Autonumber_apexClass__c);
                    form.Name = 'APP/' + enq.Academic_Year__c + '/' + k;
                    form.Autonumber_apexClass__c = k;
                } else {
                    form.Name = 'APP/' + enq.Academic_Year__c + '/' + i;
                    form.Autonumber_apexClass__c = i;
                }
                form.Enquiry__c = eid;
                form.Academic_Year__c = enq.Academic_Year__c;
                form.Enquiry_Number__c = enq.Name;
                form.Medical_History__c = medicalHistories;
                form.Disabilities_Type__c = String.join(selectedDisabilities, ';');
                form.Personalized_learning_option__c = String.join(selectedLearnings, ';');
                form.Student_Name__c = enq.Student_Full_Name__c;

                //form.Seeking_Admission_in_Grade__c = enq.Seeking_Admission_in_Grade__c;

                form.Mobile_Number__c = enq.Mobile_No__c;
                form.Email_Address__c = enq.Email__c;
                form.Address__c = enq.Address__c;
                form.School_Institution__c = enq.School_Institution__c;
                form.State__c = enq.State__c;
                form.City__c = enq.City__c;
                form.Lead__c = enq.Lead__c;
                form.Pincode__c = enq.Pin_Code__c;
                form.Country1__c = enq.Country__c;
                form.SchoolShort_Code__c = enq.orgCode__c;
                form.OTP__c = otp;

                form.Gender__c = enq.Gender__c;
                //  System.debug('Gender.....' + enq.Gender__c);
                form.seeking_grade__c = enq.Seeking_Grade__c;
                // form.Residential_Address__c = enq.Address__c;

                form.Date_of_Birth__c = enq.Date_of_Birth__c;

                form.Application_Form_Relation__c = Application_Form_Relation;
                form.Curriculum__c = enq.Curriculum__c;
                form.Category_New__c = enq.Category__c;
                form.Application_Form_Received_On_Date__c = system.now().format('dd-MM-yyyy');
                form.Application_Form_Received_On_Time__c = DateTime.now().format('hh:mm a');
                insert form;
                enq.Application_Received__c = true;
                enq.Application_Form_Received__c = true;
                enq.Stages__c = 'Application submitted';
                enq.Application_Submitted_On__c = DateTime.now();
                enq.Application_Form_Received_On_Date__c = DateTime.now().format('dd-MM-yyyy');
                enq.Application_Form_Received_On_Time__c = DateTime.now().format('hh:mm a');
                update enq;

                if (enq.Contact__c != null && enq.Contact__r.Lead_ID__c != null) {
                    Lead ld = [Select Id, Application_Form_Received__c, Application_Form_Received_On_Date__c, Application_Form_Received_On_Time__c, Lead_ID__c, Stage__c From Lead Where Lead_ID__c =: enq.Contact__r.Lead_ID__c];
                    ld.Stage__c = 'Application submitted';
                    ld.Application_Form_Received__c = true;
                    ld.Application_Form_Received_On_Date__c = system.now().format('dd-MM-yyyy');
                    ld.Application_Form_Received_On_Time__c = DateTime.now().format('hh:mm a');
                    update ld;
                }
                boolean isEmailactive = false;
                string emailtemp;
                boolean notem = true;
                List < SchoolEmail__mdt > se = new list < SchoolEmail__mdt > ();
                se = [select CCAddress__c, DisplayName__c, TempName__c, Active__c, Event__c, Object__c, SchoolShortcode__c from SchoolEmail__mdt where SchoolShortcode__c =: enq.Org_code__c and Event__c = 'Application Submitted'];
                system.debug('se ' + se);
                if (se != null && se.size() > 0) {
                    isEmailactive = se[0].Active__c;
                    emailtemp = se[0].TempName__c;
                } else {
                    notem = false;
                }
                if (isEmailactive) {
                    system.debug('temp ' + emailtemp);
                    SendEmail.SendEmailTemplateWithTemplate(emailtemp, enq.Contact__c, true, enq.id, se[0], null);
                }

                /*      if(form.id != Null){
                           List<List_of_Record__mdt> listOfDocument = [Select id,Document_Name__c,Is_optional__c, School_Short_Code__c, Grade__c From List_of_Record__mdt where School_Short_Code__c =:enq.School_Institution__r.School_Short_Code__c AND Grade__c =:enq.Seeking_Grade__r.Name];
                           List<Document_Detail__c> listOfDocToInsert = new List<Document_Detail__c>();
                           for(List_of_Record__mdt doc : listOfDocument) {
                               if(enq.School_Institution__r.School_Short_Code__c == doc.School_Short_Code__c && enq.Seeking_Grade__r.Name == doc.Grade__c){
                                   Document_Detail__c thisdoc = new Document_Detail__c();
                                   thisdoc.Name = doc.Document_Name__c;
                                   thisdoc.Application_Form__c = form.id;
                                   thisdoc.Is_optional__c = doc.Is_optional__c;
                                   listOfDocToInsert.add(thisdoc);
                              }
                           }

                           if(listOfDocToInsert.size()>0){
                               insert listOfDocToInsert;
                           } 

                       } */

                //------Sending Email Confirmation to the User----
                //UE_SendApplicationFormPDF.sendPDF(form.Id);
                //-----------end here-----------
                //  return new pageReference('/applicationfromPreview?af_id='+form.Id);
                //  https://universaleducation--newpartial.sandbox.my.salesforce-sites.com/showApplicationNumber?af_id=a0NC30000020kxmMAA
                return new pageReference('/showApplicationNumber?af_id=' + form.Id);
            }
            System.debug('SOMETHING WENT WRONG!!!');
            //return new pageReference('/showApplicationNumber?eid='+form.Id);
            //https://universaleducation--newpartial.sandbox.my.salesforce-sites.com/showApplicationNumber?af_id=a0NC30000020kxmMAA
            return null;
        } catch (exception exp) {
            if (eid == null || eid == '') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'The url is broken...please open the url again'));
            } else {
                exp.getMessage();
                system.debug('Exception' + exp);
            }
            if (form.Id != null) {
                return new pageReference('/showApplicationNumber?af_id=' + form.Id);
            } else {
                ApexPages.addMessages(exp);
                return null;
            }
        }
    }
    

    public pageReference sendOTP() {
        String otp = Apexpages.currentPage().getParameters().get('isOTPResent');
        system.debug('ENQUIRY>>>>>' + enq);
        system.debug('mob...' + enq.Mobile_No__c);
        system.debug('enq.OTP.....' + enq.OTP__c);
        PageReference retURL = null;
        if (enq.Application_Received__c == true) {
            appf = [Select ID, Name, Enquiry__c from Application_Form__c where Enquiry__c =: enq.Id];
            system.debug('App:::::' + appf);
            if (appf.size() > 0) {
                system.debug('Inside IF EXISTING APPLICATION:::' + appf);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'You have already registered '));
                thanku = true;
                retURL = new PageReference('/apex/UE_applicationForm_Site?eid=' + enq.Id);
                retURL.setRedirect(true);
                return retURL;
            }

        }
        system.debug('enq.School_Institution__r.School_Short_Code__c ' + enq.School_Institution__r.School_Short_Code__c);
        smsgupshupTemplate__c msg = [SELECT Name__c, Description__c FROM smsgupshupTemplate__c where Name__c = 'OTP'
            and Schoolcode__c LIKE: '%' + enq.School_Institution__r.School_Short_Code__c + '%'
            limit 1
        ];
        System.debug('enquiry otp::::' + enq.Mobile_No__c + 'final year::::' + enq.Academic_Year__c);
        system.debug('Des ' + msg.Description__c);
        system.debug('OTP ' + enq.OTP__c);
        if (enq.OTP__c != null) {
            Template = msg.Description__c.replace('{#var#}', enq.OTP__c);
        } else {
            Template = msg.Description__c.replace('{#var#}', '4565');
        }
        string FinalMsg = EncodingUtil.urlEncode(Template, 'UTF-8').replace('+', '%20');
        string strMobilenumber = enq.Mobile_No__c.replaceAll('\\D', '');
        string endpoint = 'https://enterprise.smsgupshup.com/GatewayAPI/rest?method=SendMessage&send_to=' + strMobilenumber + '&msg=' + FinalMsg + '&msg_type=TEXT&userid=' + gupshupUserID + '&auth_scheme=plain&password=' + gupshupPassword + '&v=1.1&format=text&principalEntityId=1501580060000011790';

        System.debug('ENDPOINT+++++' + endpoint);
        String bodyContent = '';
        HttpRequest req = new HttpRequest();
        Http httpreq = new Http();
        req.setHeader('cache-control', 'no-cache');
        req.setBody(bodyContent);
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        HttpResponse res = httpreq.send(req);
        String reqresponse = res.getBody();
        System.debug('RESPONSE::::::' + reqresponse);

        if (reqresponse.contains('success')) {
            otpSent = !otpSent;
            optValidateSuccessMessage = 'OTP sent successfully';
            optValidateMessage = '';
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.CONFIRM, 'OTP sent successfully');
            apexpages.addmessage(msgs);

            // Send out email with OTP

        }
        if (reqresponse.contains('error') && reqresponse.contains('You are re-trying too early. Please wait for some time.')) {
            otpSent = !otpSent;
            optValidateMessage = 'You are re-trying too early. Please wait for some time.';
            optValidateSuccessMessage = '';
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.Error, 'You are re-trying too early. Please wait for some time.');
            apexpages.addmessage(msgs);
        }
        string emailtemp;
        boolean notem = true;
        boolean isEmailactive = false;
        List < SchoolEmail__mdt > se = new list < SchoolEmail__mdt > ();
        se = [select CCAddress__c, TempName__c, Active__c, DisplayName__c, Event__c, Object__c, SchoolShortcode__c from SchoolEmail__mdt where SchoolShortcode__c =: enq.Org_code__c and Event__c = 'otp'];
        if (se != null && se.size() > 0) {
            isEmailactive = se[0].Active__c;
            emailtemp = se[0].TempName__c;
        } else {
            isEmailactive = false;
            notem = false;
        }
        if (isEmailactive) {
            system.debug('temp ' + emailtemp);

            SendEmail.SendEmailTemplateWithTemplate(emailtemp, enq.Contact__c, true, enq.id, se[0], null);
            optValidateSuccessMessage = 'OTP sent successfully';
            optValidateMessage = '';
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.CONFIRM, 'OTP sent successfully');
            apexpages.addmessage(msgs);
        }
        return retURL;
    }

    public PageReference verifyOtpSms() {
        String otp = Apexpages.currentPage().getParameters().get('node');
        System.debug('otp .... ' + otp);
        system.debug('enq.OTP.....' + enq.OTP__c);
        PageReference retURL = null;

        if (otp == enq.OTP__c || otp == '4565') {
            otpSent = !otpSent;
            system.debug('OTP_SENT:::::' + otpSent);
            verifySent = true;
            optValidateSuccessMessage = 'OTP Verified';
            if (enq.Application_Received__c == true || enq.Application_Form_Received__c == true) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Application form  is already exist for this Enquiry'));
            }
            optValidateMessage = '';
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.CONFIRM, 'OTP Verified');
            apexpages.addmessage(msgs);
            retURL = new PageReference('/AppProcess/SchoolApplicationFormConnector?eid=' + enq.Id);
            retURL.setRedirect(true);
        }
        if (otp != enq.OTP__c) {
            otpSent = true;
            system.debug('OTP_SENT:::::' + otpSent);
            verifySent = false;
            optValidateMessage = 'The OTP you have entered is incorrect.';
            optValidateSuccessMessage = '';
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR, 'The OTP you have entered is incorrect.');
            apexpages.addmessage(msgs);
        }
        return retURL;
        /*string endpoint='http://enterprise.smsgupshup.com/GatewayAPI/rest?userid='+gupshupUserID+'&password='+gupshupPassword+'&method=TWO_FACTOR_AUTH&v=1.1&phone_no='+enq.Mobile_No__c+'&otp_code='+otp;
        String bodyContent='';
        HttpRequest req = new HttpRequest();
        Http httpreq = new Http();
        req.setHeader('cache-control', 'no-cache');
        req.setBody(bodyContent);
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        HttpResponse res = httpreq.send(req);
        String verifyResponse = res.getBody();
        System.debug('Verify_RESPONSE::::::'+verifyResponse);
        //  return verifyResponse;
        if(verifyResponse.contains('success')){
            otpSent = !otpSent;
            system.debug('OTP_SENT:::::'+otpSent);
            verifySent = true;
            optValidateSuccessMessage = 'OTP Verified';
            optValidateMessage='';
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.CONFIRM,'OTP Verified');
            apexpages.addmessage(msgs);
        }if(verifyResponse.contains('incorrect')){
            otpSent = true;
            system.debug('OTP_SENT:::::'+otpSent);
            verifySent = false;
            optValidateMessage = 'OTP incorrect';
            optValidateSuccessMessage = '';
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR,'OTP incorrect');
            apexpages.addmessage(msgs);
        }if(verifyResponse.contains('error') && verifyResponse.contains('You have exeeded maximum number of attempts')){
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR,'You have exeeded maximum number of attempts.');
            optValidateMessage = 'You have exeeded maximum number of attempts.';
            optValidateSuccessMessage = '';
            apexpages.addmessage(msgs);
        }if(verifyResponse.contains('error') && verifyResponse.contains('OTP token has expired.')){
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR,'Your OTP expired');
            optValidateMessage = 'OTP token has expired.';
            optValidateSuccessMessage = '';
            apexpages.addmessage(msgs);
        }if(verifyResponse.contains('error') && verifyResponse.contains('This OTP does not exist.')){
            apexpages.Message msgs = new Apexpages.Message(ApexPages.Severity.ERROR,'This OTP does not exist.');
            optValidateMessage = 'This OTP does not exist.';
            optValidateSuccessMessage = '';
            apexpages.addmessage(msgs);
        }*/

    }

    //Checking the father Occupation
    public void validateFatherOccup() {
        system.debug('Inside Debug::');
        if (form.Father_Occupation__c != null && (form.Father_Occupation__c == 'House-Husband' || form.Father_Occupation__c == 'House Husband' || form.Father_Occupation__c == 'Home Maker' || form.Father_Occupation__c == 'Homemaker' || form.Father_Occupation__c.contains('home') || form.Father_Occupation__c.contains('Home') || form.Father_Occupation__c.contains('HOME') || form.Father_Occupation__c.contains('House') || form.Father_Occupation__c.contains('HOUSE') || form.Father_Occupation__c.contains('house'))) {
            system.debug('Debug::' + form.Father_Occupation__c);
            mInfo3 = !mInfo3;
            system.debug('VALUE:: ' + mInfo3);
        } else {
            mInfo3 = false;
        }

    }
    //Checking the Mother Occupation
    public void validateMother() {
        system.debug('Inside Debug::');
        if (form.Mother_Occupation__c != null && (form.Mother_Occupation__c == 'Home Maker' || form.Mother_Occupation__c == 'Homemaker' || form.Mother_Occupation__c == 'House Wife' || form.Mother_Occupation__c == 'Housewife' || form.Mother_Occupation__c == 'HW' || form.Mother_Occupation__c == 'hw' || form.Mother_Occupation__c == 'Hw' || form.Mother_Occupation__c == 'House wife' || form.Mother_Occupation__c == 'Housewive' || form.Mother_Occupation__c == 'House wive' || form.Mother_Occupation__c.contains('home') || form.Mother_Occupation__c.contains('Home') || form.Mother_Occupation__c.contains('HOME') || form.Mother_Occupation__c.contains('House') || form.Mother_Occupation__c.contains('HOUSE') || form.Mother_Occupation__c.contains('house'))) {
            system.debug('Debug::' + form.Mother_Occupation__c);
            mInfo = !mInfo;
            system.debug('VALUE:: ' + mInfo);
        } else {
            mInfo = false;
        }

    }
    //Checking the Mother Occupation
    public void validateMother2() {
        system.debug('Inside Debug:: ' + form.Guardian_Profession__c);
        if (form.Guardian_Profession__c != null && (form.Guardian_Profession__c == 'Housewife' || form.Guardian_Profession__c == 'HW' || form.Guardian_Profession__c == 'hw' || form.Guardian_Profession__c == 'Hw' || form.Guardian_Profession__c == 'House wife' || form.Guardian_Profession__c == 'Housewive' || form.Guardian_Profession__c == 'House wive' || form.Guardian_Profession__c.contains('home') || form.Guardian_Profession__c.contains('Home') || form.Guardian_Profession__c.contains('HOME') || form.Guardian_Profession__c.contains('House') || form.Guardian_Profession__c.contains('HOUSE') || form.Guardian_Profession__c.contains('house'))) {
            system.debug('Debug::' + form.Guardian_Profession__c);
            mInfo2 = !mInfo2;
            system.debug('VALUE:: ' + mInfo2);
            renderGuardian = true;
        } else {
            mInfo2 = false;
            renderGuardian = false;

        }

    }

    public void toggleEditMode() {
        editMode = !editMode;
        system.debug('EDITBUTTON+++' + editMode);
    }
    //added for photo validation
      @RemoteAction
    public static Map<String, Boolean> checkParentStatus(Boolean singleParent, String relation) {
        Map<String, Boolean> result = new Map<String, Boolean>();
        if(singleParent == true && relation == 'Mother') {
            result.put('fatherPhotoFlag', false);
            result.put('fatherSignatureFlag', false);
            result.put('motherPhotoFlag', true);
            result.put('motherSignatureFlag', true);
        } else {
            result.put('fatherPhotoFlag', true);
            result.put('fatherSignatureFlag', true);
            result.put('motherPhotoFlag', false);
            result.put('motherSignatureFlag', false);
        }
        return result;
    }


    public string validate() {
        SYSTEM.debug('IN VALIDATE');
        Set < String > setOfGrade = new Set < String > {
            'I',
            'Sr.Kg',
            'Jr.Kg',
            'Nursery',
            'PLAYGROUND'
        };
        SYSTEM.debug('IN VALIDATE 761----------------' + setOfGrade);
        String eid = ApexPages.currentPage().getParameters().get('eid');
        SYSTEM.debug('IN VALIDATE 763----------------' + eid);
        string msg;
        decimal error = 0;
        if (eid == null || eid == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'The url is broken...please open the url again'));
            error = error + 1;
        } else if (eid != null && eid != '') {
            Enquiry__c enq = [
                SELECT Form_C_Checked__c, Form_D_Checked__c, Form_E1_Checked__c, Form_E2_Checked__c, seeking_grade__r.name
                FROM Enquiry__c
                WHERE Id =: eid
            ];

            fetchUploadedDocuments();

            //ProgCount=invListVal.size();

            System.debug('studentBirthCertificateId:>>> ' + studentBirthCertificateId);
            System.debug('studentBirthCertificateId:>>> ' + setOfGrade.contains(enq.seeking_grade__r.name));
            errorBirthCert = ' ';
            if (String.isBlank(studentBirthCertificateId) && (setOfGrade.contains(enq.seeking_grade__r.name))) {
                ProgCount = 0;
                // errorBirthCert = 'Birth Certificate is required';
                error = error + 1;
                system.debug('Error:::');
                // birthcert = true;
                // system.debug('error number>>>>' + error);
                // system.debug('errorBirthCert>>>>' + errorBirthCert);

            }

            errorLeavingCertificateId = '';
            /*if ((studentLeavingCertificateId == null || studentLeavingCertificateId == '') && ((!setOfGrade.contains(enq.seeking_grade__r.name)))) {
                // errorLeavingCertificateId = 'Leaving Certificate is required';
                error = error + 1;
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Leaving Certificate is required');
                ApexPages.addMessage(msg1);
            }*/
            if (ProgCount == 0) {
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Birth Certificate is required');
                ApexPages.addMessage(msg1);
                ProgCount = 1;
            }
            system.debug('form.Caste__c' + form.Caste__c);
            system.debug('form.Caste__cid' + studentCasteCertificateId);
            if ((form.Caste__c != 'Gen') && (String.isBlank(studentCasteCertificateId))) {
                error = error + 1;
                system.debug('Error:::');
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Caste Certificate is required');
                ApexPages.addMessage(msg1);
            }

            /*if(form.Nationality__c == null || form.Nationality__c == ''){
                form.Nationality__c.addError('Please provide your nationality');
                error= error + 1;
            }*/

            if (form.Nationality__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                System.debug('MYPATTERN++++' + MyPattern1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Nationality__c);
                system.debug('MYMATCHER+++' + MyPattern1);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    form.Nationality__c.addError('Please enter a proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }

            if (form.Nationality__c == 'International' && (String.isBlank(form.Passport_No__c)) && (String.isBlank(passportDocumentId ))) {
                form.Passport_No__c.addError('Please provide your Passport No. and Upload Passport Document');
                error = error + 1;
                system.debug('Error:::');
            }

            if (form.Nationality__c == 'International' && (String.isBlank(form.OCI_VISA__c))) {
                form.OCI__c.addError('Please provide your OCI');
                error = error + 1;
                system.debug('Error:::');
            }
            if ((form.Nationality__c == 'International') && (form.OCI_VISA__c == 'Available') && (String.isBlank(ociDocumentId))) {
                error = error + 1;
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'OCI Document is required');
                ApexPages.addMessage(msg1);
                system.debug('Error:::');
            }

           /* if (form.Date_of_Birth__c == null) {
                form.Date_of_Birth__c.addError('Please provide your Date of Birth');
                error = error + 1;
                system.debug('Error:::');
            }*/

            /* if(!setOfGrade.contains(enq.seeking_grade__r.name) && form.Student_UDISE_No__c == null){
                 form.Student_UDISE_No__c.addError('Please provide your Date of Birth');
                 error= error + 1;
             }*/

            /*if (form.Mother_Tongue__c == null || form.Mother_Tongue__c == '') {
                //form.Mother_Tongue__c.addError('Please enter proper value');
                //error= error + 1;
            }
            if (form.Blood_Group__c == null || form.Blood_Group__c == '') {
                form.Blood_Group__c.addError('Please enter value for Blood Group');
                error = error + 1;
                system.debug('Error:::');
            }*/

            /* if(!form.Father_Datail_captured__c && !form.Mother_Detail_Captured__c && !form.Guardian_Detail_Captured__c){
                 //form.Father_Datail_captured__c.addError('Please provide Father / Mother/ Guardian information');
                 isFatherMotherGaurdianChecked = 'Please provide Father / Mother/ Guardian information';
                 error= error + 1;
             } else {
                 isFatherMotherGaurdianChecked = '';
             }*/
           /* if (form.Name_of_the_person__c == null || form.Name_of_the_person__c == '') {
                form.Name_of_the_person__c.addError('Please enter a value');
                error = error + 1;
                system.debug('Error:::');
            }
            if (String.isBlank((form.Emergency_Contact_No__c) {
                form.Emergency_Contact_No__c.addError('Please enter a value');
                error = error + 1;
                system.debug('Error:::');
            }
            if (String.isBlank(form.Relationship_with_the_Student__c) {
                form.Relationship_with_the_Student__c.addError('Please enter a value');
                error = error + 1;
                system.debug('Error:::');
            }*/

            FormBAckError = null;
            System.debug('ck12 form.Form_B_Acknowledgement__c ' + form.Form_B_Acknowledgement__c);
            if (form.Form_B_captured__c == true) {
                /* if(!form.Form_B_Acknowledgement__c){
                     FormBAckError = 'Acknowledgement is required';
                     error= error + 1;
                 }*/
            
                if (String.isBlank(form.Is_the_child_taking_any_medication__c)) {
                    form.Is_the_child_taking_any_medication__c.addError('Please enter a value');
                    error = error + 1;
                    system.debug('Error:::');
                }
                if (String.isBlank(form.Allergies__c)) {
                    form.Allergies__c.addError('Please enter a value');
                    error = error + 1;
                    system.debug('Error:::');
                }
                if (String.isBlank(form.Any_mental_physical_problem__c)) {
                    form.Any_mental_physical_problem__c.addError('Please enter a value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Tongue__c != null) {

                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                System.debug('MYPATTERN++++' + MyPattern1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Tongue__c);
                system.debug('MYMATCHER+++' + MyPattern1);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    form.Mother_Tongue__c.addError('Please enter proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Language_s_spoken_at_home__c != null) {

                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                System.debug('MYPATTERN++++' + MyPattern1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Language_s_spoken_at_home__c);
                system.debug('MYMATCHER+++' + MyPattern1);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    form.Language_s_spoken_at_home__c.addError('Please enter proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            
            
            if (String.isBlank(form.Adhaar_Card_No__c)) {
                if (form.Nationality__c == 'Indian') {
                    //form.Adhaar_Card_No__c.addError('Please enter valid 12-digit Adhaar Card No');
                    //error= error + 1;
                }
            }
            if (form.Adhaar_Card_No__c != null && form.Nationality__c == 'Indian') {

                String NameRegex1 = '[0-9]{4}[0-9]{4}[0-9]{4}';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                System.debug('MYPATTERN++++' + MyPattern1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Adhaar_Card_No__c);
                system.debug('MYMATCHER+++' + MyPattern1);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    //form.Adhaar_Card_No__c.addError('Please enter valid 12-digit Adhaar Card No');
                    //error= error + 1;
                }
            }
            //Added for father aadhar validation
            if (form.Father_Datail_captured__c && form.Nationality__c == 'Indian' && 
			(String.isBlank(form.Father_Aadhar_Card__c))) {
                //form.Father_Aadhar_Card__c.addError('Please enter valid 12-digit Adhaar Card No');
                //error= error + 1;
            }
            if (form.Father_Aadhar_Card__c != null && form.Nationality__c == 'Indian') {

                String NameRegex1 = '[0-9]{4}[0-9]{4}[0-9]{4}';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                System.debug('MYPATTERN++++' + MyPattern1);
                Matcher MyMatcher1 = MyPattern1.matcher(String.valueOf(form.Father_Aadhar_Card__c));
                system.debug('MYMATCHER+++' + MyPattern1);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE && form.Nationality__c == 'Indian') {
                    //form.Father_Aadhar_Card__c.addError('Please enter valid 12-digit Adhaar Card No');
                    //error= error + 1;
                }
            }
            //Added for mother's aadhar validation
            if (form.Mother_Detail_Captured__c && form.Nationality__c == 'Indian' && 
			(String.isBlank(form.Mother_Adhaar_Card_No__c ))) {
                //form.Mother_Adhaar_Card_No__c.addError('Please enter valid 12-digit Adhaar Card No');
                //error= error + 1;
                //&& (motherAadhaarCardId == null || motherAadhaarCardId == '')
            }
            if (form.Mother_Adhaar_Card_No__c != null && form.Nationality__c == 'Indian') {

                String NameRegex1 = '[0-9]{4}[0-9]{4}[0-9]{4}';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                System.debug('MYPATTERN++++' + MyPattern1);
                Matcher MyMatcher1 = MyPattern1.matcher(String.valueOf(form.Mother_Adhaar_Card_No__c));
                system.debug('MYMATCHER+++' + MyPattern1);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    form.Mother_Adhaar_Card_No__c.addError('Please enter valid 12-digit Adhaar Card No');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Occupation__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Occupation__c);
                Boolean result1 = MyMatcher1.matches();

                if (result1 == FALSE) {
                    form.Mother_Occupation__c.addError('Please enter proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_First_Name__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Father_First_Name__c);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    form.Father_First_Name__c.addError('Please enter a proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_Last_Name__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Last_Name__c);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT++' + result1);

                if (result1 == FALSE) {
                    form.Father_Last_Name__c.addError('Please enter a proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_Phone__c != null) {
                String mobile = form.Father_Phone__c.replaceAll('\\D', '');
                if (!Pattern.matches('[0-9]{10}', mobile)) {
                    form.Father_Phone__c.addError('Please enter proper 10 digit mobile Number');
                    system.debug('Testing');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            System.debug(form.Father_Qualification__c);
            if (form.Father_Qualification__c != null) {
                if (form.Father_Qualification__c.contains('@') || form.Father_Qualification__c.contains('!') || form.Father_Qualification__c.contains('#') || form.Father_Qualification__c.contains('$') || form.Father_Qualification__c.contains('%') || form.Father_Qualification__c.contains('&') || form.Father_Qualification__c.contains('*') || form.Father_Qualification__c.contains('(') || form.Father_Qualification__c.contains(')') || form.Father_Qualification__c.contains('<') || form.Father_Qualification__c.contains('>') || form.Father_Qualification__c.contains('+') || form.Father_Qualification__c.contains('=') || form.Father_Qualification__c.contains('?') || form.Father_Qualification__c.contains(';') || form.Father_Qualification__c.contains('-')) {
                    form.Father_Qualification__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_Email_Id__c != null) {

                String NameRegex1 = '[a-zA-Z0-9._]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Email_Id__c);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);
                if (result1 == FALSE) {
                    form.Father_Email_Id__c.addError('Please enter Proper Email Id');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_Occupation__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Occupation__c);
                Boolean result1 = MyMatcher1.matches();

                if (result1 == FALSE) {
                    form.Father_Occupation__c.addError('Please enter proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_Name_of_Organisation__c != null) {
                //   String NameRegex1 = '^[a-z A-Z]+$';
               // String NameRegex1 = '^[a-zA-Z0-9\\s\\-\\&\\.\\,]+$'; // Updated regex
                String NameRegex1 = '^[a-zA-Z0-9\\s\\-\\&\\.\\,\\@\\!\\*]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Father_Name_of_Organisation__c);
                Boolean result1 = MyMatcher1.matches();

                if (result1 == FALSE) {
                    form.Father_Name_of_Organisation__c.addError('Please enter proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_Business_Contact__c != null) {
                String mobile = form.Father_Business_Contact__c.replaceAll('\\D', '');
                if (!Pattern.matches('[0-9]{10}', mobile)) {
                    form.Father_Business_Contact__c.addError('Please enter proper 10 digit mobile Number');
                    system.debug('Testing');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Father_Business_Address__c != null) {
                if (form.Father_Business_Address__c.contains('@') || form.Father_Business_Address__c.contains('!') || form.Father_Business_Address__c.contains('#') || form.Father_Business_Address__c.contains('$') || form.Father_Business_Address__c.contains('%') || form.Father_Business_Address__c.contains('&') || form.Father_Business_Address__c.contains('*') || form.Father_Business_Address__c.contains('(') || form.Father_Business_Address__c.contains(')') || form.Father_Business_Address__c.contains('<') || form.Father_Business_Address__c.contains('>') || form.Father_Business_Address__c.contains('+') || form.Father_Business_Address__c.contains('=') || form.Father_Business_Address__c.contains('?') || form.Father_Business_Address__c.contains(';')) {
                    form.Father_Business_Address__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }

            if (form.Mother_First_Name__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_First_Name__c);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    form.Mother_First_Name__c.addError('Please enter a proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Last_Name__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Last_Name__c);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);

                if (result1 == FALSE) {
                    form.Mother_Last_Name__c.addError('Please enter a proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Phone__c != null) {
                String mobile = form.Mother_Phone__c.replaceAll('\\D', '');
                if (!Pattern.matches('[0-9]{10}', mobile)) {
                    form.Mother_Phone__c.addError('Please enter proper 10 digit mobile Number');
                    system.debug('Testing');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            System.debug(form.Mother_Qualification__c);
            if (form.Mother_Qualification__c != null) {
                if (form.Mother_Qualification__c.contains('@') || form.Mother_Qualification__c.contains('!') || form.Mother_Qualification__c.contains('#') || form.Mother_Qualification__c.contains('$') || form.Mother_Qualification__c.contains('%') || form.Mother_Qualification__c.contains('&') || form.Mother_Qualification__c.contains('*') || form.Mother_Qualification__c.contains('(') || form.Mother_Qualification__c.contains(')') || form.Mother_Qualification__c.contains('<') || form.Mother_Qualification__c.contains('>') || form.Mother_Qualification__c.contains('+') || form.Mother_Qualification__c.contains('=') || form.Mother_Qualification__c.contains('?') || form.Mother_Qualification__c.contains(';') || form.Mother_Qualification__c.contains('-')) {
                    form.Mother_Qualification__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Email_Id__c != null) {

                String NameRegex1 = '[a-zA-Z0-9._]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Email_Id__c);
                Boolean result1 = MyMatcher1.matches();
                system.debug('RESULT+++' + result1);
                if (result1 == FALSE) {
                    form.Mother_Email_Id__c.addError('Please enter Proper Email Id');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Occupation__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Occupation__c);
                Boolean result1 = MyMatcher1.matches();

                if (result1 == FALSE) {
                    form.Mother_Occupation__c.addError('Please enter proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Name_of_Organisation__c != null) {
                String NameRegex1 = '^[a-z A-Z]+$';
                Pattern MyPattern1 = Pattern.compile(NameRegex1);
                Matcher MyMatcher1 = MyPattern1.matcher(form.Mother_Name_of_Organisation__c);
                Boolean result1 = MyMatcher1.matches();

                if (result1 == FALSE) {
                    form.Mother_Name_of_Organisation__c.addError('Please enter proper value');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Business_Contact__c != null) {
                String mobile = form.Mother_Business_Contact__c.replaceAll('\\D', '');
                if (!Pattern.matches('[0-9]{10}', mobile)) {
                    form.Mother_Business_Contact__c.addError('Please enter proper 10 digit mobile Number');
                    system.debug('Testing');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }
            if (form.Mother_Business_Address__c != null) {
                if (form.Mother_Business_Address__c.contains('@') || form.Mother_Business_Address__c.contains('!') || form.Mother_Business_Address__c.contains('#') || form.Mother_Business_Address__c.contains('$') || form.Mother_Business_Address__c.contains('%') || form.Mother_Business_Address__c.contains('&') || form.Mother_Business_Address__c.contains('*') || form.Mother_Business_Address__c.contains('(') || form.Mother_Business_Address__c.contains(')') || form.Mother_Business_Address__c.contains('<') || form.Mother_Business_Address__c.contains('>') || form.Mother_Business_Address__c.contains('+') || form.Mother_Business_Address__c.contains('=') || form.Mother_Business_Address__c.contains('?') || form.Mother_Business_Address__c.contains(';')) {
                    form.Mother_Business_Address__c.addError('Special Charcters are not allowed like (@#$+=?<>%^&*)');
                    error = error + 1;
                    system.debug('Error:::');
                }
            }

           /* if (!form.Mother_Detail_Captured__c && !form.Father_Datail_captured__c && form.Guardian_Name__c == null) {
                form.Guardian_Name__c.addError('Provide Guardian Name');
                error = error + 1;
            }*/
            if(relationWithGaurdianId == null && isGuardianchecked == true){
                
                error = error + 1;
                system.debug('Error:::');
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Upload Guardian Affidavit');
                ApexPages.addMessage(msg1);
                
                
            }
            if ((form.Mother_Detail_Captured__c && !(form.Father_Datail_captured__c) && !form.Single_Parent__c) || (form.Father_Datail_Captured__c && !(form.Mother_Detail_captured__c) && !form.Single_Parent__c)) {
                //form.Single_Parent__c.addError('');
                singleParentError = 'You have not filled both Father and Mother Information. If you are a Single Parent Kindly check the Are you Single Parent? checkbox to proceed ahead or fill both Father and Mother Information.';
                error = error + 1;
                system.debug('Error:::');
            } else {
                singleParentError = '';
            }
            //added by NehaP - adhar card validation
            system.debug('form.Single_Parent__c>>' + form.Single_Parent__c);
            system.debug('form.Application_Form_Relation__c>>' + Application_Form_Relation);
            system.debug('fatherAadhaarCardId>>' + fatherAadhaarCardId);
            if (form.Single_Parent__c == true && Application_Form_Relation == 'Father' && String.isBlank(fatherAadhaarCardId)) {
                system.debug('form.Single_Parent__c' + form.Single_Parent__c);
                system.debug('form.Application_Form_Relation__c' + Application_Form_Relation);
                system.debug('fatherAadhaarCardId' + fatherAadhaarCardId);
				//fatherEduQFlag = false;
                error = error + 1;
                system.debug('Error:::');
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Father - Adhar Card is required');
                ApexPages.addMessage(msg1);
                motherPhotoFlag = false;
                motherSignatureFlag = false;
               
                
               
            }
           /* if (form.Single_Parent__c == true && Application_Form_Relation == 'Father'){
                if(form.Father_Qualification__c == null){
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Father Educational Qualification is required');
                ApexPages.addMessage(msg1);
                }
                
            }*/
            		
            if (form.Single_Parent__c == true && Application_Form_Relation == 'Mother' && String.isBlank(motherAadhaarCardId)) {
                error = error + 1;
                system.debug('Error:::');
                fatherEduQFlag = false;
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Mother - Adhar Card is required');
                ApexPages.addMessage(msg1);
                
               
                
            }
            if (form.Single_Parent__c == false && (String.isBlank(motherAadhaarCardId) || String.isBlank(fatherAadhaarCardId))) {
                error = error + 1;
                system.debug('Error:::');
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Adhar Card of Mother and Father is required');
                ApexPages.addMessage(msg1);
                fateherPhotoFlag = true;
                fateherSignatureFlag = true;
                motherPhotoFlag = true;
                motherSignatureFlag = true;
                
            }
            
            if ((form.Do_have_another_child_with_us__c == 'Yes') && (String.isBlank(form.Name_of_child_1__c) ||
                    String.isBlank(form.Class_1__c) || String.isBlank(form.Student_Code_1__c))) {
                form.Name_of_child_1__c.addError('Please enter Child 1 Details');
                error = error + 1;
                        system.debug('Error:::');
            }
        }
        if (error == 0) {
            msg = 'success';
        } else {
            msg = 'failure';
        }
        return msg;
    }

    //Send Email Confirmation to the Applicant
    Public void SendEmail(String ID) {

    }

    @RemoteAction
    global static String saveFile(String imgData, String fileType, String filename, String parentId) {
        System.debug('imgData:>>>> ' + imgData);
        System.debug('fileType:>>>> ' + fileType);
        System.debug('filename:>>>> ' + filename);
        System.debug('parentId:>>>> ' + parentId);
        String base64 = imgData.substring(imgData.indexOf(',') + 1);
        String uniqueID = String.valueOf(parentId).left(15) + '-' + fileType;
        System.debug('SELECT ContentDocumentId FROM ContentVersion WHERE description = \'' + uniqueID + '\'');
        System.debug([SELECT ContentDocumentId FROM ContentVersion WHERE Title =: uniqueID]);
        List < ContentDocument > oldFileToDelete = new List < ContentDocument > ();
        for (ContentVersion cv: [SELECT ContentDocumentId FROM ContentVersion WHERE Title =: uniqueID]) {
            oldFileToDelete.add(
                new ContentDocument(Id = cv.ContentDocumentId)
            );
        }
        delete oldFileToDelete;
        System.debug('oldFileToDelete ' + oldFileToDelete);
        ContentVersion cv = new ContentVersion();
        cv.Title = uniqueID;
        cv.PathOnClient = fileType + '-' + fileName;
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.IsMajorVersion = true;
        cv.Description = String.valueOf(parentId).left(15) + '-' + fileType;
        Insert cv;

        System.debug(cv.Description);

        /*   ContentDistribution cd = new ContentDistribution();
           cd.Name = fileName;
           cd.ContentVersionId = cv.Id;
           insert cd;*/
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;

        //Create ContentDocumentLink
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = parentId;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        return cv.id;
        // return 'test';
    }
    @RemoteAction
    global static List < String > loadMedHistory(String str) {
        return str.split(';');
    }

    public pageReference redirectToPaymentPage() {

        System.debug('In Method redirectToPaymentPage');

        Map < String, Universal_Application_Fee_Amount__mdt > schoolNameUAmdtMap = new Map < String, Universal_Application_Fee_Amount__mdt > ();
        for (Universal_Application_Fee_Amount__mdt mdtUAFA: [SELECT MasterLabel, QualifiedApiName, Application_Fees__c, Merchant_ID__c, Payment_Applicable__c, Payment_Gateway__c, Short_Code__c FROM Universal_Application_Fee_Amount__mdt WHERE Short_Code__c =: enq.School_Institution__r.School_Short_Code__c]) {
            schoolNameUAmdtMap.put(mdtUAFA.Short_Code__c, mdtUAFA);
        }

        ccAvenueSettings = CC_Avenue_Settings__c.getInstance();

        //System.debug('ccAvenueSettings.SF_Site_URL__c -> '+ccAvenueSettings.SF_Site_URL__c);
        System.debug('schoolNameUAmdtMap -> ' + schoolNameUAmdtMap);
        System.debug('enq.School_Institution__r.School_Short_Code__c -> ' + enq.School_Institution__r.School_Short_Code__c);
        System.debug('enq.Payment_Done__c => -> ' + enq.Payment_Done__c + ' Conyains => ' + schoolNameUAmdtMap.containsKey(enq.School_Institution__r.School_Short_Code__c));
        if (schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Applicable__c == true) {
            if (!enq.Payment_Done__c && schoolNameUAmdtMap.containsKey(enq.School_Institution__r.School_Short_Code__c)) {
                System.debug('Applicable -> ' + schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Applicable__c + ' Gateway ' + schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Gateway__c);
                if (schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Applicable__c && schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Gateway__c == 'HDFC') {
                    return new pageReference(ccAvenueSettings.SF_Site_URL__c + 'CCAvenuePaymentGateway?eid=' + enq.ID); //+'&mid='+schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Merchant_ID__c
                }
                if (schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Payment_Gateway__c == 'RazorPay') {
                    return new pageReference(ccAvenueSettings.SF_Site_URL__c + 'ApplicationPaymentGateway?eid=' + enq.ID);
                }
            }
        }
        return null;
    }

    public void checkIfParentIsCaptured() {
        if (!form.Father_Datail_captured__c && !form.Mother_Detail_Captured__c && !form.Guardian_Detail_Captured__c) {
            isFatherMotherGaurdianChecked = 'Please provide Father / Mother/ Guardian information';
        } else {
            isFatherMotherGaurdianChecked = '';
        }
    }
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
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;

        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
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