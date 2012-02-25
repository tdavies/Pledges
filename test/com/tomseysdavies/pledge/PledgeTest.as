/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 20:03
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.pledge {
import com.tomseysdavies.pledge.Pledge;

import de.betriebsraum.utils.tests.AsyncUtil;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;

public class PledgeTest {

    private var _call:MockCall;


    [Before]
    public function setup():void {
        _call= new MockCall();
    }


    [Test(async)]
    public function testTriggerSuccess():void {
        var asyncHandler:Function = AsyncUtil.asyncHandler(this,verifySuccess,null,250);
        _call.executeSuccess().success(asyncHandler);

    }

    protected function verifySuccess(value:int):void{

    }

    [Test(async)]
    public function testTriggerError():void {
        var asyncHandler:Function = AsyncUtil.asyncHandler(this,verifyFail,null,250);
        _call.executeFail().fail(asyncHandler);
    }

    private function verifyFail(value:Boolean):void{

    }

    [Test]
    public function testAutoDispose():void {
        var responder:Pledge = new Pledge();
        var success:Boolean;
        responder.success(function (val:int):void{
            success = true;
        });
        responder.triggerSuccess(2);
        success = false;
        responder.triggerSuccess(2);
        assertFalse(success);
    }

    [Test]
    public function testCanNotSucceedAfterFailed():void {
        var responder:Pledge = new Pledge();
        var success:Boolean;
        responder.success(function (val:int):void{
            success = true;
        });
        responder.triggerFailure();
        success = false;
        responder.triggerSuccess();
        assertFalse(success);
    }

    [Test]
    public function testCanNotFailAfterSucceed():void {
        var responder:Pledge = new Pledge();
        var failed:Boolean;
        responder.fail(function (val:int):void{
            failed = true;
        });
        responder.triggerSuccess()
        failed = false;
        responder.triggerFailure()
        assertFalse(failed);
    }

    [Test]
    public function testCallsSuccessHandlerAfterFulfilled():void {
        var responder:Pledge = new Pledge();
        var success:Boolean;
        responder.triggerSuccess(2);
        responder.success(function (val:int):void{
            success = (val == 2);
        });
        assertTrue(success);
    }

    [Test]
    public function testCallsErrorsHandlerAfterFailed():void {
        var responder:Pledge = new Pledge();
        var result:Boolean;
        responder.triggerFailure(2);
        responder.fail(function (val:int):void{
            result = (val == 2);
        });
        assertTrue(result);
    }

    [Test(expects="Error")]
    public function testWrongType():void {
        var responder:Pledge = new Pledge();
        var success:Boolean;
        responder.success(function (val:Object):void{
            success = true;
        });
        responder.triggerSuccess(2);
        assertFalse(success);
    }

    [Test]
    public function testDispose():void {
        var responder:Pledge = new Pledge();
        var success:Boolean;
        responder.success(function (val:int):void{
            success = true;
        });
        responder.dispose();
        responder.triggerSuccess();
        assertFalse(success);
    }

    [Test]
    public function testIsInPendingStateBeforeTriggered():void {
        var responder:Pledge = new Pledge();
        assertTrue(responder.state == PledgeState.PENDING);
    }

    [Test]
    public function testIsInFulfilledStateAfterSuccessTriggered():void {
        var responder:Pledge = new Pledge();
        responder.triggerSuccess();
        assertTrue(responder.state == PledgeState.FULFILLED);
    }

    [Test]
    public function testIsInFailedStateAfterFailureTriggered():void {
        var responder:Pledge = new Pledge();
        responder.triggerFailure()
        assertTrue(responder.state == PledgeState.FAILED);
    }

    [Test]
    public function testHandlesAreCalledInOrder():void {
        var responder:Pledge = new Pledge();
        var res:Boolean;
        responder.success(function ():void{
            res = true;
        });
        responder.success(function ():void{
            assertTrue(res);
        });
        responder.triggerSuccess();
    }

    [Test]
    public function testWhenFiredAfterBothSucceed():void {
        var pledge1:Pledge = new Pledge();
        var pledge2:Pledge = new Pledge();
        var res:Boolean;
        Pledge.when(pledge1,pledge2).success(function ():void{
            res = true;
        })
        pledge1.triggerSuccess();
        pledge2.triggerSuccess();
        assertTrue(res);
    }

    [Test]
    public function testWhenNotFiredAfterOneFails():void {
        var pledge1:Pledge = new Pledge();
        var pledge2:Pledge = new Pledge();
        var res:Boolean;
        Pledge.when(pledge1,pledge2).success(function ():void{
            res = true;
        })
        pledge1.triggerSuccess();
        pledge2.triggerFailure();
        assertFalse(res);
    }

}
}
