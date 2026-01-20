import { LightningElement, api } from 'lwc';
import transferNotes from '@salesforce/apex/TransferNotesAcrossSystem.transferNotesFromEnquiryToApplicationForm';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EnquiryNotesTransfer extends LightningElement {
    @api
    set recordId(value) {
        if (value) {
            this._recordId = value;
            console.log('AppFormId received:', value);
            this.transferNotesToApplicationForm();
        }
    }
    get recordId() {
        return this._recordId;
    }

    async transferNotesToApplicationForm() {
        try {
            const count = await transferNotes({ applicationFormId: this.recordId });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: `Transferred ${count} note(s)/file(s).`,
                    variant: 'success'
                })
            );
        } catch (e) {
            const msg = e?.body?.message || e?.message || 'Unknown error';

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: msg,
                    variant: 'error'
                })
            );
        } finally {
            this.dispatchEvent(new CloseActionScreenEvent());
        }
    }

}
