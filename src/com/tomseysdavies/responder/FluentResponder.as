/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 19:48
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.responder {
import org.osflash.signals.Signal;

public class FluentResponder implements IFluentResponder {
    /**
     * Fluent responder class for async service calls
     * @author Tom Davies
     */
    private var _successSignal:Signal;
    private var _errorSignal:Signal;
    private var successClass:Class;
    private var errorClass:Class;


    public function FluentResponder(successClass:Class = null, errorClass:Class = null) {
        if (successClass != null) {
            _successSignal = new Signal(successClass);
            this.successClass = successClass;
        }
        else {
            _successSignal = new Signal();
        }

        if (errorClass != null) {
            _errorSignal = new Signal(errorClass);
            this.errorClass = errorClass;
        }
        else {
            _errorSignal = new Signal();
        }
    }

    public function addSuccessHandler(handler:Function):IFluentResponder {
        this._successSignal.add(handler);
        return this;
    }

    public function addErrorHandler(handler:Function):IFluentResponder {
        this._errorSignal.add(handler);
        return this;
    }

    public function triggerSuccess(payload:Object = null):void {
        if (this.successClass && payload is this.successClass) {
            this._successSignal.dispatch(payload);
        }
        else if (!this.successClass && payload == null) {
            this._successSignal.dispatch();
        }
        else {
            throw new Error("Response payload " + payload + " does not match " + successClass);
        }
        dispose();
    }

    public function triggerError(payload:Object = null):void {
        if (this.errorClass && payload is this.errorClass) {
            this._errorSignal.dispatch(payload);
        }
        else if (!this.errorClass && payload == null) {
            this._errorSignal.dispatch();
        }
        else {
            throw new Error("Error payload " + payload + " does not match " + errorClass);
        }
        dispose();
    }

    public function dispose():void {
        _successSignal.removeAll();
        _errorSignal.removeAll();
    }

}
}
