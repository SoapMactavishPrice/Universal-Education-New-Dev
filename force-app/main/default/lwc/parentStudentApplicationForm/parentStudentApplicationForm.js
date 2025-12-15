import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from 'lightning/navigation';

import stellarlogo from "@salesforce/resourceUrl/stellarlogo";
import IHS_School_Logo from "@salesforce/resourceUrl/IHS_School_Logo";
import ESIB_School_Logo from "@salesforce/resourceUrl/ESIB_School_Logo";
import ESIN_School_Logo from "@salesforce/resourceUrl/ESIN_School_Logo";
import Alpha_School_Logo from "@salesforce/resourceUrl/Alpha_School_Logo";
import Primus_School_Logo from "@salesforce/resourceUrl/Primus_School_Logo";
import Universal_School_Logo from "@salesforce/resourceUrl/Universal_School_Logo";

import getEnquiryObject from '@salesforce/apex/StudentApplicationFormController.getEnquiryObject';
import getApplicationFormObj from '@salesforce/apex/StudentApplicationFormController.getApplicationFormObj';
import closeApplicationForm from '@salesforce/apex/StudentApplicationFormController.closeApplicationForm';
import redirectToPaymentPage from '@salesforce/apex/StudentApplicationFormController.redirectToPaymentPage';

export default class ParentStudentApplicationForm extends LightningElement {

    @api enquiryId;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.enquiryId = currentPageReference.state.c__enquiryId;
            console.log('Enquiry Id:', this.enquiryId);
        }
    }

    @track schoolLogo;

    @track currentStep = 1;

    @track schoolCard;

    @track showWaiter = false;

    @track isMobile = false;

    @track isOpen = true; // default open

    @track nationality;

    @track enquiryObject = {};

    @track schoolShortCode;

    @track progressValue = '0, 100';

    @track isComplete = false;

    @track isClosed = false;

    @track enquiryName;

    @track applicationFormName;

    @track applicationFormId;

    @track paymentRequired = false;

    get iconClass() {
        return `icon ${this.isComplete ? 'complete' : ''}`;
    }

    get iconName() {
        return this.isOpen ? 'utility:chevrondown' : 'utility:chevronright';
    }

    get scrollerSvg() {
        return 'progress-circle progress-' + this.schoolCard;
    }

    get scrollerPath() {
        return 'progress path-' + this.schoolCard;
    }

    handleNavigation(event) {
        console.log('old currentStep', this.currentStep);
        console.log("new currentStep: " + event.detail?.page);
        this.currentStep = event.detail?.page;

        this.nationality = event.detail?.nationality;

        if (this.currentStep == 5) {
            closeApplicationForm({enquiryId: this.enquiryId}).then(()=>{}).catch((error)=>{
                console.error('Error closing application form:', error);
                alert('Error closing application form, Please contact administrator.');
            });
            getApplicationFormObj({ enquiryId: this.enquiryId })
            .then(result => {
                if (result != null) {
                    this.applicationFormName = result.Name;
                    this.applicationFormId = result.Id;
                } 
            })
        }

        this.showWaiter = false;

        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });

    }

    handleWaiter(event) {
        console.log('Inside Handle Waiter', JSON.parse(JSON.stringify(event)));
        this.showWaiter = event.detail?.show;
    }

    handleStepClick(event) {
        
        if (this.currentStep == 5) {
            return;
        }

        let step = parseInt(event.currentTarget.dataset.step);

        if (step >= this.currentStep) {
            return;
        }

        event = {
            detail: {
                page: event.currentTarget.dataset.step
            }
        }
        this.handleNavigation(event);
    }

    toggleSection() {
        this.isOpen = !this.isOpen;
    }

    checkIfMobile() {
        this.isMobile = window.innerWidth <= 700;
    }

    get logoClass() {
        return this.isMobile ? 'logoFrontMobile' : 'logoFront';
    }

    get itemSize() {
        return this.isMobile ? '12' : '10';
    }

    showToast(title, msg, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    async connectedCallback() {
        try {
            // First check if payment is required
            const paymentRequired = await this.checkIfPaymentRequired();
            console.log('Payment Required:', paymentRequired);

            if (!paymentRequired) {
                // Load enquiry data first
                const enquiryResult = await getEnquiryObject({ enquiryId: this.enquiryId });
                this.enquiryObject = enquiryResult;
                let value = this.enquiryObject?.School_Institution__r?.School_Short_Code__c;
                this.schoolShortCode = value;
                this.isClosed = this.enquiryObject?.Application_Received__c;
                this.enquiryName = this.enquiryObject?.Name;
                console.log('School Short Code', value);

                if (value == 'STELRA' || value == 'STELRB' || value == 'STELRG') {
                    this.schoolLogo = stellarlogo;
                    this.schoolCard = 'initializer';
                } else if (value == 'IHS') {
                    this.schoolLogo = IHS_School_Logo;
                    this.schoolCard = 'ihs';
                } else if (value == 'EISB') {
                    this.schoolLogo = ESIB_School_Logo;
                    this.schoolCard = 'esib';
                } else if (value == 'EISN') {
                    this.schoolLogo = ESIN_School_Logo;
                    this.schoolCard = 'esib';
                } else if (value == 'ACIS' || value == 'APM' || value == 'AB' || value == 'AWV') {
                    this.schoolLogo = Alpha_School_Logo;
                    this.schoolCard = 'alpha';
                } else if (value == 'PRIMUS') {
                    this.schoolLogo = Primus_School_Logo;
                    this.schoolCard = 'primus';
                } else if (value == 'UAHM' || value == 'UHM' || value == 'USG' || value == 'UST' || value == 'UHD' || value == 'UHT' || value == 'SJU' || value == 'SOUS' || value == 'UHSA' || value == 'UHSC') {
                    this.schoolLogo = Universal_School_Logo;
                    this.schoolCard = 'universal';
                }

                const formResult = await getApplicationFormObj({ enquiryId: this.enquiryId });
                if (formResult != null) {
                    this.applicationFormId = formResult.Id;
                    this.applicationFormName = formResult.Name;
                    if (this.isClosed) {
                        this.currentStep = 5;
                    }
                }
            }
        } catch (error) {
            console.error('Error in initialization:', error);
            this.showToast('Error', error?.body?.message || 'An error occurred during initialization', 'error');
        }

        // Setup event listeners
        window.addEventListener('scroll', this.handleWindowScroll);
        this.checkIfMobile();
        window.addEventListener('resize', this.checkIfMobile.bind(this));
    }

    disconnectedCallback() {
        window.removeEventListener('scroll', this.handleWindowScroll);
        window.removeEventListener('resize', this.checkIfMobile.bind(this));
    }

    handleWindowScroll = () => {
        const scrollTop = window.scrollY;
        const scrollHeight = document.documentElement.scrollHeight - window.innerHeight;
        const percent = scrollHeight === 0 ? 0 : scrollTop / scrollHeight;

        const strokeValue = (percent * 100).toFixed(1);
        this.progressValue = `${strokeValue}, 100`;
        this.isComplete = percent >= 1;
    }

    async checkIfPaymentRequired() {
        try {
            console.log('enquiryId', this.enquiryId);
            const paymentResponse = await redirectToPaymentPage({ enquiryId: this.enquiryId });
            
            if (paymentResponse === 'No Payment Required') {
                console.log('No Payment Required');
                return false;
            }
            
            if (paymentResponse) {
                console.log('Payment URL: ', paymentResponse);
                // Show a toast message and redirect
                this.showToast(
                    'Payment Required', 
                    'You will be redirected to the payment page.', 
                    'info'
                );
                
                // Use timeout to ensure toast is shown before redirect
                setTimeout(() => {
                    window.location.href = paymentResponse;
                }, 2000);
                
                return true;
            }
            
            return false; // Default return if no conditions met
        } catch (error) {
            console.error('Error getting payment URL:', error);
            throw error; // Re-throw the error to be handled by the caller
        }
    }

    get schoolOptions() {
        return [
            { value: 'IHS_School_Logo', label: 'IHS' },
            { value: 'ESIB_School_Logo', label: 'ESIB' },
            { value: 'ESIN_School_Logo', label: 'ESIN' },
            { value: 'Alpha_School_Logo', label: 'Alpha' },
            { value: 'Primus_School_Logo', label: 'Primus' },
            { value: 'Universal_School_Logo', label: 'Universal' }
        ]
    }

    get cardClass() {
        return 'cards ' + this.schoolCard;
    }

    get isInitial() {
        return this.schoolCard == 'initializer';
    }

    get isIhs() {
        return this.schoolCard == 'ihs';
    }

    get isEsib() {
        return this.schoolCard == 'esib';
    }

    get isAlpha() {
        return this.schoolCard == 'alpha';
    }

    get isPrimus() {
        return this.schoolCard == 'primus';
    }

    get isUniversal() {
        return this.schoolCard == 'universal';
    }

    get steps() {
        return [
            { value: 1, label: 'Student Information', class: this.getStepClass(1) },
            { value: 2, label: 'Parent Information', class: this.getStepClass(2) },
            { value: 3, label: 'Declaration', class: this.getStepClass(3) },
            { value: 4, label: 'Attachments', class: this.getStepClass(4) }
        ];
    }

    get stepsMobile() {
        return [
            { value: 1, labelLine1: 'Student', labelLine2: 'Information', class: this.getStepClass(1) },
            { value: 2, labelLine1: 'Parent', labelLine2: 'Information', class: this.getStepClass(2) },
            { value: 3, labelLine1: 'Declaration', labelLine2: '', class: this.getStepClass(3) },
            { value: 4, labelLine1: 'Attachment', labelLine2: '', class: this.getStepClass(4) }
        ];
    }

    getStepClass(stepNum) {
        if (this.currentStep == stepNum) return 'step active';
        if (this.currentStep > stepNum) return 'step complete';
        return 'step';
    }

    get isStep1() { return this.currentStep == 1; }
    get isStep2() { return this.currentStep == 2; }
    get isStep3() { return this.currentStep == 3; }
    get isStep4() { return this.currentStep == 4; }
    get isStep5() { return this.currentStep == 5; }

    get isFirstStep() { return this.currentStep == 1; }
    get isLastStep() { return this.currentStep == 4; }

}