// premiumAppointmentController.js
import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updatePremiumAppointmentSetting from '@salesforce/apex/PremiumAppointmentController.updatePremiumAppointmentSetting';

export default class PremiumAppointmentController extends LightningElement {
    @track toggleStates = {
        businessUnit: false,
        territory: false,
        account: false,
        channel: false
    };
    
    @track isLoading = false;

    // Public properties to set initial states
    @api buEnabled = false;
    @api territoryEnabled = false;
    @api accountEnabled = false;
    @api channelEnabled = false;

    connectedCallback() {
        // Initialize toggle states from public properties
        this.toggleStates = {
            businessUnit: this.buEnabled,
            territory: this.territoryEnabled,
            account: this.accountEnabled,
            channel: this.channelEnabled
        };
    }

    get businessUnitToggled() {
        return this.toggleStates.businessUnit;
    }

    get territoryToggled() {
        return this.toggleStates.territory;
    }

    get accountToggled() {
        return this.toggleStates.account;
    }

    get channelToggled() {
        return this.toggleStates.channel;
    }

    async handleToggleChange(event) {
        const toggleType = event.target.dataset.type;
        const newValue = event.target.checked;
        
        this.isLoading = true;
        
        try {
            // Update the local state immediately for better UX
            this.toggleStates = {
                ...this.toggleStates,
                [toggleType]: newValue
            };

            // Call Apex method to persist the change
            await updatePremiumAppointmentSetting({
                settingType: toggleType,
                isEnabled: newValue
            });

            // Dispatch custom event for parent components
            this.dispatchEvent(new CustomEvent('togglechange', {
                detail: {
                    type: toggleType,
                    enabled: newValue,
                    allStates: { ...this.toggleStates }
                }
            }));

            this.showToast('Success', 
                `Premium appointments ${newValue ? 'enabled' : 'disabled'} for ${this.getDisplayName(toggleType)}`, 
                'success');

        } catch (error) {
            // Revert the toggle on error
            this.toggleStates = {
                ...this.toggleStates,
                [toggleType]: !newValue
            };
            
            // Force re-render to show the reverted state
            this.template.querySelector(`[data-type="${toggleType}"]`).checked = !newValue;
            
            this.showToast('Error', 
                `Failed to update ${this.getDisplayName(toggleType)} setting: ${error.body?.message || error.message}`, 
                'error');
        } finally {
            this.isLoading = false;
        }
    }

    getDisplayName(toggleType) {
        const displayNames = {
            businessUnit: 'Business Unit',
            territory: 'Territory',
            account: 'Account',
            channel: 'Channel'
        };
        return displayNames[toggleType] || toggleType;
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    // Public method to update toggle states programmatically
    @api
    updateToggleStates(newStates) {
        this.toggleStates = { ...this.toggleStates, ...newStates };
    }

    // Public method to get current states
    @api
    getToggleStates() {
        return { ...this.toggleStates };
    }
}
