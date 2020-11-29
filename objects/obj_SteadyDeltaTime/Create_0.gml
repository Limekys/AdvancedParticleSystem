/// @description  README / SETUP
/*
    Stephen Loney
    Contact: stephen@8bitwarrior.com
    Twitter: @8bitwarrior
	
	Be sure to check out some of my other assets!
        - TweenGMS
        - ScheduleGMS
        - DispatchGMS
		- Arg Ext
    
    [Steady Delta Time]
        Version 1.1.0
    
    [Setup]
        Create a single instance of obj_SteadyDeltaTime, ONLY ONCE, at the start of your game.
        By default, obj_SteadyDeltaTime is persistent.
        Avoid accidentally destroying or deactivating instances of obj_SteadyDeltaTime.
    
    [Delta Timing]
        Delta timing allows you to adjust values at a consistent rate regardless of room speed or frame rate.
        Variables are adjusted by a specified change value over 1 second multiplied by the delta time.   
    
        Here are some examples of how to use the global delta timing variable "global.dt_steady":
    
            pixelsPerSecond = 100; // Pixels to move during 1 second
            x += pixelsPerSecond * global.dt_steady; // Move x right by multiplying pixels per second by the delta time
        
            healthPerSecond = 5; // Health to add over 1 second
            health = health + (healthPerSecond * global.dt_steady);
        
            // Turn counter-clockwise by 45 degrees every second 
            direction -= 45 * global.dt_steady;
        
            // Update timer for tracking seconds elapsed
            timerSeconds += global.dt_steady;

    [Scale]
        Changing the delta scale allows for global slow/fast motion affects for all values using "global.dt_steady".
        You can change the delta time scale, at any time, by writing:
    
            obj_SteadyDeltaTime.scale = 0.0; // "Pause"
            obj_SteadyDeltaTime.scale = 0.5; // Half speed
            obj_SteadyDeltaTime.scale = 1.0; // Normal speed
            obj_SteadyDeltaTime.scale = 2.0; // Double speed
        
    [Minimum Frame Rate]
        To prevent sporadic delta timing values, a minimum frame rate is required.
        If the game runs slower than the set minimum, delta timing will begin to lag behind the step udpate.
        You can change the value at any time by writing:
    
            obj_SteadyDeltaTime.minFPS = 5;
            obj_SteadyDeltaTime.minFPS = 10; // Default
            obj_SteadyDeltaTime.minFPS = 15;
        
        It is advised to keep this at the default value of 10. 
        Values set too low can increase chances of sporadic behaviour.
        Values set too high can increase the chance of games lagging behind during heavy CPU/GPU load.
		
	[Unsteady Delta Timing]
		There are situations where you may need a "raw" delta time value.
		You can use "global.dt_unsteady" in such cases, when you don't want things steadied by a minimum frame rate.
		For example, this could be used for an "Idle Game" when you want to calculate a player's progress
		and include the entire time that the game's window has been out of focus.
		
			addCash = 25; // Money to add every second
			cash += addCash * global.dt_unsteady;
		
		(Only use this if you know what you are doing!)
*/

/************
	Setup
*************/

// Global value which holds the managed delta time.
// If you want, you can change the naming convention or use 'globalvar' instead of 'global.'
// Be sure to also update the step event if you modify the naming convention.
global.dt_steady = 0;

// Global value which holds a "raw" delta time.
// This differs from global.dt_steady, as it is not corrected for sporadic behaviour with 'minFPS'.
global.dt_unsteady = 0;

// The lowest required frame rate before delta time will lag behind Step update.
// Setting this too low can increase chance of sporadic behaviour.
// Setting too high can cause games to lag behind during heavy cpu/gpu load.
minFPS = 10; // Default: 10 -- Not too hot, not too cold, but just right

// The scale factor to multiply with delta time.
// Can be used to create global slow/fast motion affects.
// Negative values can be used, but are not advised under normal circumstances.
scale = 1.0; // Default: 1.0 -- Set higher to increase speed and lower to decrease speed

//***************
// DON'T TOUCH //
//***************
// Internal calculated delta time
dt = delta_time/1000000;
// Previous value of internal delta time
dtPrevious = dt;
// Whether or not internal delta time has been restored to previous value
dtRestored = false;
