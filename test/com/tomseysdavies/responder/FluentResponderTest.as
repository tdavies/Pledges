/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 20:03
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.responder {
import de.betriebsraum.utils.tests.AsyncUtil;
import org.flexunit.asserts.assertFalse;

public class FluentResponderTest {

    private var _call:MockCall;


    [Before]
    public function setup():void {
        _call= new MockCall();
    }


    [Test(async)]
    public function testTriggerSuccess():void {
        var asyncHandler:Function = AsyncUtil.asyncHandler(this,verifySuccess,null,250);
        _call.executeSuccess().addSuccessHandler(asyncHandler);

    }

    protected function verifySuccess(value:int):void{

    }

    [Test(async)]
    public function testTriggerError():void {
        var asyncHandler:Function = AsyncUtil.asyncHandler(this,verifyFail,null,250);
        _call.executeFail().addErrorHandler(asyncHandler);
    }

    private function verifyFail(value:Boolean):void{

    }


    [Test]
    public function testAutoDispose():void {
        var responder:FluentResponder = new  FluentResponder(int,int);
        var success:Boolean;
        responder.addSuccessHandler(function (val:int):void{
            success = true;
        });
        responder.triggerSuccess(2);
        success = false;
        responder.triggerSuccess(2);
        assertFalse(success);
    }

    [Test(expects="Error")]
    public function testWrongType():void {
        var responder:FluentResponder = new  FluentResponder(int,int);
        var success:Boolean;
        responder.addSuccessHandler(function (val:Boolean):void{
            success = true;
        });
        responder.triggerSuccess(Boolean);
        assertFalse(success);
    }

    [Test]
    public function testDispose():void {
        var responder:FluentResponder = new  FluentResponder();
        var success:Boolean;
        responder.addSuccessHandler(function (val:int):void{
            success = true;
        });
        responder.dispose();
        responder.triggerSuccess();
        assertFalse(success);
    }

}
}
