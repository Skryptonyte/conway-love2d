

== Conway's Game of Life


I've made an implementation of Conway's game of life using Love2D and Lua.
Additionally, I am utilizing the knife library for timers and push.lua by Udely.
It is not a conventional game in the sense that it is a zero player game. The game operates on a board of some topology (such as a toroid) where each cell
has a binary state: dead or alive. This board generally evolves on the basis of some rules creating mathematically beautiful patterns.


Conway's game of life works on a set of rules as follows:


* A cell that has four neighbours or more (overpopulation) or 1 or fewer neighbours (underpopulation) die off.
* A cell that has two or three neighbours continue to live.
* A dead cell that has exactly three neighbours will become alive (reproduction).


This game is only a small subset of what the general field of cellular automata has to offer. In short terms,
cellular automata deals with the transition of cells through discrete time steps based on a set of rules. An interesting
property of this game is it is turing complete, meaning it can replicate all programs possible on a theoretical turing machine.


My implementation uses a simple toroidal space and iterates through each cell to determine the new state of the successor generation.
It is generally a somewhat naive approach that works efficiently for smaller boards like mine being 100x100. To make it less mundane, I've 
also added some jingles. The background ingame involves parallax scrolling of up to 10000 stars moving at different velocity to give an illusion of 
pop science space. This is a simple application of tweening ang timers and gives the game a nice aesthetic.
 You can pause the game to alter the grid using a mouse. Some hotkeys are also available to alter the rules of the game a bit.

Note: This is a reupload from last year to my personal repository. At the time of upload, this works with love2D 11.3.
 
== Bibliography

* push library: https://github.com/Ulydev/push
* knife library: https://github.com/airstruck/knife


