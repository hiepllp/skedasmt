public with sharing class SearchAny{

    public Boolean isAccountRecType { get; set; }
    public Boolean isContactRecType { get; set; }
    
    public String acctType { get; set; }
    public String contType { get; set; }

    public List<Account> accList{get;set;}
    public List<Contact> conList{get;set;}

    public String searchStr{get;set;}
   
    public SearchAny(){
    }
   
  public void doSearchAny(){
   Boolean isAccountRecType = False;
   Boolean isContactRecType = False;
    
    conList = New List<Contact>();
    accList = New List<Account>();
   
   //List<SObject> sObj = Database.Query('select id from Account');
   //system.debug(sObj[0].getSObjectType());
   
   //String sObjName = myId.getSObjectType().getDescribe().getName();
   
   if(searchStr.length() > 1){
       String searchStr1 = '*'+searchStr+'*';
       //String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Account (Id,Name,type, toLabel(Recordtype.Name) AccountRecType), Contact(name,email), Opportunity(name,StageName)';
       String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING Account (Id, Name, Type), Contact(Id, Name, Email)';
       List<List <sObject>> searchList = search.query(searchQuery);
       
       //List<Account> actLabel = (List<Account>)searchList[0].get('RecordTypeName');
       //System.debug('==Alias rectype label==' + actLabel);
       
       accList = ((List<Account>)searchList[0]);
       conList  = ((List<Contact>)searchList[1]);

       if(accList.size() == 0 && conList.size() == 0){
           apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'No accounts or contacts found..'));
           return;
       }
       
       if(accList.size() > 0){
               isAccountRecType = True;
               acctType = accList.getSObjectType().getDescribe().getName();
           }
       if(conList.size() > 0){
               isContactRecType = True;
               contType = conList.getSObjectType().getDescribe().getName();
           }
   }
   else{
           apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters to search..'));
   return;
   }
  }
}