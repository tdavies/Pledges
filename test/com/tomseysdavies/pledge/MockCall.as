/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 20:44
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.pledge {
import com.tomseysdavies.pledge.IPledge;
import com.tomseysdavies.pledge.Pledge;

import flash.events.TimerEvent;
import flash.utils.Timer;

public class MockCall {

    public function MockCall() {
    }

    public function executeSuccess():IPledge {
        var responder:Pledge = new Pledge();
        var timer:Timer = new Timer(50, 1);
        responder.mapResolveEvent(timer,TimerEvent.TIMER_COMPLETE);
        timer.start();
        return responder;
    }

    public function executeFail():IPledge {
        var responder:Pledge = new Pledge();
        var timer:Timer = new Timer(50, 1);
        responder.mapRejectEvent(timer,TimerEvent.TIMER_COMPLETE);
        timer.start();
        return responder;
    }
}
}
