/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 20/02/12
 * Time: 19:54
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.pledge {
public interface IPledge {

    function then(successHandler:Function = null,failureHandler:Function= null,progressHandler:Function=null):IPledge;
    function success(successHandler:Function):IPledge;
    function fail(failureHandler:Function):IPledge;
    function progress(progressHandler:Function):IPledge;

}
}
