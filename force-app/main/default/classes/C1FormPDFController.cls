public without sharing class C1FormPDFController {
    public Admission_Granted__c ag{get;set;}
    public String parentNamesToShowFormC{get;set;}
    // Docusign Signature fields
    public Boolean hasFatherDetails{get;set;}
    public Boolean hasMotherDetails{get;set;}
    public String strTodayTime{get;set;}

    Id agId=Apexpages.currentpage().getParameters().get('id');
    public Disclosure__c doc{get;set;}

    public C1FormPDFController(ApexPages.StandardController Controller) {
        ag = [
            SELECT City__c,Seeking_Admission_in_Grade__c, Grade_lookup__r.name, Grade_lookup__c, School_Institution__c, School_Institution__r.Name, Student_s_Name__c, Father_First_Name__c, Father_Last_Name__c, mother_First_Name__c, mother_Last_Name__c, GuardianName__c FROM Admission_Granted__c
            Where Id = :agId
        ];
        hasFatherDetails = false;
        hasMotherDetails = false;
        strTodayTime = System.now().hour()+':'+System.now().minute()+':'+System.now().second();
        String fatherName = '';
        String motherName = '';
        String guardianName = '';
        if(String.isNotBlank(ag.Father_First_Name__c) && String.isNotBlank(ag.Father_Last_Name__c)) {
            fatherName = ag.Father_First_Name__c + ' ' + ag.Father_Last_Name__c;
        }

        if(String.isNotBlank(ag.Father_First_Name__c) || String.isNotBlank(ag.Father_Last_Name__c)){
            hasFatherDetails = true;
        }

        if(String.isNotBlank(ag.Mother_First_Name__c) || String.isNotBlank(ag.Mother_Last_Name__c)){
            hasMotherDetails = true;
        }

        if(ag.Mother_First_Name__c != null && ag.Mother_Last_Name__c != null) {
            motherName = ag.Mother_First_Name__c + ' ' + ag.Mother_Last_Name__c;
        }
        if(ag.GuardianName__c != null) {
            guardianName = ag.GuardianName__c;
        }

        if (fatherName.length() > 1) {
            if (motherName.length() > 1) {
                if (guardianName.length() > 1) {
                    parentNamesToShowFormC = fatherName + ' &  ' + motherName + ' & ' + guardianName;
                }else {
                    parentNamesToShowFormC = fatherName + ' &  ' + motherName;
                }
            }
        }
        if (!(fatherName.length() > 1) && motherName.length() > 1) {
            parentNamesToShowFormC = motherName;
            if (guardianName.length() > 1) {
                parentNamesToShowFormC = motherName + ' & ' + guardianName;
            }
        }
        if (guardianName.length() > 1 && !(fatherName.length() > 1) && !(motherName.length() > 1)) {
            parentNamesToShowFormC = guardianName;
        }
        doc = new Disclosure__c(Terms__c = '');
        if (ag != null) {               
                String grade = ag.Grade_lookup__r.name;
                Id schoolId = ag.School_Institution__c;
                try {
                    doc = [ SELECT Id, Name, Terms__c, Description__c FROM Disclosure__c where OrgionalClass__c=:grade and school__c=:schoolId and Name = 'Form C1'];
                } catch (Exception e) {

                }
                System.debug('doc >>> ' + doc);
            }
    }
}