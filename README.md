# verilog-VGA
an VGA which 640x480@60Hz

属性：
1、作为一个VGA接口使用
2、该接口只是点亮屏幕，具体的RGB需要单独输入
3、为了作为参考以及获得同步时钟，增加了addr_time引脚和pll_clk引脚
4、频率50MHz
5、代码没有下到真实板子上进行验证，只做了仿真，可能显示时会有偏差，需要根据实际情况调参

方法：
1、clk：50MHz时钟引脚
2、rst：复位
3、en：使能端，不使能时和rst一样是复位端
4、pll_clk：输出的同步时钟
5、VSync：场同步信号
6、HSync：行同步信号
7、h_addr：行显示时间
8、v_addr：场显示时间
