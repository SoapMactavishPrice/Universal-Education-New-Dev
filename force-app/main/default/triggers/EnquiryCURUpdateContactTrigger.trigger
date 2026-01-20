/**
 * Trigger      : EnquiryCURUpdateContactTrigger
 * Classes      : EnquiryCURUpdateContactCtrl,Test_EnquiryCURUpdateContactCtrl
 * Devloper     : Raj
 * Created Date : 30/12/2021
 */
trigger EnquiryCURUpdateContactTrigger on Enquiry__c (after insert,after update) {
    Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('EnquiryCURUpdateContact');
    if (Trigger_Switch.IsActive__c == true) {
        EnquiryCURUpdateContactCtrl.EnquiryCURUTriggerAftInsUpdate(Trigger.new,Trigger.isAfter,Trigger.isInsert,Trigger.isUpdate);
    }
}