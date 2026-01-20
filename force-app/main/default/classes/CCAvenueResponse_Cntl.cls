public class CCAvenueResponse_Cntl {

    public PageReference redirectToOTPpage() {        
    
        String eid = ApexPages.currentPage().getParameters().get('eid');
        //String amt= ApexPages.currentPage().getParameters().get('amt');
        Map<String,Universal_Application_Fee_Amount__mdt> schoolNameUAmdtMap = new Map<String,Universal_Application_Fee_Amount__mdt>();
        for (Universal_Application_Fee_Amount__mdt mdtUAFA : [SELECT MasterLabel, QualifiedApiName, Application_Fees__c ,Merchant_ID__c, Payment_Applicable__c, Payment_Gateway__c, Short_Code__c FROM Universal_Application_Fee_Amount__mdt]) {
            schoolNameUAmdtMap.put(mdtUAFA.Short_Code__c,mdtUAFA);
        }
        
        Enquiry__c enq = new Enquiry__c();
        enq = [SELECT Payment_Done__c,Payment_Status__c,Amount__c,School_Institution__r.School_Short_Code__c FROM Enquiry__c where Id =: eid];
        enq.Payment_Done__c = true;
        enq.Payment_Status__c = 'Success';
        if(schoolNameUAmdtMap.containsKey(enq.School_Institution__r.School_Short_Code__c)){
            enq.Amount__c = Decimal.valueOf(schoolNameUAmdtMap.get(enq.School_Institution__r.School_Short_Code__c).Application_Fees__c);
        }
        
        update enq;
        
        return new PageReference('/UE_applicationForm_Site?eid='+eid);
    }
    
    /*public PageReference redirectToOTPpage() {        
    
        String eid = ApexPages.currentPage().getParameters().get('eid');
        String amt= ApexPages.currentPage().getParameters().get('amt');
        
        return new PageReference('/UE_applicationForm_Site?eid='+eid);
    }*/

}