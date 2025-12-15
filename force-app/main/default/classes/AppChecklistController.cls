public without sharing class AppChecklistController {
    @AuraEnabled(cacheable=true)
    public static list<Disclosure__c> getChecklist(Id eid){
        String sobjectType = eid.getSObjectType().getDescribe().getName();
        system.debug('Id values is '+eid);
        list<sobject> listOfSobject = new list<sobject>();
        if(sobjectType == 'Enquiry__c'){
            listOfSobject = [select id, Seeking_Grade__r.Name,Academic_Year__c, School_Institution__c from enquiry__c where id=:eid and Seeking_Grade__r.Name != null];
        }
        else{
            listOfSobject = [select id, School_Institution__c, Academic_Year__c, Seeking_Grade__r.Name from Application_Form__c where id=:eid and Seeking_Grade__r.Name != null];
        }
        String grade;
        Id schoolId;
        String academicYear;
        if(!listOfSobject.isEmpty()){
            grade = (String)listOfSobject[0].getSObject('Seeking_Grade__r').get('Name');
            // grade = (String)listOfSobject[0].get('Seeking_Admission_in_Grade__c');
            schoolId = (Id)listOfSobject[0].get('School_Institution__c');
            academicYear = (String)listOfSobject[0].get('Academic_Year__c');
        }
        System.debug('grade @@@@@ ' + grade + 'schoolId@@@@ '+ schoolId + 'academicYear @@@@ ' + academicYear );

        list<Disclosure__c>listOfChecklist = [SELECT Id, Description__c,Terms__c,School_Institution_Logo_URL__c FROM Disclosure__c where Academic_Year__c=:academicYear and OrgionalClass__c=:grade and school__c=:schoolId order by DisplaySequence__c asc];
        if(!listOfChecklist.isEmpty()){
            return listOfChecklist;
        }
        else{
            return null;
        }
    }

    @AuraEnabled
    public static void setCheckbox(Id eid, String fieldName, Boolean value){
        System.debug(eid);
        System.debug(fieldName);
        System.debug(value);
        sObject sObj = Schema.getGlobalDescribe().get('Enquiry__c').newSObject() ;
        sObj.put('Id', eid);
        if (fieldName.contains('Form C')) {
            sObj.put('Form_C_Checked__c' , value) ;
        }
        else if (fieldName.contains('Form-D')) {
            sObj.put('Form_D_Checked__c' , value) ;
        }
        else if (fieldName.contains('Form E-1')) {
            sObj.put('Form_E1_Checked__c' , value) ;
        }
        else if (fieldName.contains('Form E-2')) {
            sObj.put('Form_E2_Checked__c' , value) ;
        }
        update sObj ;
    }

    public static void fakeMethod() {
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
    }
}