## 连接方式

* Access连接

  报文不带`tag` 标签，一般用于和`tag-unaware`(不支持802.1Q封装)设备相连，或者不需要区分不同VLAN成员时使用。 

* Trunk连接

  `PVID` 不带`tag` 标签转发，其他`VLAN` 报文都必须带`tag` 转发。

* Hybrid连接

  可以设置多个不带`tag` 的`VLAN`。



## 附录

###  参考资料

* 网络之路+第六期_交换

