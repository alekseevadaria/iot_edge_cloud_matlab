# iot_edge_cloud_matlab
This work contains different IoT offloading schemes. The IoT model represents the data processing on the IoT device itself; MEC and MCC are offloading in the edge and cloud, respectively.

The computing time and the energy consumption are simple equations in the local execution. 
Computing time is calculated as the task load to computing frequency ratio. 
There is no communication time as the task is executed locally; therefore, the response time consists only of the time spent on computing. 
Energy consumption is the response time multiplied by the CPU power of the device. 
There is no idle power consumption because we are counting only the time when the device is working.
Energy-consumption of Edge and Cloud is counting from the IoT side, i.e., how much energy the IoT device spent while the task was processing outside and transmitting to another node.
