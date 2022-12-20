# 8-bit-Multiplayer
8-bit Multiplayer using radix 16 algorithm, built-In Instruction set (VHDL)
#
#
The code defines an entity called Radix16, which has inputs clk, rst, start, a, b and outputs res, done. The entity is a 16-bit radix-4 modified booth multiplier, which is a type of hardware circuit that performs multiplication of two 16-bit numbers.

The entity has an architecture called arc_Radix, which describes the behavior of the Radix16 entity. The architecture includes a process that is sensitive to changes in the clk and rst signals. The process includes a finite state machine (FSM) with states s0 and s1, and variables and signals used to store intermediate values and control the behavior of the FSM.

The FSM has two states: s0 and s1. In state s0, if the start input is '1', the FSM transitions to state s1 and sets the sh_acc and ld_clr signals to '0' and '1', respectively. In state s1, if the end_op variable is false (i.e., the operation is not finished), the sh_acc signal is set to '1', otherwise the FSM transitions back to state s0 and sets the done_v signal to '1'.

The process also includes a case statement that computes the product of the a and b inputs based on the current value of the rb input and the carry signal. The product is stored in the p signal and the next carry signal is computed based on the result. The res and done outputs are then assigned the values of the p and done_v signals, respectively.

