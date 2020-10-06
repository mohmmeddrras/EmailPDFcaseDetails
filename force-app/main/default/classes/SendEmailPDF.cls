public class SendEmailPDF {
    //this method gets called from the process builder 
        @InvocableMethod
    public static void sendEmail(List<case> cs){
        string caseId= cs[0].id;
        string Emailadd=cs[0].ContactEmail;
         Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        //pass case id to VF page
        PageReference pageReference2 = new PageReference('/apex/casePDF?Id='+caseId);
        //call the @futurefunction to send my email
        fetchContentDataFromPage(pageReference2.getUrl(),Emailadd);
     
           
    }
    
    @Future(Callout=true)
public static void fetchContentDataFromPage(String pageURL, String emailadd){
 
     Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    attach.setContentType('application/pdf');
    attach.setFileName('CaseDetails.pdf');
    attach.setInline(false);
    //get the pdf and add it as an attachment
    attach.setBody(new PageReference(pageURL).getContent());
    email.setSubject('CaseDetails');
    List<String> lStrings = new List<String>();
    lStrings.add(emailadd);
    email.setToAddresses(lStrings);
    email.setPlainTextBody('you can check your case details in the attached pdf file');
    email.setFileAttachments(new Messaging.EmailFileAttachment[]{
            attach
    });
    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
            email
    });
}

}