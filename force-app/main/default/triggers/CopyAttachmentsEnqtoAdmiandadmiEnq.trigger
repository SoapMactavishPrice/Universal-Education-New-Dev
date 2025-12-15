/**
 * Trigger      : EnquiryCURUpdateContactTrigger
 * Classes      : EnquiryCURUpdateContactCtrl,Test_EnquiryCURUpdateContactCtrl
 * Devloper     : Raj
 * Created Date : 30/12/2021
 */
trigger CopyAttachmentsEnqtoAdmiandadmiEnq on Attachment (after insert) {
    Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('CopyAttachmentsEnqtoAdmiandadmiEnq');
    if (Trigger_Switch.IsActive__c == true) {
        CopyAttachmentsEnqtoAdmiandadmiEnqCtrl.CopyAttachmentsEnqtoAdmiandadmiEnqIns(Trigger.new,Trigger.isAfter,Trigger.isInsert);
    }
}