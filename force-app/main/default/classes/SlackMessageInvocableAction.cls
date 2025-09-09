/**
* @author Tiaan Swart (tiaan@cloudinit.nz)
* @date 14 November 2017
* @description Invocable action to create Slack Messages via Process Builder
*
* CHANGE LOG
**/
global with sharing class SlackMessageInvocableAction {

    /**
    *   @author Tiaan Swart (tiaan@cloudinit.nz)
    *   @description Called from Process Builder. Takes the Request Id parameters to create Slack Messages
    **/
    @InvocableMethod(label='Send Slack Notification' description='Sends a Slack Message to the desired channel.')
    global static void sendNotification(List<SlackMessage> messages) {

        // Iterate over the messges to create
        for (SlackMessage message :messages) {

            // Send message
            processSlackCallout(message.webHook, message.recordId, message.messageText, message.channelHandle);
        }

    }

    /**
    *   @author Tiaan Swart (tiaan@cloudinit.nz)
    *   @description Actual future method for posting to Slack
    **/
    @Future(callout=true)
    global static void processSlackCallout(String webHook, String recordId, String messageText, String channelHandle)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(webHook);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(120000);

        // Message new line fix
        messageText = messageText.replace('\\n','\n');

        // Extend message to add details link
        if (String.isNotBlank(recordId)) {
            messageText += String.format(
                '\n<{0}/{1}|Click here> for details!',
                new List<String>{
                        Url.getSalesforceBaseUrl().toExternalForm(),
                        recordId
                }
            );
        }

        Map<String, String> jsonMessage = new Map<String, String> {
            'text' => messageText
        };

        // Optional channel to post message to
        if (String.isNotBlank(channelHandle)) {
            jsonMessage.put('channel', channelHandle);
        }

        req.setBody( JSON.serialize( jsonMessage ) );

        HTTPResponse res = new Http().send(req);
    }

    /**
    *   @author Tiaan Swart (tiaan@cloudinit.nz)
    *   @description Wrapper class to hold all the variables needed to send a slack notification
    **/
    global class SlackMessage {

        // The Slack Endpoint to post to (https://api.slack.com/incoming-webhooks)
        @InvocableVariable(required=true label='Slack Webhook' description='The webhook to post the notification to.')
        global String webHook;

        // Notification text
        @InvocableVariable(required=true label='Slack Message Text' description='The text to display in the notification.')
        global String messageText;

        // The parent record Id
        @InvocableVariable(required=false label='Request Record Id' description='The request that started the process. (OPTIONAL)')
        global Id recordId;

        // The channel handle to post the notification to
        @InvocableVariable(required=false label='Slack Channel Handle' description='The channel where the notification will be posted. Leave blank for default webhook setup. (OPTIONAL)')
        global String channelHandle;
    }

}