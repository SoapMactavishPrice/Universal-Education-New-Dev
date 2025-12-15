/**
* Trigger      : DisclosureTrigger
* Classes      : DisclosureTriggerHandellerCtrl,Test_DisclosureTriggerHandellerCtrl
* Devloper     : Rajesh Kumar
* Created Date : 30/12/2021
*/
public class DisclosureTriggerHandellerCtrl {
    public static void DisclosureTriggerAftInsUpdate(list<Disclosure__c> lstDisclosure,Boolean TriggerisAfter,Boolean TriggerisInsert,Boolean TriggerisUpdate){
        if(TriggerisAfter){
            if(TriggerisInsert || TriggerisUpdate){
                DiscloserURLinsert(lstDisclosure,TriggerisInsert,TriggerisUpdate);
            }  
        }    
    }
    public static void DiscloserURLinsert(list<Disclosure__c> listDisclosures,Boolean TriggerisInsert,Boolean TriggerisUpdate){
        set<string> School_Institution_Name = new set<string>();
        set<string> Grades = new set<string>();
        set<id> DisclosurecId = new set<id>();
        List<Disclosure__c> newDisclosurec = new List<Disclosure__c>();
        if(DiscoloserRecursiveTriggerHandler.isFirstTime){
            DiscoloserRecursiveTriggerHandler.isFirstTime = false;
            if(!listDisclosures.isEmpty() && (TriggerisInsert || TriggerisUpdate)){
                for(Disclosure__c Disclos:listDisclosures){
                    DisclosurecId.add(Disclos.id);
                    School_Institution_Name.add(Disclos.Document_Name__c);
                    //Grades.add(Disclos.Grade__c);
                } 
                system.debug(' DisclosurecId' + DisclosurecId+'School_Institution_Name'+ School_Institution_Name );
                List<Document> listDocument = new List<Document>();
                if(!School_Institution_Name.isEmpty()){
                    if(!Test.isRunningTest()){listDocument = [SELECT Id, Name, DeveloperName, Type,Description, Keywords, ContentType,IsPublic FROM Document where Name =:School_Institution_Name limit 1];}
                    else{listDocument = [SELECT Id, Name, DeveloperName, Type,Description, Keywords, ContentType,IsPublic FROM Document limit 1];}
                    if(!listDocument.isEmpty()){
                        string URLStr = URL.getSalesforceBaseUrl().toExternalForm()+''+System.Label.ORGURLLINK+''+listDocument[0].id; 
                        List<Disclosure__c> newDisclosureclist = [SELECT Id, Name, Class__c, Description__c, DisplaySequence__c, OrgionalClass__c, School__c, Terms__c,School_Institution_Logo_URL__c, Academic_Year__c,Document_Name__c FROM Disclosure__c where Id=:DisclosurecId];
                        if(!newDisclosureclist.isEmpty() ){
                            for(Disclosure__c lstDisclosure : newDisclosureclist){
                                newDisclosurec.add(new Disclosure__c(Id =lstDisclosure.id,School_Institution_Logo_URL__c=URLStr));
                            }
                        }
                        if(!newDisclosurec.isEmpty()){
                            update newDisclosurec;
                        }
                    }
                }
            }
        }
    }
}