/**
* @author Tiaan Swart (tiaan@cloudinit.nz)
* @date 14 November 2017
* @description
*
* CHANGE LOG
**/
@isTest
global class SlackWebhookMockHttpResp implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        System.assertEquals('https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXXXXXXXXXXX', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(req.getBody());
        res.setStatusCode(200);

        return res;
    }

}