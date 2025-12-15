public class UE_applicationPreview {
    Public Enquiry__c enq{get;set;}
    public Account acc{get;set;}
    public Application_Form__c form{get;set;}
    public LIST<Application_Form__c> Afd{get;set;}
    public boolean editMode{get;set;}
    public String studentPhoto{get;set;}
    public String fatherPhoto{get;set;}
    public List<Disclosure__c> documentList{get;set;}
    public String motherPhoto{get;set;}
    public String fatherSignaturePhoto{get;set;}
    public String motherSignaturePhoto{get;set;}

    public String af_id = ApexPages.currentPage().getParameters().get('af_id');

    public UE_applicationPreview(ApexPages.StandardController Controller){
        system.debug('APPLICATION_ID::::::'+af_id);
        // String af_id = ApexPages.currentPage().getParameters().get('af_id');
        form = (Application_Form__c)Controller.getRecord();
        List<Id> contentDocuments = new List<Id>();
            List<ContentDocumentLink> lstCdl = [
                SELECT Id,
                       LinkedEntityId,
                       ContentDocumentId
                  FROM ContentDocumentLink
                 WHERE LinkedEntityId = :af_id
            ];
            for (ContentDocumentLink cdl : lstCdl) {
                contentDocuments.add(cdl.ContentDocumentId);
            }
            List<ContentDistribution> contentDists =  [
                SELECT ContentVersion.Title, ContentDownloadURL
                FROM ContentDistribution
                WHERE  ContentDocumentId IN :contentDocuments
            ];

            for (ContentDistribution cd : contentDists) {
                if(cd.ContentVersion.Title.contains('StudentPhoto')) {
                    studentPhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('FatherPhoto')) {
                    fatherPhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('FatherSignaturePhoto')) {
                    fatherSignaturePhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('MotherSignaturePhoto')) {
                    motherSignaturePhoto = cd.ContentDownloadURL;
                }
                if(cd.ContentVersion.Title.contains('MotherPhoto')) {
                    motherPhoto = cd.ContentDownloadURL;
                }
            }
            System.debug('stud phot '+ studentPhoto);
        editMode = false;

        enq=new Enquiry__c();

        Afd = [SELECT Mother_Adhaar_Card_No__c,Mother_Pan_Card_No__c,Father_Aadhar_Card__c,Father_Pan_Card_No__c,Student_UDISE_No__c,Academic_Year__c,Address__c,Adhaar_Card_No__c,Father_Annual_Income__c,Mother_Anual_Income__c,State__c,City__c,Country__c,Pincode__c,
               Application_Form_Declaration__c,Name,Birth_Place__c,Blood_Group__c,Father_Business_Address__c,
               Mother_Business_Address__c,Father_Business_Contact__c,Mother_Business_Contact__c,Category__c,Count__c,
               Do_have_another_child_with_us__c,Email_Address__c,Guardian_Email_ID__c,Enquiry__c,Enquiry_Number__c,
               Expiry_Date__c,First_Name__c,Father_Datail_captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_Occupation__c,
               Father_Phone__c,Father_Qualification__c,Mother_First_Name__c,Father_First_Name__c,Having_Children__c,
               Mother_Last_Name__c,Last_Name__c,Guardian_Mobile_No__c,Mobile_Number__c,Mother_Detail_Captured__c,
               Mother_Email_Id__c,Mother_Occupation__c,Mother_Phone__c,Mother_Qualification__c,Mother_Tongue__c,
               Guardian_Name__c,Father_Name_of_Organisation__c,Mother_Name_of_Organisation__c,Nationality__c,Passport_No__c,
               Reason_of_this_School__c,Relationship__c,Religion__c,Residence_No__c,School_Short_Code__c,School_Institution__c,School_Name__c,
               Seeking_Admission_for_another_Child__c,StudentLast_Name__c,Seeking_Admission_in_Grade__c,Student_Name__c, CreatedDate FROM Application_Form__c where id =: af_id];

        enq = [Select id,Date_of_Birth__c,FirstName__c,Last_Name__c,Name,Gender__c,Enq_School_Institute__c,Grade__c from Enquiry__c where id =: Afd[0].Enquiry__c];
        System.debug('Enquiry+++'+enq);

        acc = [select id,Name,BillingAddress,BillingCity,BillingCountry,BillingGeocodeAccuracy,
               BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,School_Email__c FROM Account where id=: Afd[0].School_Institution__c];
        system.debug('Account+++'+acc);
        if (form != null) {
            String grade = form.Seeking_Admission_in_Grade__c;
            Id schoolId = form.School_Institution__c;

            documentList = [ SELECT Id, Name, Terms__c, Description__c FROM Disclosure__c where OrgionalClass__c=:grade and school__c=:schoolId order by DisplaySequence__c asc];
            System.debug('documentList >>> ' + documentList);
        }
    }

    Public PageReference finalSubmit(){
        // UE_SendApplicationFormPDF.sendPDF(af_id);
        return new pageReference('/showApplicationNumber?af_id='+af_id);

    }
    Public PageReference editApplication(){
        return new PageReference('/UE_updateApplicationForm_Site?af_id='+af_id);
    }


}