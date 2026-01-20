public class CCAvenuePaymentGateway_Cntl {
    public String encRequest{get;set;}
    public String eid;
    public String amt{get;set;}
    public String schoolName{get;set;}
    public String schoolText{get;set;}    
    public CC_Avenue_Settings__c ccAvenueSettings{get;set;} 
    public Enquiry__c objEnquiry;
    public Map<String,Universal_Application_Fee_Amount__mdt> schoolNameUAmdtMap;
    
    public CCAvenuePaymentGateway_Cntl() {
        System.debug('Controller eid');
        eid = ApexPages.currentPage().getParameters().get('eid');
        
        schoolName = '';
        
        System.debug('eid -> '+eid);
        if(eid != null && eid !=''){
            objEnquiry = new Enquiry__c();
            objEnquiry = [SELECT ID, Seeking_Admission_in_Grade__c,School_Institution__c,Order_Id__c,School_Institution__r.School_Short_Code__c FROM Enquiry__c WHERE ID =: eid];
            
            List<Class__c> classList = new List<Class__c>([SELECT School_Name_on_PDF__c FROM Class__c WHERE School_Name__c =: objEnquiry.School_Institution__c AND Original_Class__c =: objEnquiry.Seeking_Admission_in_Grade__c]);
            
            if(classList.size()>0){
                schoolName = classList[0].School_Name_on_PDF__c;
            }
        }
        
        schoolNameUAmdtMap = new Map<String,Universal_Application_Fee_Amount__mdt>();
        for (Universal_Application_Fee_Amount__mdt mdtUAFA : [SELECT Merchant_ID__c,Application_Fees__c , Message__c,Short_Code__c FROM Universal_Application_Fee_Amount__mdt WHERE Short_Code__c =: objEnquiry.School_Institution__r.School_Short_Code__c]) {
            schoolNameUAmdtMap.put(mdtUAFA.Short_Code__c,mdtUAFA);
        }
        
        if(schoolNameUAmdtMap.containsKey(objEnquiry.School_Institution__r.School_Short_Code__c)){
            schoolText = schoolNameUAmdtMap.get(objEnquiry.School_Institution__r.School_Short_Code__c).Message__c;     
            amt = schoolNameUAmdtMap.get(objEnquiry.School_Institution__r.School_Short_Code__c).Application_Fees__c;        
        }
    }

    public Pagereference payNow() {
        ccAvenueSettings = CC_Avenue_Settings__c.getInstance(); 
        
        String redirectURL = ccAvenueSettings.Redirect_URL__c+'?eid='+eid;
        String workingKey = ccAvenueSettings.Working_Key__c;
        System.debug('workingKey -> '+workingKey);
        
        String PLAIN_TEXT = 'tid='+ccAvenueSettings.TID__c+'&merchant_id='+schoolNameUAmdtMap.get(objEnquiry.School_Institution__r.School_Short_Code__c).Merchant_ID__c+'&order_id='+objEnquiry.Order_Id__c+'&amount='+amt+'&currency='+ccAvenueSettings.Currency__c+'&redirect_url='+redirectURL+'&cancel_url='+ccAvenueSettings.Cancel_URL__c+'?eid='+eid+'&language='+ccAvenueSettings.Language__c;
        System.debug('PLAIN_TEXT -> '+PLAIN_TEXT);
        
        Blob cryptoKey = Blob.valueOf(workingKey); 
        Blob hash = Crypto.generateDigest('MD5', cryptoKey );
        Blob data = Blob.valueOf(PLAIN_TEXT);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', hash , data);
        encRequest = EncodingUtil.convertToHex(encryptedData); 
        
        Pagereference pageRef = new Pagereference('/apex/CCAvenueRedirectPage?encRequest='+encRequest);        
        pageRef.setRedirect(false);
        return pageRef;
    }

}