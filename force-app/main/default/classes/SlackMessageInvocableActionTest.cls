/**
* @author Tiaan Swart (tiaan@cloudinit.nz)
* @date 14 November 2017
* @description Test class for SlackMessageInvocableAction
*
* CHANGE LOG
**/
@isTest
private class SlackMessageInvocableActionTest {

    @isTest
    private static void sendNotificationTest() {

        // Init new messages list
        List<SlackMessageInvocableAction.SlackMessage> messages = new List<SlackMessageInvocableAction.SlackMessage>();

        // Build Message
        SlackMessageInvocableAction.SlackMessage  theMessage = new SlackMessageInvocableAction.SlackMessage();
        theMessage.webHook = 'https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXXXXXXXXXXX';
        theMessage.messageText = 'Hello world!';
        theMessage.channelHandle = '@channel';
        theMessage.recordId = '012300000012BYN';

        // Add the message to the list
        messages.add(theMessage);

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, new SlackWebhookMockHttpResp());

        // Send
        SlackMessageInvocableAction.sendNotification(messages);

    }
}