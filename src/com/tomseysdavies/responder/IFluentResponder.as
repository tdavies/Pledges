/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 19:54
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.responder {
public interface IFluentResponder {
    function addSuccessHandler(handler:Function):IFluentResponder;
    function addErrorHandler(handler:Function):IFluentResponder;
}
}
