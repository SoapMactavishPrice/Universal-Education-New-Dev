public class ApplicationFormC1Ctrl {
    Public Enquiry__c enq{get;set;}
        public Account acc{get;set;}
        public Application_Form__c form{get;set;}
        public Disclosure__c documentList{get;set;}
        public String parentNamesToShowFormC{get;set;}
        public String Academic_Year{get;set;}


        Id pid=Apexpages.currentpage().getParameters().get('id');
        public ApplicationFormC1Ctrl(ApexPages.StandardController Controller){

            form = [SELECT Academic_Year__c,Application_Form_Declaration__c,Name,Enquiry__c,First_Name__c,Father_Datail_captured__c,Father_Email_Id__c,Father_Last_Name__c,Father_Occupation__c,Mother_First_Name__c,Father_First_Name__c,Mother_Last_Name__c,Guardian_Name__c,School_Short_Code__c,School_Institution__c,School__c,
                    StudentLast_Name__c,Student_Name__c,Seeking_Grade__r.name FROM Application_Form__c where id=: pid ];
           
            String tosearchClass = form.seeking_grade__c;
            List<Account> school = [SELECT Id,(SELECT School_Name_on_PDF__c FROM Class__r WHERE Id = :tosearchClass) FROM Account WHERE Id = :form.School_Institution__c LIMIT 1];
            String fatherName = '';
            String motherName = '';
            String guardianName = '';
            if(form.Father_First_Name__c != null && form.Father_Last_Name__c != null) {
                fatherName = form.Father_First_Name__c + ' ' + form.Father_Last_Name__c;
            }
            if(form.Mother_First_Name__c != null && form.Mother_Last_Name__c != null) {
                motherName = form.Mother_First_Name__c + ' ' + form.Mother_Last_Name__c;
            }
            if(form.Guardian_Name__c != null) {
                guardianName = form.Guardian_Name__c;
            }

            if (fatherName.length() > 1) {
                if (motherName.length() > 1) {
                    if (guardianName.length() > 1) {
                        parentNamesToShowFormC = fatherName + ' &  ' + motherName + ' & ' + guardianName;
                    }else {parentNamesToShowFormC = fatherName + ' &  ' + motherName;
                    }
                }
            }
            if (!(fatherName.length() > 1) && motherName.length() > 1) {parentNamesToShowFormC = motherName;
                if (guardianName.length() > 1) {parentNamesToShowFormC = motherName + ' & ' + guardianName;
                }
            }
            if (guardianName.length() > 1 && !(fatherName.length() > 1) && !(motherName.length() > 1)) {parentNamesToShowFormC = guardianName;
            }

            // enq = [Select id,Date_of_Birth__c,FirstName__c,Last_Name__c,Name,Gender__c,Enq_School_Institute__c,Grade__c  from Enquiry__c where id =: form.Enquiry__c];
            enq = [SELECT  Id, School_Name__c, Date_of_Birth__c, FIRSTNAME__C, Last_Name__c, Name, Gender__c, Enq_School_Institute__c, 
                   Grade__c, Org_code__c, Seeking_Grade__r.name FROM    Enquiry__c WHERE   Id = :form.Enquiry__c];
            System.debug('Enquiry+++'+enq);

            School_List__mdt schoolRec = [SELECT  State__c FROM School_List__mdt WHERE   Label = :enq.Org_code__c LIMIT   1];
            system.debug('form:::::'+ form);
            if (form != null) {
                String grade = form.Seeking_Grade__r.name;
                Academic_Year =form.Academic_Year__c;
                Id schoolId = form.School_Institution__c;
                documentList = [ SELECT Id, Name, Terms__c, Description__c,Academic_Year__c FROM Disclosure__c where OrgionalClass__c=:grade and school__c=:schoolId and Academic_Year__c=:Academic_Year and Name='Form C1' order by DisplaySequence__c asc];
                System.debug('documentList >>> ' + documentList + ' size ' + documentList);
            }
            System.debug('documentList >>> ' + documentList + ' size ' + documentList);
        }
}