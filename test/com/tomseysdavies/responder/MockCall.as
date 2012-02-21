/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 20:44
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.responder {
import flash.events.TimerEvent;
import flash.utils.Timer;

import org.osflash.signals.natives.NativeSignal;

public class MockCall {

    public function MockCall() {
    }

    public function executeSuccess():IFluentResponder {
        var responder:FluentResponder = new FluentResponder(int,Boolean);
        var timer:Timer = new Timer(50, 1);
        var nativeSignal:NativeSignal = new NativeSignal(timer,TimerEvent.TIMER_COMPLETE,TimerEvent);
        nativeSignal.addOnce(
            function (e:TimerEvent):void{
                responder.triggerSuccess(2);
            }
        )
        timer.start();
        return responder;
    }

    public function executeFail():IFluentResponder {
        var responder:FluentResponder = new FluentResponder(int,Boolean);
        var timer:Timer = new Timer(50, 1);
        var nativeSignal:NativeSignal = new NativeSignal(timer,TimerEvent.TIMER_COMPLETE,TimerEvent);
        nativeSignal.addOnce(
                function ():void{
                    responder.triggerError(true);
                }
        )
        timer.start();
        return responder;
    }
}
}
