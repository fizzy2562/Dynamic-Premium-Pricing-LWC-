/********************************************************************************************************************
 * @ClassName       : HTTPCalloutProcessor
 * @Description     : Class to make HTTP Callout and get response
********************************************************************************************************************/
public class HTTPCalloutProcessor {

    /** Method type name like GET, PUT, POST */
    String methodType {get; set;}
    
    /** End point URL to be called */
    String endPointUrl {get; set;}
    
    /** Request timeout */
    public Integer timeout {get; set;}
    
    /** Constructor */
    public HTTPCalloutProcessor(String url, String methodType){
        this.endPointUrl = url;
        this.methodType = methodType;
    }
    
    
    /**
     * Method to invoke HTTP Callout.
     */
    public HttpResponse processCallout(){
        
        Http http = new Http();
        HttpRequest request = getRequest();
        HttpResponse response = http.send(request);
    	return response;
    }
    
    
    public HttpRequest getRequest(){        
       
        HttpRequest request = new HttpRequest();
        request.setMethod(methodType);
        
        if(timeout != null){
            request.setTimeout(timeout);
        }
        
        request.setEndpoint(endPointUrl);
        return request;
    }    
    
}