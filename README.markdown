## Ruby Goldberg

A reason to create lots of pointless Ruby-based projects talkin' trash on 
the tubez.


Ruby Goldberg is composed of two parts.

### Reuben

The Ruby Goldberg server (reuben) is responsible for registering clients (rubes). 
The registration is a simple POST to with several parameters:

 - name: the name of the rube
 - description: a longer, possibly funny, description of what the rube does
 - url: the url where the rube can be found and packages can be delivered

Reuben is also in charge of starting the contraption (the collection of rubes),
keeping track of where a package has been and where it's going next.

  - Registers rubes
  - Starts a new contraption
  - Tracks where the package has been in the contraption
  - Accepts transmogrified packages from the rubes
  - Checks if the rubes are still alive (before sending package)
  - Returns package to the requestor

### Rubes

Ruby Goldberg clients (rubes) are arbitrarily complex web services spread all 
throughout the tubes. They start by telling the Reuben their name (name), what 
they do with the package (description) and where they are (url). This is a 
simple POST with those params.

The home url needs to accept a _package_, process said package and post the
job key back to Reuben.
  
Reuben will respond with the next URL in the chain. The rube then forwards
the package to the next rube.

### Package

The package is a simple JSON structure that looks like this:

{
  

}