import { LightningElement, api } from 'lwc';
import syncAdmissionGranted from '@salesforce/apex/AdmissionGrantedSyncHandler.syncAdmissionGranted';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class AdmissionGrantedEtherSyncAction extends LightningElement {
    @api
    set recordId(value) {
        if (value) {
            this._recordId = value;
            console.log('Admission Granted Id received:', value);
            this.syncWithEther();
        }
    }
    get recordId() {
        return this._recordId;
    }
    isExecuted = false;
    async syncWithEther() {
        if (this.isExecuted) return;
        this.isExecuted = true;
        try {
            const result = await syncAdmissionGranted({ recordId: this.recordId });
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Ether Sync',
                    message: result,
                    variant: result === 'This record is already synced' ? 'warning' : 'success'
                })
            );
            this.dispatchEvent(new RefreshEvent());
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error?.body?.message || error.message,
                    variant: 'error'
                })
            );
        } finally {
            this.dispatchEvent(new CloseActionScreenEvent());
        }
    }
}