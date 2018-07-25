/*******************************************************************************
	> File Name: 
	> Author: lroyd
	> Mail: htzhangxmu@163.com
	> Created Time: 
 *******************************************************************************/
#include <jni.h>
#include <android/log.h>
#include <pthread.h>

/*******************************************************************************
*		define log
********************************************************************************/
#define LOG_TAG  "native"
#define LOG_D(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
#define LOG_E(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

#define	USER_INTERFACE	
/*******************************************************************************
*		define JAVA NAME variable
********************************************************************************/
#define	JAVA_CLASS_NAME		("T0")

/*******************************************************************************
*		define std variable
********************************************************************************/
static JavaVM			*g_sJavaVMIN;
static jobject			g_tJniCallbacksObj;
static pthread_key_t	g_tJniThrEnv;

/*******************************************************************************
*		define call back function list
********************************************************************************/
#define	METHOD_FUNC_CALLBCK_NAME_1		("onEventCallbck")
#define	METHOD_FUNC_CALLBCK_SIGN_1		("(ILjava/lang/String;)V")
static jmethodID method_funcCallback_1;


/*******************************************************************************
* Name: 
* Descriptions:
* Parameter:	
* Return:	
* *****************************************************************************/
JNIEnv* checkCallbackThread(void)
{
    JNIEnv *pEnv;
    if ((pEnv = (JNIEnv *)pthread_getspecific(g_tJniThrEnv)) == NULL)
	{
        if((*g_sJavaVMIN)->AttachCurrentThread (g_sJavaVMIN, &pEnv, NULL)!= JNI_OK)
		{
            LOG_E("AttachCurrentThread failed.");
        }
        pthread_setspecific (g_tJniThrEnv, pEnv);
    }
    return pEnv;
}

static int app_callback(int _iEvt, int _iLen, char *_pMessage)
{
	int iRet = -1;
	JNIEnv *pEnv = NULL;

	LOG_D("app_callback: _iEvt = %d, _iLen = %d, _pMessage = %s", _iEvt, _iLen, _pMessage);

	if(pEnv = checkCallbackThread())
	{
		jstring jMsg = (*pEnv)->NewStringUTF(pEnv,_pMessage);
		(*pEnv)->CallVoidMethod(pEnv, g_tJniCallbacksObj, method_funcCallback_1, _iEvt, jMsg);
		(*pEnv)->DeleteLocalRef (pEnv, jMsg);
		iRet = 0;		
	}
	
	return iRet;
}

static void detach_current_thread (void *_pEnv) 
{
    LOG_D("Detaching thread");
    if((*g_sJavaVMIN)->DetachCurrentThread(g_sJavaVMIN) != JNI_OK)
	{
        LOG_E("DetachCurrentThread failed.");
    }
}


/*******************************************************************************
* Name: 
* Descriptions:
* Parameter:	
* Return:	
* *****************************************************************************/
JNIEXPORT void JNICALL T1(JNIEnv *_pEnv, jclass _jClazz)
{
	jclass jClazz = (*_pEnv)->FindClass(_pEnv, JAVA_CLASS_NAME);	

	/*********************** #BEGINE get Java callbacks list  ******************/
	method_funcCallback_1 = (*_pEnv)->GetMethodID(_pEnv, jClazz, METHOD_FUNC_CALLBCK_NAME_1, METHOD_FUNC_CALLBCK_SIGN_1); 
	
	
	
	/************************* #END ********************************************/
	pthread_key_create (&g_tJniThrEnv, detach_current_thread);
}

/*******************************************************************************
* Name: 
* Descriptions:
* Parameter:	
* Return:	
* *****************************************************************************/
JNIEXPORT jint JNICALL T2(JNIEnv *_pEnv, jobject _jObject)
{
	(*_pEnv)->GetJavaVM(_pEnv, &g_sJavaVMIN);
	g_tJniCallbacksObj = (*_pEnv)->NewGlobalRef(_pEnv, _jObject);	
#ifdef USER_INTERFACE	
	app_callback(1,2,"init-c1");	//TEST 
	
	
#endif
	return 0;
}

/*******************************************************************************
* Name: 
* Descriptions:
* Parameter:	
* Return:	
* *****************************************************************************/
JNIEXPORT jint JNICALL T3(JNIEnv *_pEnv, jobject _jObject)
{
#ifdef USER_INTERFACE	
	app_callback(3,4,"deinit");	//TEST 
	
	
#endif
	(*_pEnv)->DeleteGlobalRef(_pEnv, g_tJniCallbacksObj);	
	return 0;
}

/*******************************************************************************
* Name: 
* Descriptions:
* Parameter:	
* Return:	
* *****************************************************************************/
JNIEXPORT jint JNICALL T4(JNIEnv *_pEnv, jobject _jObject)
{
#ifdef USER_INTERFACE	
	app_callback(5,6,"test");	//TEST 
	
	
#endif
	return 0;
}

