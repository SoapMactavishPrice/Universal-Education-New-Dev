public class ApplicationPaymentGateway_Ctrl 
{
    //public String encRequest{get;set;}
    public String KeyValue{get;set;}
    public String eid{get;set;}
    public String eName{get;set;}
    public String eEmail{get;set;}
    public String eContactNo{get;set;}
    public String enqOrderId{get;set;}
    public String amt{get;set;}
    public String amount{get;set;}
    public String schoolName{get;set;}
    public String schoolText{get;set;}    
    //public CC_Avenue_Settings__c ccAvenueSettings{get;set;} 
    public Enquiry__c objEnquiry;
    public Map<String,Universal_Application_Fee_Amount__mdt> schoolNameUAmdtMap;
    
    public string endpoint{get;set;}
    public string orderId{get;set;}    
    public boolean viewPay{get;set;}
    public string jsonbody{get;set;}
    public string Resbody{get;set;}
    public boolean isScuuess{get;set;}
    public string paymentId{get;set;}
    public checkoutRespponse response{get;set;}
    
    public ApplicationPaymentGateway_Ctrl() 
    {
        System.debug('Controller eid');
        eid = ApexPages.currentPage().getParameters().get('eid');
        response = new checkoutRespponse();
                      
        schoolName = '';
       // KeyValue = Label.RazorpayKey;
        
        System.debug('eid -> '+eid);
        if(eid != null && eid !=''){
            objEnquiry = new Enquiry__c();
            objEnquiry = [SELECT ID,Name,Email__c,gen_Contact_No__c,Order1_Id__c,Signature_Id__c,Payment_Id__c,Seeking_Admission_in_Grade__c,School_Institution__c,
                          Order_Id__c,School_Institution__r.School_Short_Code__c,ParentFull_Name__c,Mobile_No__c FROM Enquiry__c WHERE ID =: eid];
            eName = objEnquiry.ParentFull_Name__c;
            eEmail = objEnquiry.Email__c;
            eContactNo = objEnquiry.Mobile_No__c;
            enqOrderId = objEnquiry.Order1_Id__c;
            
            List<Class__c> classList = new List<Class__c>([SELECT School_Name_on_PDF__c FROM Class__c WHERE School_Name__c =: objEnquiry.School_Institution__c AND Original_Class__c =: objEnquiry.Seeking_Admission_in_Grade__c]);
            
            if(classList.size()>0){
                schoolName = classList[0].School_Name_on_PDF__c;
            }
        }
        
        schoolNameUAmdtMap = new Map<String,Universal_Application_Fee_Amount__mdt>();
        for (Universal_Application_Fee_Amount__mdt mdtUAFA : [SELECT Merchant_ID__c,Application_Fees__c ,Message__c,Short_Code__c,Payment_Applicable__c,Key_Id__c,
                       Payment_Gateway__c FROM Universal_Application_Fee_Amount__mdt WHERE Short_Code__c =: objEnquiry.School_Institution__r.School_Short_Code__c
                       and Payment_Applicable__c =true and Payment_Gateway__c = 'RazorPay' and Key_Id__c != null]) {
            schoolNameUAmdtMap.put(mdtUAFA.Short_Code__c,mdtUAFA);
            //KeyValue = mdtUAFA.Key_Id__c;
        }
        
        if(schoolNameUAmdtMap.containsKey(objEnquiry.School_Institution__r.School_Short_Code__c)){
            schoolText = schoolNameUAmdtMap.get(objEnquiry.School_Institution__r.School_Short_Code__c).Message__c;     
            amt = schoolNameUAmdtMap.get(objEnquiry.School_Institution__r.School_Short_Code__c).Application_Fees__c;        
            amount = schoolNameUAmdtMap.get(objEnquiry.School_Institution__r.School_Short_Code__c).Application_Fees__c; 
            amount =  amount.substring(0,amount.length()-2);
             KeyValue = schoolNameUAmdtMap.get(objEnquiry.School_Institution__r.School_Short_Code__c).Key_Id__c;
        }
        endpoint = Razorpay_Endpoint__c.getInstance('Check Out').Endpoint__c;
        viewPay = false;
        isScuuess = false;
    }
   
    public Pagereference paynow() 
    {        
        response = (checkoutRespponse)System.JSON.deserialize(paymentId, checkoutRespponse.class);
        system.debug('=====paymentId====' + paymentId); 
        system.debug('=====ResOrderId====' + response); 
        
         
        system.debug('====after updation===='+  objEnquiry);  
        if(response.razorpay_payment_id != null && string.isNotEmpty(response.razorpay_payment_id))
        { 
            objEnquiry.Payment_Id__c = response.razorpay_payment_id;
            objEnquiry.Order1_Id__c =  response.razorpay_order_id;
            objEnquiry.Signature_Id__c = response.razorpay_signature;
            objEnquiry.Payment_Status__c = 'Success';
            objEnquiry.Payment_Done__c = true;
            update objEnquiry;
            Pagereference pageRef = new Pagereference('/apex/UE_applicationForm_Site?eid='+eid);        
            pageRef.setRedirect(false);
            return pageRef;
        }
        return null;
    }
    
    public class checkoutRespponse{
        public string razorpay_payment_id;
        public string razorpay_order_id;
        public string razorpay_signature;
    }
    
}