package T1;

import android.util.Log;

/**
 * Created by lroyd on 2018/7/23.
 */

public class T0 {
    private native static void classInitNative();
    public native int devEnable();
    public native int devDisable();
    public native int devContral();

    public void onEventCallbck(int cmd, String msg){
        Log.d("T0","cmd = "+cmd + " msg = "+msg);
    }

    public T0(){
        classInitNative();
    }

    static {
        System.loadLibrary("T2");
    }
}
