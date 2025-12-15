import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import STATUS_FIELD from '@salesforce/schema/Lead.Lead_Status__c';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeadStatusPath extends LightningElement {
    @api recordId;
    @track picklistValues = [];
    currentStatus;
    recordTypeId;
    isUpdating = false;

    // Get Record Type dynamically
    @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    objectInfoHandler({ data, error }) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
        }
    }

    // Fetch Picklist Values
    @wire(getPicklistValues, { recordTypeId: '$recordTypeId', fieldApiName: STATUS_FIELD })
    picklistHandler({ data, error }) {
        if (data) {
            this.picklistValues = data.values.map(item => ({
                ...item,
                className: 'slds-path__item slds-is-incomplete' // default before loading currentStatus
            }));
            this.updateClasses(); // ensure classes updated if currentStatus is already loaded
        }
    }

    // Fetch current Lead status
    @wire(getRecord, { recordId: '$recordId', fields: [STATUS_FIELD] })
    leadRecordHandler({ data, error }) {
        if (data) {
            this.currentStatus = data.fields.Lead_Status__c.value;
            this.updateClasses(); // mark completed/current stages
        }
    }

    // Determine CSS class based on stage index and currentStatus
    getStageClass(value) {
        if (!this.currentStatus) return 'slds-path__item slds-is-incomplete';

        const currentIndex = this.picklistValues.findIndex(v => v.value === this.currentStatus);
        const thisIndex = this.picklistValues.findIndex(v => v.value === value);

        if (thisIndex < currentIndex) {
            return 'slds-path__item slds-is-complete'; // Completed stage visible
        } else if (thisIndex === currentIndex) {
            return 'slds-path__item slds-is-current slds-is-active'; // Current stage
        } else {
            return 'slds-path__item slds-is-incomplete'; // Future stage
        }
    }

    // Update all stages with correct classes
    updateClasses() {
        if (!this.picklistValues) return;
        this.picklistValues = this.picklistValues.map(item => ({
            ...item,
            className: this.getStageClass(item.value)
        }));
    }

    // Click to update Lead_Status__c
    handleStatusClick(event) {
        const selectedStatus = event.currentTarget.dataset.value;
        if (selectedStatus === this.currentStatus) return;

        this.isUpdating = true;

        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[STATUS_FIELD.fieldApiName] = selectedStatus;

        updateRecord({ fields })
            .then(() => {
                this.currentStatus = selectedStatus;
                this.updateClasses();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Lead status updated to ${selectedStatus}`,
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating status',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isUpdating = false;
            });
    }
}