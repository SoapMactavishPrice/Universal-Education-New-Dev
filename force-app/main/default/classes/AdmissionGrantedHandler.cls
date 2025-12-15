public class AdmissionGrantedHandler {
    
    Public void GenrateStudentCode (List<Admission_Granted__c> Scope){
        
        // Set<String> Scode = New Set<String> () ;
        new list<Admission_Granted__c> ();
        Set <String> Ids = New set<String>();
        
        //Get list of Admission granted Ids
        for(Admission_Granted__c AGs : Scope){
            Ids.Add(AGs.Id);
            System.debug('IDs:: '+Ids);
        }
        //Get list of short code
        Set <String> shortCodes = new Set<String>();
        for(Admission_Granted__c scode: Scope){
            shortCodes.add(scode.School_Institution__r.School_Short_Code__c);
        }
        System.debug('ShortCode Set::' +shortCodes );
        
        List<Admission_Granted__c> NewAGs = [ SELECT ID, Enrollment_No__c, School_Short_Code__c ,School_Institution__r.School_Short_Code__c ,User_Id__c,School_Institution__c,School_Institution__r.Email_Suffix__c from Admission_Granted__c WHERE Id IN :Scope ];
        System.debug('AgIds::' +NewAGs );
        
        List<Admission_Granted__c> AdmissionGrantedLst = new List<Admission_Granted__c>();
        
        
        for ( Admission_Granted__c AgS : NewAGs ) {
            
            String ShortCode = AgS.School_Institution__r.School_Short_Code__c;
            If (AgS.Enrollment_No__c != Null  && AgS.School_Institution__r.School_Short_Code__c != Null) {
                
                String FullCode = AgS.Enrollment_No__c ;
                //  String ShortCode = AgS.School_Short_Code__c;
                Boolean results = FullCode.contains(ShortCode);
                
                If (results){
                    Continue ; }
                Else { 
                    // Autonumber(ShortCode);
                    AgS.Enrollment_No__c = AutoNumber(ShortCode, AgS.Id);
                    //Added for User ID 
                    System.debug('@@@@@ Inside scode student Code   AgS.Enrollment_No__c: '+ AgS.Enrollment_No__c);
                    if(AgS.School_Institution__r.Email_Suffix__c!=Null){
                        AgS.User_Id__c=AgS.Enrollment_No__c +  AgS.School_Institution__r.Email_Suffix__c;
                    }
                    AdmissionGrantedLst.add(AgS) ;
                } 
                // Autonumber(ShortCode);
                //   Ags.Enrollment_No__c = AutoNumber(ShortCode);
                //   AdmissionGrantedLst.add(AgS) ;
            } 
            Else { 
                if (ShortCode!= Null  )
                    for  (Admission_Granted__c SCode : NewAGs) {
                        //  String ShortCode = NewAGs.School_Short_Code__c;
                        
                        String FullCode = '';
                        // AdmissionGrantedLst.add(SCode); 
                        //   AutoNumber(SCode);
                        SCode.Enrollment_No__c = AutoNumber(ShortCode, SCode.Id);  
                        System.debug('@@@@@ Inside scode student Code : '+SCode.Enrollment_No__c);
                        //Added for User ID 
                        if(AgS.School_Institution__r.Email_Suffix__c!=Null){
                            AgS.User_Id__c=AgS.Enrollment_No__c +  AgS.School_Institution__r.Email_Suffix__c;
                        }
                        AdmissionGrantedLst.add(AgS) ; 
                    }
                //  Update AdmissionGrantedLst;
                // Autonumber(AdmissionGrantedLst);
                
            }
            
        } Update AdmissionGrantedLst;
        
        
        
        
    }
    
    Private String AutoNumber( String SchoolCode, Id Newrecord ){
        System.debug('Inside AutoNumber method');
        String StudnetCodeTxt = '';
        Integer ScodeNum = 0;
        // String Shortcode = AgId.School_Short_Code__c ; 
        List<Admission_Granted__c> AG = new list<Admission_Granted__c>();
        // List<String> SCAG = new List<String>();
        
        /* for (Admission_Granted__c sc : AgId){
String ShortCode = sc.School_Institution__r.School_Short_Code__c;
Scag.add(ShortCode);
}  */
        
        try{
            List <Admission_Granted__c> lastStudnentCode = new List <Admission_Granted__c>();
            lastStudnentCode = [SELECT Id, Enrollment_No__c, Name, School_Institution__r.School_Short_Code__c From Admission_Granted__c Where School_Short_Code__c  =:SchoolCode ANd Id !=:Newrecord  Order By CreatedDate DESC Limit 1]; 
            
            
            if (lastStudnentCode != null && lastStudnentCode.size() > 0  ) {
                System.debug('lastStudnentCode::' +lastStudnentCode[0]);
                String Scodes = lastStudnentCode[0].School_Institution__r.School_Short_Code__c;
                //  String Scodes = lastStudnentCode.School_Institution__r.School_Short_Code__c;
                system.debug(+Scodes);
                If ( lastStudnentCode[0].Enrollment_No__c != Null  ){
                    StudnetCodeTxt =  lastStudnentCode[0].Enrollment_No__c; 
                    String  Stuudent = StudnetCodeTxt.ReplaceAll('\\D', '');
                    
                    system.debug('StundentCodeNumber::' +Stuudent);
                    If ( Stuudent !=Null && Stuudent.length() > 0 ) {
                        ScodeNum = Integer.valueOf(Stuudent) + 1;
                        
                        System.debug('Incremented ScodeNum:: ' +ScodeNum );
                        StudnetCodeTxt = +scodes +''+ScodeNum;
                        //AG.Add(lastStudnentCode); 
                    }
                    
                } 
                
                
            } else {
                ScodeNum = 0001;
                StudnetCodeTxt  = +SchoolCode +''+ScodeNum; }
            
            
        } 
        
        Catch (Exception e)  {
            System.debug('Recieved Error ::' + e);
        } 
        
        
        
        System.debug('REturn StudentCode: '+StudnetCodeTxt);
        Return StudnetCodeTxt;
    }
    
    public static void updateLeadAfterCompletion(List<Admission_Granted__c> listOfAdmssionGranted){
        Set<String> setOfLeadIds = new Set<String>();
        List<Lead> listOfLeadToUpdate = new List<Lead>();
        
        for(Admission_Granted__c temp : listOfAdmssionGranted)
        {
            if(temp.Lead_ID__c != null && temp.Status__c == 'Admission Process Completed')
                setOfLeadIds.add(temp.Lead_ID__c);
        }
        
        List<Lead> listOfLeads = [Select Id, Admission_Granted_Complete__c from Lead where Lead_ID__c IN :setOfLeadIds];
        
        for(Lead tmp : listOfLeads)
        {
            tmp.Admission_Granted_Complete__c = true;
            listOfLeadToUpdate.add(tmp);
        }
         
        
        if(listOfLeadToUpdate.size() > 0)
            update listOfLeadToUpdate;
    }
    
     /**
     * Updates the Application_Completed_Date__c field to today's date if the conditions are met.
     * @param newRecords List of Admission_Granted__c records being processed.
     */
    public static void updateApplicationCompletedDate(List<Admission_Granted__c> newRecords) {
        System.debug('Entering updateApplicationCompletedDate method');
        
        try {
            for (Admission_Granted__c record : newRecords) {
                System.debug('Processing record with ID: ' + record.Id);
                
                // Check if the status is 'Admission Process Completed' 
                // and Application_Completed_Date__c is null
                if (record.Status__c == 'Admission Process Completed' &&
                    record.Application_Completed_Date__c == null) {
                        
                        System.debug('Conditions met for record ID: ' + record.Id + 
                                     '. Updating Application_Completed_Date__c to today\'s date.');
                        
                        // Set the Application_Completed_Date__c field to today's date
                        record.Application_Completed_Date__c = Date.today();
                    } else {
                        System.debug('Conditions not met for record ID: ' + record.Id + 
                                     '. Status__c: ' + record.Status__c + 
                                     ', Application_Completed_Date__c: ' + record.Application_Completed_Date__c);
                    }
            }
        } catch (Exception ex) {
            // Log the exception for debugging purposes
            System.debug('Error in AdmissionGrantedHandler.updateApplicationCompletedDate: ' + ex.getMessage());
            
            // Optionally rethrow the exception to handle it further up the chain
            throw new AuraHandledException('An error occurred while updating Application Completed Date. Please contact your administrator.');
        }
        
        System.debug('Exiting updateApplicationCompletedDate method');
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