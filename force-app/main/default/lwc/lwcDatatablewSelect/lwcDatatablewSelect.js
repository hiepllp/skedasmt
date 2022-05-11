import { LightningElement,wire,track, api } from 'lwc';  
import {refreshApex} from '@salesforce/apex';  
import getAllOps from '@salesforce/apex/shipracingController.fetchShipList';  
import deleteShip from '@salesforce/apex/shipracingController.deleteShip';  
 const COLS=[  
   {label:'Name',fieldName:'Name', type:'text'},  
   {label:'Price',fieldName:'Price__c', type:'currency'},  
   {label:'Length(m)',fieldName:'Length__c', type:'integer'}  
 ];  
 export default class LwcDatatablewSelect extends LightningElement {  
    @api getIdFromParent;
    @api objectApiName;

   cols=COLS;  
   @wire(getAllOps) boatList;  
   deleteRecord(){  
     var selectedRecords =  
      this.template.querySelector("lightning-datatable").getSelectedRows();  
      deleteShip({boatList: selectedRecords})  
     .then(result=>{  
       return refreshApex(this.boatList);  
     })  
     .catch(error=>{  
       alert('Cloud not delete'+JSON.stringify(error));  
     })  
   }  
 }