import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import createcontact from '@salesforce/apex/skipEnquiry_LWC.createcontact';

export default class SkipEnquiry_LWC extends LightningElement {
    @api recordId;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.recordId = currentPageReference?.state?.recordId;
    }

    connectedCallback() {
        console.log('connectedCallback called');
        console.log('recordId', this.recordId);
        this.fetchcontact();
    }

    fetchcontact() {
        createcontact({ ContactId: this.recordId })
            .then(result => {
                console.log('result', result);
                this.showToast('Success', 'Contact Created', 'success');
            })
            .catch(error => {
                console.error('Error creating contact:', error);
                this.showToast('Error', 'Failed to create contact.', 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}