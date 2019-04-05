REBELLE Code Challenge
Author: Lennart Gerson

#################################################################
The Code Challenge (quoted from mail):
"
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
"
#########################################################################

Some notes and thoughts about the code challenge and its results:

- Max.max and Mean.mean are supposed to be called "by magnitude greater" more times
than Max.push and Max.pop, so performance of max and mean are critical. My first
thought was to benchmark various ways of calculating max and mean and choosing
the fastest one. But while implementing, it felt 'wrong' and I decided on another
approach: Move the work balance into another method which is less times called
and still maintain data's validity

- max and mean now try to read a pre-stored value, which should be the case in
about 80-90% calls when using a external data source. The remaining 10-20% are 
caused by database processes and delays, in which the pre-stored value is invalid.
In this case we have to either wait for them to finish (which is quite tricky to
do, e.g. with Threads, still the long-term desired solution) or calculate the 
numbers on demand expensively (does this word even exist?). I think this will
still be faster than my first approach.

- I used class inheritence to implement "Class "Mean" which extends "Max"". If 
it had been Modules, I could`ve used 'extend' and 'include'. In this case I used
what first came to mind.

- Data Storage: I decided for a SQL storage via ActiveRecord for this challenge,
although it seems a bit overkill just for this. You could take a
lightweight CSV or YAML filestorage for this task. So why SQL? First of all, im 
quite more confortable around a running database and second: you don't throw
those numbers around randomly, they probably have meaning and are associated 
with each other (maybe ID keys) and you want to process those data. A lot easier 
with a database at hand

- While challenge.rb is the practical part and can be executed via irb,
challenge_big_data is theoretical and cant be executed without a rails environment.

- I put all classes into one file, because i'm too lazy to load all files into
the irb call each time. In a full rails project those would be an own file each,
of course

- In a bigger scope you would also need timestamps, check if there are new 
entries before calculating numbers and update the stack, to guarantee up-to-date
data. If up-to-data data is not primarly important, you could cache the DB-request
for an acceptable durability

- challenge_big_data.rb got a little messy because time was scarce and I 
discovered one flaw in its logic after the other. I was in the danger zone 
of refactoring everything, then I remembered this was just a simple presentation
and not an actual feature, so I stopped there. So a pagination of DB-results and
processing this data is missing right now, leaving a frozen work-in-progress state.

- I worked about 6 hours (+ aprox. 1-2 hours documentation/comments/review) for these 
results. Some things were new and had to be researched. So there is a quite low 
time/code ratio. Well, you can also spend an entire day on 2 lines of code...