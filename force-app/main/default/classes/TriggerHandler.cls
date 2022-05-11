public virtual class TriggerHandler { 
    public virtual void beforeInsert(){ } 
    public virtual void afterInsert(){ } 
    public virtual void beforeUpdate(){ } 
    public virtual void afterUpdate(){ } 
    public virtual void beforeDelete(){ } 
    public virtual void afterDelete(){ } 
    public virtual void afterUnDelete(){ }
    
    public void processTrigger(){ 
        if(Trigger.isBefore){ //entered before event 
            if(Trigger.isInsert){ 
                beforeInsert(); 
            }else if(Trigger.isUpdate){ 
                beforeUpdate();
             }else if(Trigger.isDelete){ 
                 beforeDelete();
             } 
        }
        else{ //entered after event 
            if(Trigger.isInsert){ 
                afterInsert(); 
            }else if(Trigger.isUpdate){ 
                afterUpdate();
            }else if(Trigger.isDelete){ 
                afterDelete();
            }else if(Trigger.isUndelete){ 
                afterUnDelete();
            }
        } 
    } 
}