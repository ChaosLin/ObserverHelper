# ObserverHelper
KVO的帮助类，用来解耦，监听者模式本来就是为了让监听者与被监听者互相不用关心而设计出来的，它们应该被设计成互相不知道（除非在建立监听的瞬间）。这是通过ARC的方式去建立一个联系，每一个监听者与被监听者都能找到帮助类，但互相不知道。然后不管是监听者还是被监听者在你dealloc的瞬间去进行“移除所有对自己的监听”以及“移除所有自己监听的对象”的操作。在逻辑上就解耦了。