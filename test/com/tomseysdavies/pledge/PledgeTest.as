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

}
}
