public class CommandController {
    @Auraenabled
   public static boolean sendErrorEmail(string data)
   {
       system.debug(data);
       if(data!=null)
       {
           list<Messaging.singleEmailMessage> mails=new list<Messaging.SingleEmailMessage>();
           Messaging.singleEmailMessage mail=new Messaging.SingleEmailMessage();
           
           list<Messaging.EmailFileAttachment> lstefa = new list<Messaging.EmailFileAttachment>();
           
           Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
           
           efa.setfilename('ErrorFile.jpg');
           efa.setinline(true);
           efa.contenttype='image/jpg';
           Blob body = Encodingutil.base64Decode(data.substring(data.indexOf(',') + 1));
           efa.setbody(body);
           lstefa.add(efa);
           mail.setfileattachments(lstefa);
           mail.setToAddresses(new List<string>{'hiepllp@gmail.com'});
           mail.setSubject('Error in Application');
           mail.setPlainTextBody('Hello Admin, I am getting some error. Screen shot is attached.  Please check and suggest on it.');
           mails.add(mail);
           messaging.sendEmail(mails);
       }
       return true; 
   }
}