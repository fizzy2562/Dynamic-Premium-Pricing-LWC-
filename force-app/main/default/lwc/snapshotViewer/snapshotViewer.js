import { api, wire,LightningElement } from 'lwc';
import getSnapshot from '@salesforce/apex/SnapshotController.getSnapshot';

const columns = [
    { label: 'Label', fieldName: 'urlLink', type: 'url', 
        typeAttributes: { 
            label: { fieldName: 'name' },
            target: '_self'
        }
    },
    { label: 'Category', fieldName: 'category' },
    { label: 'Amount', fieldName: 'amount', type: 'currency',
        cellAttributes: {
            iconName : {fieldName: 'icon'},
            iconPosition: 'left',
            class: { fieldName: 'format' },
        }
     },

];

export default class SnapshotViewer extends LightningElement {
    data = [];
    columns = columns;
    BASE_URL = window
    @api recordId;

    @wire(getSnapshot, { recordId: '$recordId' })
    wiredSnapShotData({data,error}){
        if(data){
            const response = JSON.parse(data.Snapshot_Data__c);
            response.forEach(element => {
                element.urlLink = element.isAsset === true ? `${this.BASE_URL}/lightning/r/Asset__c/${element.id}/view`:`${this.BASE_URL}/lightning/r/Liability__c/${element.id}/view`;
                element.format = element.isAsset === true ? 'slds-text-color_success':'slds-text-color_error';
                element.icon = element.isAsset === true ? 'utility:jump_to_top':'utility:jump_to_bottom';
            });
            this.data = response;
        }
    }

    connectedCallback() {
        this.BASE_URL = window.location.origin;
    }
}