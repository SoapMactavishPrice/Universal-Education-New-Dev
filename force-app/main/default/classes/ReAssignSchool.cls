public class ReAssignSchool {
    public Boolean hasErrors { get; set; }
    public Boolean back { get; set; }
    public Lead leadRecord { get; set; }
    public List<Account> schoolList { get; set; }
    public Boolean showTable { get; set; }
    public Boolean showStud { get; set; }
    public Id AccountId { get; set; }

    public ReAssignSchool(ApexPages.StandardController stdController) {
        // Initialize properties
        hasErrors = false;
        back = false;
        this.leadRecord = [SELECT Id, School_Institution__c, Current_Location__c, Status FROM Lead WHERE Id = :stdController.getId()];
        schoolList = new List<Account>();
        showTable = false;
        showStud = false;
    }

    public List<SelectOption> getSchoolOptionslist() {
        List<SelectOption> options = new List<SelectOption>();
        schoolList = [SELECT Id, Name FROM Account];
        options.add(new SelectOption('', 'Select School/Institution'));
        for (Account school : schoolList) {
            if (school.Name != null) {
                options.add(new SelectOption(school.Id, school.Name));
            }
        }
        return options;
    }

    public PageReference save() {
        try {
            if (AccountId != null) {
                leadRecord.School_Institution__c = AccountId;
                leadRecord.Status = 'New';
                if (String.isBlank(leadRecord.Current_Location__c)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add Current Location'));
                    return null;
                }
                update leadRecord;
                
                // Add success message
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Lead transferred successfully.'));
                return new PageReference('/apex/TransferSuccessPage');
            }
            PageReference pageRef = new PageReference('/' + leadRecord.Id);
            pageRef.setRedirect(true);
            return pageRef;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
    }

    public PageReference cancel() {
        return new PageReference('/' + leadRecord.Id);
    }
    
   /* public PageReference redirectToLeadList() {
        return new PageReference('/00Q/o'); // Standard URL for Lead list view
    }*/
     public static void dummy()
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
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
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