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
     * Pledge class for async calls.
     * @author Tom Davies
     */
    private var _resultData:Array;
    private var _errorData:Array;
    private var _progressData:Array;
    private var _successHandlers:Vector.<Function> = new Vector.<Function>();
    private var _errorHandlers:Vector.<Function> = new Vector.<Function>();
    private var _progressHandlers:Vector.<Function> = new Vector.<Function>();
    private var _eventListeners:Vector.<CacheEvent> = new Vector.<CacheEvent>();
    private var _state:PledgeState;

    public function Pledge() {
        _state =  PledgeState.PENDING;
    }

    public static function when(...pledges):IPledge{
         var pledge:Pledge = new Pledge();
         var successCount:int = 0;
         for(var i:int=0;i<pledges.length;i++){
             var subPledge:IPledge = pledges[i] as IPledge;
             subPledge.success(function():void {
                successCount ++;
                checkSuccess();
             });
             subPledge.fail(function():void {
                pledge.triggerFailure();
             });
         }
         function checkSuccess():void{
            if(successCount == pledges.length){
                pledge.triggerSuccess();
            }
         }
        return pledge;
    }

    public function then(successHandler:Function = null,failureHandler:Function= null,progressHandler:Function=null):IPledge {
        if(successHandler){
            success(successHandler);
        }
        if(failureHandler){
            fail(failureHandler);
        }
        if(progressHandler){
            progress(progressHandler);
        }
        return this;
    }

    public function success(successHandler:Function):IPledge {
        if(_resultData){
            successHandler.apply(this,_resultData);
        }
        if(_successHandlers){
            _successHandlers.push(successHandler);  
        }
        return this;
    }

    public function fail(failureHandler:Function):IPledge {
        if(_errorData){
            failureHandler.apply(this,_errorData);
        }
        if(_errorHandlers){
            _errorHandlers.push(failureHandler);
        }
        return this;
    }

    public function progress(progressHandler:Function):IPledge {
        if(_progressData){
            progressHandler.apply(this,_progressData);
        }
        if(_progressHandlers){
            _progressHandlers.push(progressHandler);
        }
        return this;
    }

    public function triggerSuccess(...payload):void {
        _state =  PledgeState.FULFILLED;
        _resultData = payload;
        for each(var handler:Function in  _successHandlers){
            handler.apply(this,payload)
        }
        dispose();
    }


    public function triggerFailure(...payload):void {
        _state =  PledgeState.FAILED;
        _errorData = payload;
        for each(var handler:Function in  _errorHandlers){
            handler.apply(this,payload)
        }
        dispose();
    }

    public function triggerProgress(...payload):void {
        _progressData = payload;
        for each(var handler:Function in  _progressHandlers){
            handler.apply(this,payload)
        }
    }


    public function mapSuccessEvent(target:IEventDispatcher, eventType:String):Pledge {
        _eventListeners.push(new CacheEvent(target,eventType,successEventHandler));
        return this;
    }

    public function mapFailureEvent(target:IEventDispatcher, eventType:String):Pledge {
        _eventListeners.push(new CacheEvent(target,eventType,errorEventHandler));
        return this;
    }

    public function mapProgressEvent(target:IEventDispatcher, eventType:String):Pledge {
        _eventListeners.push(new CacheEvent(target,eventType,notifyEventHandler));
        return this;
    }

    public function get state():PledgeState{
         return _state;
    }

    public function dispose():void {
        _errorHandlers = null;
        _successHandlers = null;
        _progressHandlers = null;
        for each(var cachedEvent:CacheEvent in _eventListeners){
            cachedEvent.dispose();
        }
        _eventListeners = null;
    }

    private function successEventHandler(e:Event):void{
        triggerSuccess(e);
        dispose();
    }

    private function errorEventHandler(e:Event):void{
        triggerFailure(e);
        dispose();
    }

    private function notifyEventHandler(e:Event):void{
        triggerProgress(e);
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


