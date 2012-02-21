/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 21/02/12
 * Time: 12:29
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies {
import com.tomseysdavies.loaders.FluentXMLLoader;

import flash.display.Sprite;
import flash.events.IOErrorEvent;

[SWF(backgroundColor = "#FFFFFF", frameRate = "30", width = "400", height = "400")]
public class Example extends Sprite{

    public function Example() {
        var xmlLoader:FluentXMLLoader = new FluentXMLLoader();
        xmlLoader.load("http://www.w3schools.com/xml/note.xml").addSuccessHandler(successHandler).addErrorHandler(errorHandler);
    }

    private function successHandler(xml:XML):void{
         trace(xml);
    }

    private function errorHandler(error:IOErrorEvent):void{
        trace("FAIL!");
    }
}
}
