import { api,track } from 'lwc';
import LightningModal from 'lightning/modal';
import { NavigationMixin } from 'lightning/navigation';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLostReasonPicklistValues from '@salesforce/apex/EnquiryLostController.getLostReasonPicklistValues';
import saveEnquiryLost from '@salesforce/apex/EnquiryLostController.saveEnquiryLost';

export default class EnquiryLostModal extends NavigationMixin(LightningModal) {
    @api recordId;
    lostReasons = ''; 
    lostComment = '';
    lostReasonOptions = [];
    @track Message = '';
    @track showSpinner = false;
     hasClosed = false;


    connectedCallback() {
        this.fetchPicklistOptions();
    }

    async fetchPicklistOptions() {
        try {
            const options = await getLostReasonPicklistValues();
            this.lostReasonOptions = options;

            console.log('OUTPUT : ',this.lostReasonOptions);
            const defaultOption = options.find(opt => opt.value === 'Reject');
            if (defaultOption) {
                this.lostReasons = 'Reject';
            }
        } catch (error) {
            this.showToast('Error', 'Failed to load Lost Reason options', 'error');
        }
    }

    handleLostReasonChange(event) {
        this.lostReasons = event.detail.value;
    }

    handleCommentChange(event) {
        this.lostComment = event.detail.value;
    }

    async handleSave(event) {

       

        event.preventDefault();
        event.stopPropagation();

        

        
        if (!this.lostReasons || this.lostReasons.trim() === '') {
            // this.showToast('Validation Error', 'Please select a Lost Reason.', 'warning');
            // return;
            this.Message ='Please select a Lost Reason.';
            return;
        }

        if (!this.lostComment || this.lostComment.trim() === '') {
            this.Message ='Please enter Lost Comment.';
            return;
            //this.showToast('Validation Error', 'Please enter Lost Comment.', 'warning');

        }

        // if (this.lostComment.trim().length < 200) {
        //     //this.showToast('Validation Error', 'Lost Comment must be at least 200 characters.', 'warning');
        //     //alert('Lost Comment must be at least 200 characters.');
        //     this.Message ='Lost Comment must be at least 200 characters.';
        //     return;
        // }

        try {
            this.showSpinner = true;
            await saveEnquiryLost({
                recordId: this.recordId,
                lostReason: this.lostReasons,
                comment: this.lostComment
            });

                        this.Message ='Enquiry marked as lost successfully';
this.showSpinner = false;
            if (!this.hasClosed) {
                
            this.hasClosed = true;
            setTimeout(() => {
//window.location.reload();

this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.recordId,
        actionName: 'view'
    }
});

                this.close('refresh');
            }, 10); // defers to event loop to avoid concurrent closing
        }



        } catch (error) {
            this.showSpinner = false;

            this.Message =error?.body?.message || 'Save failed';
            //this.showToast('Error', error?.body?.message || 'Save failed', 'error');
        }

    }

    handleCancel(event) {
        event.preventDefault();
        event.stopPropagation();

        
this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.recordId,
        actionName: 'view'
    }
});
        this.close('cancel'); 
    }

    showToast(title, message, variant) {
    const event = new CustomEvent('showtoast', {
        detail: { title, message, variant },
        bubbles: true,
        composed: true
    });
    this.dispatchEvent(event);
}

}