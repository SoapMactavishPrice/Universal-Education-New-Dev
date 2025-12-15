public class UE_DocumentDetail {
    public list<List_of_Document__c> listDoc {get;set;}
    public list<Document_Detail__c> docDetail{get;set;}
    public list<Document_Detail__c> docList{get;set;}
    public boolean msg{get;set;}
    Public Admission_Form__c addForm{get;set;}
    public string leadid{get;set;}
    Id pid=Apexpages.currentpage().getParameters().get('id');
    string message{get;set;}
    
    public UE_DocumentDetail(ApexPages.StandardController Controller)
    {
        
        
        listDoc = [Select id,name,isOptional__c,isSubmitted__c,Submission_Date__c from List_of_Document__c ];
        system.debug('List of document::::::'+listDoc);
        msg = True;
        
        docList = [Select id,Name,Admission_Form__c from Document_Detail__c where Admission_Form__c=: pid ];
        system.debug('DOCUMENT DETAIL LIST:::'+docList);
        
        addForm = [Select id,Name,Non_Stellar_Interaction_Scheduled__c,Called_for_Observation__c,Status__c,Enquiry_Number__c,Enquiry_No__r.Lead_ID__c from Admission_Form__c where Id =:pid];
        leadid =addForm.Enquiry_No__r.Lead_ID__c; 
        system.debug('leadid:::'+leadid);
        system.debug('Admision:::'+addForm);
            if(addForm.Non_Stellar_Interaction_Scheduled__c == False){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Interaction-Scheduled is not scheduled '));
                msg=False;
            }
        
        
        
        
        system.debug('DOCUMENT DETAIL LIST Size:::'+docList.size());
        if(docList.size()>0){
            system.debug('DOCUMENT DETAIL LIST(Inside IF) Size:::'+docList.size());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Original Documents are  already verified and Submitted, You can now manage pending documents from Document Sections.'));
            msg=False;
        }
        
    }
    public PageReference saveDocument()
    {
        list<Document_Detail__c> docDetail1 = new list<Document_Detail__c>();
        list<lead> lilead = new list<lead>();
        system.debug('listdoc::'+listDoc);
        system.Debug('listdoc _Size::::'+listDoc.size());
        pageReference pg2;
        try{
            if(listDoc.size()>0 && addForm.Non_Stellar_Interaction_Scheduled__c == true)
            {
                for(List_of_Document__c lod:listDoc)
                {   
                    Document_Detail__c dd = new Document_Detail__c();
                    dd.Admission_Form__c= pid;
                    dd.Name = lod.Name;
                    dd.Is_optional__c = lod.isOptional__c;
                    system.debug('date::'+lod.Submission_Date__c);
                    if(lod.Submission_Date__c != null){
                        system.debug('inside ifdate::'+lod.Submission_Date__c);
                        dd.Is_Submitted__c = true;
                    }else{
                    dd.Is_Submitted__c = lod.isSubmitted__c;
                    }
                    dd.Submission_Date__c = lod.Submission_Date__c;
                    docDetail1.add(dd);
                }
                system.debug('document Detail:::'+docDetail1);
                insert docDetail1;
                addForm.Status__c ='Document Checklist';
                update addForm;
                list<lead> listlead = [SELECT Id, Name, Lead_ID__c, Stage__c FROM Lead where Lead_ID__c=:leadid];
                for(lead sl: listlead){
                    lead nlead = new lead();
                    nlead.id = sl.id;
                    nlead.Stage__c = 'Document Checklist';
                    lilead.add(nlead);
                }
                if(!lilead.isEmpty()){
                    update lilead;
                }
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Something went wrong please try again. '));            
            }
            pg2 =  new PageReference('/'+pid);
        }catch(Exception ex){
            System.debug('Error Message '+ex.getMessage());
        }
        
        /* PageReference newpage = new PageReference('/'+pid);
newpage.setRedirect(true); */
        return pg2;
    }
    
    
    
            
    }
    
//}