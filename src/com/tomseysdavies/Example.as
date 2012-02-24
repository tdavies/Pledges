/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 21/02/12
 * Time: 12:29
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies {
import com.tomseysdavies.loaders.FileLoader;
import com.tomseysdavies.pledge.IPledge;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;

[SWF(backgroundColor = "#FFFFFF", frameRate = "30", width = "400", height = "400")]
public class Example extends Sprite{

    public function Example() {
        var loader:FileLoader = new FileLoader();

        // loader.load("http://www.w3schools.com/xml/note.xml").then(successHandler,errorHandler,progressHandler);
        var pledge:IPledge =  loader.load("http://www.w3schools.com/xml/note.xml");
        pledge.success(successHandler);
        pledge.fail(errorHandler);
        pledge.progress(progressHandler);
    }

    private function successHandler(event:Event):void{
        var xml:XML = XML( event.target.data);
        trace("Success");
        trace(xml);
    }

    private function errorHandler(event:IOErrorEvent):void{
        trace("FAIL!");
    }

    private function progressHandler(event:ProgressEvent):void{
        trace("loaded:" + event.bytesLoaded + " of total: " + event.bytesTotal);
    }

}
}
