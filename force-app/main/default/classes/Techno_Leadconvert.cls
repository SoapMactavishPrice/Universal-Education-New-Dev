public class Techno_Leadconvert {
 public Lead leads {set;get;}
     public id leadids=Apexpages.currentPage().getparameters().get('id'); 
    //public List<Task> listtask{get;set;}  
    
    public Techno_Leadconvert(Apexpages.StandardController stdcontroller)
    {
        leads = (leadids==null) ? new Lead():[ select id,Stellar_Seeking_Admission_in_Grade__c,Name,Salutation,LeadSource,Status,LastName,FirstName,Your_First_Name__c,Your_Last_Name__c,
                                              MobilePhone,Phone,School_Institution__c,Seeking_Admission_in_Grade__c,Latitude,Longitude,
                                              Converted__c,Email,Lead_ID__c,City,State,Street,Country,PostalCode FROM Lead where id=: leadids];
            System.debug('leads---'+leads);
        
    }
    public pageReference createContact()
    {
        pageReference pg1;
        
        if(leads.Status == 'Qualified' && leads.Converted__c == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'This Lead Is Already Converted'));            
        }
        else{
            Contact con = new Contact();
            
            con.Salutation = leads.Salutation;
            con.LastName=leads.LastName;
            con.FirstName = leads.FirstName;
            con.Email=leads.Email;
            con.Phone=leads.MobilePhone;
            con.AccountId = leads.School_Institution__c;
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
            con.Your_First_Name__c=leads.Your_First_Name__c;
            con.Your_Last_Name__c=leads.Your_Last_Name__c;
            con.Stellar_Seeking_Admission_in_Grade__c=leads.Stellar_Seeking_Admission_in_Grade__c;
            insert con ;
            system.debug('CONTACT:::'+con);
            Lead l1 = [select id,Name,LeadSource,Status,Converted__c,Email FROM Lead where id=: leadids];
            System.debug('UPDATE LEAD++++'+l1);
            l1.Status = 'Qualified';
            l1.Converted__c = true;
            update l1;
            System.debug('UPDATED.....++++'+l1);
            
            system.debug('CONTACT+++'+con);
            pg1 = new pageReference('/'+con.Id);
            
        }
        
        return pg1;
    }
}