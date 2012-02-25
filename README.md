#Pledges

a simple as3 implementation of JS Promises. A universal way of dealing with asynchronous calls.

>   var pledge:IPledge =  loader.load("http://www.w3schools.com/xml/note.xml");
>   pledge.done(successHandler);
>   pledge.fail(errorHandler);
>   pledge.progress(progressHandler);

or

>   loader.load("http://www.w3schools.com/xml/note.xml").then(successHandler,errorHandler,progressHandler);

making a pledge supports native event mapping

>   public function load(url:String):IPledge{
>       var responder:Pledge = new Pledge();
>       var request:URLRequest = new URLRequest(url);
>       var loader:URLLoader = new URLLoader();
>       responder.mapSuccessEvent(loader,Event.COMPLETE);
>       responder.mapFailureEvent(loader,IOErrorEvent.IO_ERROR);
>       responder.mapProgressEvent(loader,ProgressEvent.PROGRESS);
>       loader.load(request);
>       return responder;
>   }

