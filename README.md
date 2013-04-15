# Influence

####App for logging everything and deducing how those things influence one another.

###Another iPhone task logging app?

In some sens, yes.

My ambition is to create an app that will store your food intake, coffee habits, moods etc. in a very simple way.

###Direction this is heading


My goal is to build an app that will at least log information from any iOS device.
I realize that doing analysis will be a much more difficult task; that on the begining will take place solely on the computer. 
Once I develop (or find) working methods to get the desired results I'll try to incorporate them into the app.

##How it works?

###Predefined Events

When you strive to keep things simple and clear the choice of words becomes crucial; because of that a predefined list of nested events became a vital part of the project.

It's a simple tab indented list:

```
Food
  Hamburger
		Beef
		Chicken
		Vegetarian
Drink
	Coffee
Mood
	Positive
	Negative
	Neutral
```

Nested events give you the freedom to log events with different levels of specifity. Sometimes it's hard to exactly pin down the details, but by having this structure your input will be much easier to process later.

Right now the mechanism is not that advanced so be sure to remove the app whenever you change the predefined list structure or names. You don't need to do that after adding a new Event.

Upcoming Features
-------------

So here comes a long list of features that I'd love to implement someday. They are written in order of importance. If you find any particular topic interesting from coding perspective - contact me.

* Logging data with optional notes and at any time
* Logging at different specifity level (Food -> Burger -> Chicken Burger)
* Hold to set preset value
* Pinned frequently used events with reversed captioning
* Plugins for tracking weather, pollution, location, sleep etc.
* iCloud sync
* History view with charts
* Analysis of correlations and influences, potentially deducing causes
* Importing data from different services (like Quantified Mind)
* Global analysis (based on data from users around the world)
* Speed combo logging