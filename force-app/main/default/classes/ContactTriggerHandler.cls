public class ContactTriggerHandler extends TriggerHandler{
/* Trigger logics for Contact */
    	public override void afterInsert(){
            List<Contact> triggerNew = Trigger.New; 
            Set<ID> accountIdSet = new Set<ID>();
                        
            for(Contact newContact: triggerNew){ 
                //check if contact is related to account 
                if(newContact.AccountId!=null){
                    accountIdSet.add(newContact.AccountId);
                    
                    // Create an approval request for the contact
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for contact approval...');
                    req1.setObjectId(newContact.Id);
                    
                    // Submit on behalf of a specific submitter
                    // req1.setSubmitterId(user1.Id);
                    
                    // Submit the record to Approval process
                    req1.setProcessDefinitionNameOrId('Approve_new_contact');
                    req1.setSkipEntryCriteria(true);
                    
                    // Submit the approval request for the contact
                    Approval.ProcessResult result = Approval.process(req1);
                    System.debug('Approval submitted successfully: ' + result.isSuccess());
                } 
            } if(!accountIdSet.isEmpty()){ 
                calculateCountOnAccount(accountIdSet); 
            } 
        }
    
    	public override void afterUpdate(){ 
            List<Contact> triggerNew = Trigger.New; 
            Map<ID, Contact> triggerOldMap = (Map<ID, Contact>)Trigger.oldMap; 
            Set<ID> accountIdSet = new Set<ID>(); 
            
            for(Contact newContact: triggerNew){ 
                Contact oldContact = triggerOldMap.get(newContact.Id); 
                //check if contact account is changed and contact is realted to account
                if(newContact.AccountId !=null ){ 
                    if(newContact.AccountId!=oldContact.AccountId){ 
                        //Yes, add accountId to accountIdSet
                        accountIdSet.add(newContact.AccountId); 
                    } 
                }else if(newContact.AccountId == null && oldContact.AccountId!=null){ 
                    accountIdSet.add(oldContact.AccountId); 
                } 
            } if(!accountIdSet.isEmpty()){ 
                calculateCountOnAccount(accountIdSet); 
            } 
        }

    	public override void afterDelete(){ 
            List<Contact> triggerOld = Trigger.Old; 
            Set<ID> accountIdSet = new Set<ID>();
            
            for(Contact oldContact: triggerOld){ 
                if(oldContact.AccountId!=null){ 
                    accountIdSet.add(oldContact.AccountId); 
                } 
            } if(!accountIdSet.isEmpty()){ 
                calculateCountOnAccount(accountIdSet); 
            } 
        }
    
		public override void afterUnDelete(){ 
            List<Contact> triggerNew = Trigger.New; 
            Map<ID, Contact> triggerOldMap = (Map<ID, Contact>)Trigger.oldMap; 
            Set<ID> accountIdSet = new Set<ID>();
            
            for(Contact newContact: triggerNew){ 
                if(newContact.AccountId!=null){ 
                    accountIdSet.add(newContact.AccountId); 
                } 
            } if(!accountIdSet.isEmpty()){ 
                calculateCountOnAccount(accountIdSet); 
            } 
        }
    
    	private void calculateCountOnAccount(Set<ID> accountIdSet){
            List<Account> updateAccountList = new List<Account>(); 
            //Get Accounts and their related Contacts 
            for(Account account: [Select Id, Total_Contacts__c, (SELECT Id from Contacts) FROM Account WHERE ID in: accountIdSet]){ 
                    Integer contactCount = 0; 
                    for(Contact contact: account.Contacts){ 
                        contactCount++; 
                } 
                account.Total_Contacts__c = contactCount; 
                updateAccountList.add(account); 
            } if(!updateAccountList.isEmpty()){ 
                update updateAccountList;
            } 
        } 
}