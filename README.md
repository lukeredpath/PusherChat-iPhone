# PusherChat for iPhone

This is a small iPhone app that demonstrates the use of the [libPusher](http://github.com/lukeredpath/libPusher) library for communicating with the [Pusher](http://pusher.com) real-time messaging service.

It acts as a client to [PusherChat-Rails](https://github.com/tarnfeld/PusherChat-Rails) app, a small example chat app written in Ruby on Rails and using Pusher for messaging.

## Building from source

You will need a running instance of [my PusherChat-Rails fork](https://github.com/lukeredpath/PusherChat-Rails). This fork adds a few extra APIs for the iPhone app.

After cloning the project, you will need to initialise all of the project submodules:

    $ git submodule update --init --recursive
    
Finally, you'll need to create a file in the PusherChat-iPhone directory called PusherSettings.h which contains your Pusher API settings. It should look something like this:

    #define kPUSHER_APP_ID  123
    #define kPUSHER_API_KEY @"your-api-key"
    #define kPUSHER_SECRET  @"your-secret"
    
Finally, you may need to modify the PusherChat `kPUSHER_CHAT_SERVICE_URL` constant in the app delegate to match the running instance of PusherChat-Rails on your local machine.

At this stage, you should be good to go.
