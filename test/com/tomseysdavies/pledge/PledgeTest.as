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

public class PledgeTest {

    private var _call:MockCall;


    [Before]
    public function setup():void {
        _call= new MockCall();
    }


    [Test(async)]
    public function testTriggerSuccess():void {
        var asyncHandler:Function = AsyncUtil.asyncHandler(this,verifySuccess,null,250);
        _call.executeSuccess().done(asyncHandler);

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
        responder.done(function (val:int):void{
            success = true;
        });
        responder.resolve(2);
        success = false;
        responder.resolve(2);
        assertFalse(success);
    }

    [Test(expects="Error")]
    public function testWrongType():void {
        var responder:Pledge = new Pledge();
        var success:Boolean;
        responder.done(function (val:Object):void{
            success = true;
        });
        responder.resolve(2);
        assertFalse(success);
    }

    [Test]
    public function testDispose():void {
        var responder:Pledge = new Pledge();
        var success:Boolean;
        responder.done(function (val:int):void{
            success = true;
        });
        responder.dispose();
        responder.resolve();
        assertFalse(success);
    }

}
}
