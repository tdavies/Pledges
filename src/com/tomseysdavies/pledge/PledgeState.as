/**
 * Created by IntelliJ IDEA.
 * User: tom
 * Date: 25/02/12
 * Time: 11:52
 * To change this template use File | Settings | File Templates.
 */
package com.tomseysdavies.pledge {

public class PledgeState {
    
    public static const FULFILLED:PledgeState = new PledgeState();
    public static const FAILED:PledgeState = new PledgeState();
    public static const PENDING:PledgeState = new PledgeState();
    
    public function PledgeState() {
    }
}
}
