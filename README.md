Code Challenge

Create a class "Max" that exposes the following characteristics:

* A public method called "push" that receives an unsigned integer number as
parameter. This method should store the numbers internally while keeping the 
order they were pushed. We refer to this as the stack.

* A public method called "pop". When called it returns the integer that was last
 pushed to the stack or Nil if the stack is empty. The returned value is removed
 from the stack.

* A public method called "max" which returns the highest number of the numbers 
in the stack.

 
The class will receive many "pushed" numbers (let's say 10 million). The number 
of calls to "max" will be by magnitude greater than "push" or "pop" calls.  
Try to make „max" as fast as possible. 

 
Create a class "Mean" which extends "Max". 

It should expose a method called "mean" which should return the mean value of 
the numbers in the stack. Again, make it as fast as possible.

Bonus Points: Your class now receives 10 trillion entries so the data won't fit 
into memory. Talk a bit about how you would persist the data in a way that 
allows fast loading when recreating the class. How would you keep the 
functionality of the class when you don't have access to all data any more.


See [devlog](devlog.md) for implementation steps and thoughts from dev
