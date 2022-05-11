public without sharing class SubmitCaseController{  
   public CaseWrapper newCase { get; set; }  
   public String SessionId{get; set;}  
   public List<Attachment> attachments {get;set;}  
   public Blob attBody{get;set;}  
   public String caseId {get;set;}  
   public boolean caseSubmitted {get; set;}  
   public SubmitCaseController() {  
     newCase = new CaseWrapper();  
     attachments = new List<Attachment>();  
     for(Integer i=0; i<10; i++){  
       attachments.add(new attachment());  
     }  
     caseSubmitted = false;  
   }   
   public PageReference submitCase(){  
     Case c = new Case();  
     if (newCase.FirstName == '' && newCase.LastName == '') {  
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error - Invalid contact Name'));  
       return null;  
     }   
     else {  
       //Create a SavePoint for rollback in case of any exception  
       SavePoint sp;  
       try {  
         sp = Database.setSavePoint();  
         // now look for an associated contact with the same email  
         Contact cnt;  
         for(Contact con : [SELECT Id, AccountId FROM Contact where Email = :newCase.Email order by LastModifiedDate LIMIT 1]){  
           cnt = con;  
         }  
         if (cnt != null)   
           c.ContactId = cnt.Id;  
         else{  
           Account acc = new Account(Name = newCase.Company);  
           insert acc;  
           cnt = new Contact(AccountId = acc.id, FirstName = newCase.FirstName, lastName = newCase.LastName, Email = newCase.Email, Phone = newCase.Phone);  
           insert cnt;  
           c.ContactId = cnt.Id;  
         }  
         if(cnt != null && cnt.AccountId != null)  
         c.AccountId = cnt.AccountId;    
         c.SuppliedEmail = newCase.Email;  
         c.SuppliedPhone = newCase.Phone;  
         c.SuppliedName = newCase.FirstName + ' ' + newCase.LastName;  
         c.Subject = newCase.Subject;  
         c.SuppliedCompany = newCase.Company;  
         c.Description = newCase.Description;  
         // Specify DML options to ensure the assignment rules not executed  
         Database.DMLOptions dmlOpts = new Database.DMLOptions();  
         dmlOpts = new Database.DMLOptions();  
         dmlOpts.assignmentRuleHeader.useDefaultRule = true;  
         c.setOptions(dmlOpts);    
         c.Origin = 'Web';  
         c.Status = 'New';   
         // Insert the case  
         //System.assert(false, c);  
         INSERT c;  
         //Upload Attachments   
         List<Attachment> recordsInserted = new List<Attachment>();  
         for(Attachment att : attachments){  
           if(att.Name != null && att.Name != ''){  
             att.parentId = c.id;  
             recordsInserted.add(att);    
           }  
         }  
         insert recordsInserted;   
         caseSubmitted = true;  
       } catch (Exception e) {  
         ApexPages.addMessages(e);  
         caseSubmitted = false;  
         //Rollback the changes  
         Database.rollback(sp);  
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error - '+e.getMessage() + '---- ' + e.getStackTraceString()));  
         //System.assert(false, e.getMessage() + '---- ' + e.getStackTraceString());  
       }  
       finally{  
         attachments = null;  
       }  
     }  
     return Page.CaseSubmited;   
   }  
   public Class CaseWrapper{  
     public String FirstName {get;set;}   
     public String LastName {get;set;}    
     public String Email {get;set;}  
     public String Phone {get;set;}  
     public String Subject {get;set;}  
     public String Company {get;set;}  
     public String Description {get;set;}  
     public List<Attachment> attachedDocs {get;set;}  
     public CaseWrapper(){  
       FirstName = '';    
       LastName = '';    
       Email = '';  
       Phone = '';
       Company = '';  
       Subject = '';  
       Description = '';  
     }  
   }  
 }