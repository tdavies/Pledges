/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 19:48
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.pledge {
import flash.events.Event;
import flash.events.IEventDispatcher;

public class Pledge implements IPledge {

    /**
     * Fluent pledge class for async service calls
     * @author Tom Davies
     */
    private const _successHandlers:Vector.<Function> = new Vector.<Function>();
    private const _errorHandlers:Vector.<Function> = new Vector.<Function>();
    private const _progressHandlers:Vector.<Function> = new Vector.<Function>();
    private const _eventListeners:Vector.<CacheEvent> = new Vector.<CacheEvent>();

    public function Pledge() {

    }

    public function then(successHandler:Function = null,failureHandler:Function= null,progressHandler:Function=null):IPledge {
        if(successHandler){
            done(successHandler);
        }
        if(failureHandler){
            fail(failureHandler);
        }
        if(progressHandler){
            progress(progressHandler);
        }
        return this;
    }

    public function done(successHandler:Function):IPledge {
        _successHandlers.push(successHandler);
        return this;
    }

    public function fail(failureHandler:Function):IPledge {
        _errorHandlers.push(failureHandler);
        return this;
    }

    public function progress(progressHandler:Function):IPledge {
        _progressHandlers.push(progressHandler);
        return this;
    }

    public function resolve(...payload):void {
        for each(var handler:Function in  _successHandlers){
            handler.apply(this,payload)
        }
        dispose();
    }

    public function reject(...payload):void {
        for each(var handler:Function in  _errorHandlers){
            handler.apply(this,payload)
        }
        dispose();
    }

    public function notify(...payload):void {
        for each(var handler:Function in  _progressHandlers){
            handler.apply(this,payload)
        }
    }

    public function mapResolveEvent(target:IEventDispatcher, eventType:String):void {
        _eventListeners.push(new CacheEvent(target,eventType,successEventHandler));
    }

    public function mapRejectEvent(target:IEventDispatcher, eventType:String):void {
        _eventListeners.push(new CacheEvent(target,eventType,errorEventHandler));
    }

    public function mapNotifyEvent(target:IEventDispatcher, eventType:String):void {
        _eventListeners.push(new CacheEvent(target,eventType,notifyEventHandler));
    }

    private function successEventHandler(e:Event):void{
        resolve(e);
        dispose();
    }

    private function errorEventHandler(e:Event):void{
        reject(e);
        dispose();
    }

    private function notifyEventHandler(e:Event):void{
        notify(e);
    }

    public function dispose():void {
        _errorHandlers.length = 0;
        _successHandlers.length = 0;
        _progressHandlers.length = 0;
        for each(var cachedEvent:CacheEvent in _eventListeners){
            cachedEvent.dispose();
        }
    }

}
}

import flash.events.IEventDispatcher;

internal class CacheEvent{

    private var _target:IEventDispatcher;
    private var _eventType:String;
    private var _handler:Function;

    public function CacheEvent(target:IEventDispatcher,eventType:String,handler:Function):void{
        _target = target;
        _eventType = eventType;
        _handler = handler;
        _target.addEventListener(_eventType,_handler);
    }

    public function dispose():void{
        _target.removeEventListener(_eventType,_handler);
    }

}


