import { LightningElement, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import markLeadAsLost from '@salesforce/apex/LostLeadController.markLeadAsLost';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import LOST_REASONS_FIELD from '@salesforce/schema/Lead.Lost_Reasons__c';

export default class LostLeadHandler extends LightningElement {
    @api recordId;
    lostReason = '';
    lostComment = '';
    isSaving = false;
    lostReasonOptions = [];

    @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: LOST_REASONS_FIELD
    })
    wiredLostReasons({ data, error }) {
        if (data) {
            this.lostReasonOptions = data.values.map((entry) => ({
                label: entry.label,
                value: entry.value
            }));
        } else if (error) {
            this.showToast('Error', this.getErrorMessage(error), 'error');
        }
    }

    handleReasonChange(event) {
        this.lostReason = event.detail.value;
    }

    handleCommentChange(event) {
        this.lostComment = event.target.value;
    }

    handleCancel() {
        this.closeAction();
    }

    async handleSave() {
        this.isSaving = true;
        try {
            await markLeadAsLost({
                recordId: this.recordId,
                lostReason: this.lostReason,
                lostComment: this.lostComment
            });

            this.showToast('Success', 'Lead updated as lost.', 'success');
            this.dispatchEvent(new RefreshEvent());
            this.closeAction();
        } catch (error) {
            this.showToast('Error', this.getErrorMessage(error), 'error');
        } finally {
            this.isSaving = false;
        }
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }

    getErrorMessage(error) {
        if (Array.isArray(error?.body)) {
            return error.body.map((e) => e.message).join(', ');
        }
        return error?.body?.message || error?.message || 'Unknown error';
    }
}
