/**
 * Trigger      : DisclosureTrigger
 * Classes      : DisclosureTriggerHandellerCtrl,Test_DisclosureTriggerHandellerCtrl
 * Devloper     : Rajesh Kumar
 * Created Date : 30/12/2021
 */
trigger DisclosureTrigger on Disclosure__c (after insert,after update) {
    Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('DisclosureTriggerSwitch');
    if (Trigger_Switch.IsActive__c == true) {
		DisclosureTriggerHandellerCtrl.DisclosureTriggerAftInsUpdate(Trigger.new,Trigger.isAfter,Trigger.isInsert,Trigger.isUpdate);
    }
}