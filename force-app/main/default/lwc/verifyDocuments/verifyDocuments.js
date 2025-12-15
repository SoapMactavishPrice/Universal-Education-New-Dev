import { LightningElement, api, track, wire } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import Document_Detail__c from '@salesforce/schema/Document_Detail__c';
import Submission_Status__c from '@salesforce/schema/Document_Detail__c.Submission_Status__c';

import getDocumentDetails from '@salesforce/apex/VerifyDocumentsController.getDocumentDetails';
import saveAndProceed from '@salesforce/apex/VerifyDocumentsController.saveAndProceed';

export default class VerifyDocuments extends NavigationMixin(LightningElement) {
    @api applicationFormId;

    @track documentList = [];
    @track error;
    errorMessage;

    @track statusOptions = [];
    @track isLoading = false;

    @wire(getObjectInfo, { objectApiName: Document_Detail__c })
    formObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$formObjectInfo.data.defaultRecordTypeId', fieldApiName: Submission_Status__c })
    wiredStatus({ data, error }) {
        if (data) {
            this.statusOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));

        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    @wire(getDocumentDetails, { applicationFormId: '$applicationFormId' })
    wiredDocs({ error, data }) {
        if (data) {
            // copy data to a local tracked array so we can mutate safely
            this.documentList = data.map(item => ({ ...item }));
            this.error = undefined;
            this.errorMessage = undefined;
        } else if (error) {
            this.documentList = [];
            this.error = error;
            // simple error message
            this.errorMessage = (error.body && error.body.message) ? error.body.message : JSON.stringify(error);
        }
    }

    handleStatusChange(event) {
        const docId = event.target.dataset.id;
        const newValue = event.target.value;

        const idx = this.documentList.findIndex(d => String(d.documentId) === String(docId));
        if (idx !== -1) {
            // replace the array to ensure reactivity
            const updated = this.documentList.map((d, i) => {
                if (i === idx) {
                    return { ...d, submissionStatus: newValue };
                }
                return d;
            });
            this.documentList = updated;
        }
    }

    handleSaveAndProceed() {
        this.isLoading = true;
            console.log('applicationFormId', this.applicationFormId);
            saveAndProceed({ wrapperList: this.documentList, applicationFormId: this.applicationFormId }).then((result)=>{
                if (result == 'Success') {
                    this.showToast('Success', 'Saved Successfully', 'success');
                    this.goBackToRecord();
                } else {
                    this.showToast('Error', result, 'error');
                }
            }).catch((error)=>{
                this.isLoading = false;
                console.log('error', error);
                this.showToast('Error', error.body?.message || 'An error occurred while saving.', 'error');
            })
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: 'dismissable'
            })
        );
    }

    goBackToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.applicationFormId,
                actionName: 'view'
            }
        });
    }
}