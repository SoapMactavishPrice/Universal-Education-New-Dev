global class LeadPhoneCleanupBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Query leads with phone numbers that might need cleaning
        return Database.getQueryLocator([
            SELECT Id, MobilePhone 
            FROM Lead 
            WHERE MobilePhone != null 
            AND (MobilePhone LIKE '+9191%' 
                 OR MobilePhone LIKE '9191%')
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead ld : scope) {
            if (String.isBlank(ld.MobilePhone)) continue;
            
            String cleaned = normalizeIndianMobile(ld.MobilePhone);
            
            if (cleaned != ld.MobilePhone) {
                ld.MobilePhone = cleaned;
                leadsToUpdate.add(ld);
            }
        }
        
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
    
    private static String normalizeIndianMobile(String phone) {
        if (String.isBlank(phone)) return phone;
        
        Boolean hasPlus = phone.startsWith('+');

        String digits = '';
        for (Integer i = 0; i < phone.length(); i++) {
            String c = phone.substring(i, i + 1);
            if (c >= '0' && c <= '9') {
                digits += c;
            }
        }

        if (digits.length() < 12) {
            return phone;
        }

        while (digits.startsWith('91') && digits.length() > 12) {
            digits = digits.substring(2);
        }
        
        // Return normalized format if valid Indian mobile number
        if (digits.length() == 12 && digits.startsWith('91')) {
            return hasPlus ? '+' + digits : digits;
        }
        
        // Return original if format is unclear or not Indian mobile
        return phone;
    }
    
    global void finish(Database.BatchableContext bc) {
        // Optional: Add completion logic here
        System.debug('LeadPhoneCleanupBatch completed');
    }
}