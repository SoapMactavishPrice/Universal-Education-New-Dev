import { LightningElement, api } from 'lwc';

export default class EnquiryLostWrapper extends LightningElement {
    @api recordId;
    isModalOpen = false;

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}