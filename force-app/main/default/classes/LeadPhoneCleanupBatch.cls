global class LeadPhoneCleanupBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, MobilePhone FROM Lead WHERE MobilePhone != null AND MobilePhone LIKE \'%9191%\''
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> updates = new List<Lead>();
        
        for (Lead ld : scope) {
            String phone = ld.MobilePhone;
            String cleanedPhone = cleanPhoneNumber(phone);
            
            if (cleanedPhone != phone && cleanedPhone != '') {
                ld.MobilePhone = cleanedPhone;
                updates.add(ld);
            }
        }
        
        if (!updates.isEmpty()) {
            Database.update(updates, false);
        }
    }
    
    private String cleanPhoneNumber(String phone) {
        if (phone == null || phone == '') return '';
        
        // Step 1: Remove all non-digit characters and store if it had a plus
        Boolean hadPlusSign = phone.startsWith('+');
        String digitsOnly = '';
        
        for (Integer i = 0; i < phone.length(); i++) {
            String ch = phone.substring(i, i + 1);
            if (ch >= '0' && ch <= '9') {
                digitsOnly += ch;
            }
        }
        
        // Step 2: Check if it starts with '91'
        if (digitsOnly.startsWith('91') && digitsOnly.length() >= 4) {
            // Find where the consecutive '91's stop
            Integer position = 2; // We already have the first '91'
            
            // Keep moving forward while we see '91'
            while (position + 2 <= digitsOnly.length()) {
                String nextTwoDigits = digitsOnly.substring(position, position + 2);
                if (nextTwoDigits == '91') {
                    position += 2; // Skip this '91'
                } else {
                    break; // Stop when we don't see '91'
                }
            }
            
            // If we skipped any '91's (position > 2), rebuild the number
            if (position > 2) {
                // Keep the remaining digits after all the duplicate '91's
                String remainingDigits = digitsOnly.substring(position);
                String result = '91' + remainingDigits;
                
                // Add back the plus sign if original had it
                return hadPlusSign ? '+' + result : result;
            }
        }
        
        // If no changes to digits, return original or digitsOnly based on plus sign
        return hadPlusSign ? '+' + digitsOnly : digitsOnly;
    }
    
    global void finish(Database.BatchableContext bc) {
        // Optional: Add any completion logic here
    }
}