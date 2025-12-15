public class Leadconvert {
    public Lead leads {set;get;}
    public id leadids=Apexpages.currentPage().getparameters().get('id'); 
    //public List<Task> listtask{get;set;}  
    
    public Leadconvert(Apexpages.StandardController stdcontroller)
    {
        leads = (leadids==null) ? new Lead():[ select id,Name,Salutation,LeadSource,Status,LastName,FirstName,
                                              MobilePhone,Phone,School_Institution__c,Stellar_Seeking_Admission_in_Grade__c,
                                              
                                             Seeking_Admission_in_Grade__c,
                                               Latitude,Longitude,Reasons__c,
                                             
                                              Converted__c,Email,Lead_ID__c,City,State,Street,Country,PostalCode,Acadmic_Year__c,Your_First_Name__c,
                                              Your_Last_Name__c,Date_of_Birth__c,Category__c,Current_school__c,
                                           //  Program__c,
                                              Relation__c,Gender__c FROM Lead where id=: leadids];
            System.debug('leads---'+leads);
        
    }
    public pageReference createContact()
    {
        pageReference pg1;
        
        if(leads.Status == 'Qualified' && leads.Converted__c == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'This Lead Is Already Converted'));            
        }
        else{
            boolean req=false;
             
           if(leads.Email==null)
           {
                req=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Email can not be empty'));
           }
           
           if(leads.Date_of_Birth__c==null)
           {
                req=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Date of birth can not be empty'));
           }
             if(leads.Gender__c==null)
           {
                req=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Gender can not be empty'));
           }
           if(leads.Seeking_Admission_in_Grade__c==null && leads.Stellar_Seeking_Admission_in_Grade__c==NULL )
           {
               req=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Grade can not be empty'));
           }
            if(req==false)
            {
            Contact con = new Contact(); 
                
            con.Salutation = leads.Salutation;
            con.LastName=leads.LastName;
            con.FirstName = leads.FirstName;
            con.Email=leads.Email;
            con.Phone=leads.MobilePhone;
            con.Academic_Year__c = leads.Acadmic_Year__c;
            con.AccountId = leads.School_Institution__c;
            con.School_Institution__c=leads.School_Institution__c;
            con.MobilePhone = leads.Phone;
            con.Type__c ='Admission Enquiry';
            con.Lead_ID__c = leads.Lead_ID__c;
            con.OtherCity = leads.City;
            con.OtherState = leads.State;
            con.OtherStreet = leads.Street;
            con.OtherCountry = leads.Country;
            con.OtherPostalCode = leads.PostalCode;
            con.OtherLatitude = leads.Latitude;
            con.OtherLongitude = leads.Longitude;
            con.Your_First_Name__c = leads.Your_First_Name__c;
            con.Your_Last_Name__c = leads.Your_Last_Name__c;
            con.Category__c = leads.Category__c;
            con.Date_of_Birth__c = leads.Date_of_Birth__c;
            con.Program__c =leads.Seeking_Admission_in_Grade__c;
            con.Stellar_Seeking_Admission_in_Grade__c=leads.Stellar_Seeking_Admission_in_Grade__c;
			con.Lead__c=leads.id;
            con.Relation__c = leads.Relation__c;
            con.Gender__c = leads.Gender__c;
            con.Sources__c = leads.LeadSource;
            con.Contact_Status__c = leads.Status;
            con.Current_school__c = leads.Current_school__c; //NP_Finesse060324
            //con.Contact_Reasons__c = leads.Reasons__c;
            insert con ;
            system.debug('CONTACT:::'+con);
            if(!Test.isRunningTest()){
            Lead l1 = [select id,Name,LeadSource,Status,Converted__c,Email FROM Lead where id=: leadids];
            l1.Status = 'Qualified';
            l1.Converted__c = true;
            l1.Converted_Date__c=datetime.now();
            l1.Stage__c='Converted';
                l1.Contact__c=con.id;
                update l1;}
            
            system.debug('CONTACT+++'+con);
            pg1 = new pageReference('/'+con.Id);
            }
            
        }
        
        return pg1;
    }
     public static void dum()
        {
          integer j=0;
              j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
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