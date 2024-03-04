# Acerola Game Jam 

# Day 1 ## 2/28 

First day, not so bad!  

I plotted out the broad idea for the game – some kinda of phasmaphobia like game. You gotta go into a place with a camera and take pics of things you can’t see with the naked eye. 

So, I started off on the project. I grabbed an addon to just get some basic movement down. Something that I can add more to later on. I whipped together a quick little test environment to run around in. Movement seems smooth enough, so I continued on and made a crappy little camera model I can use. I added a light that I can use as a flash later. And that’s the end of day one! 

 

Day 2 2/29 

I started plotting out some more details for the actual gameplay. (while I was at work LOL) So the gist of it is, you need to enter some location and search through it for aberrations. But you can’t see them with the naked eye, you can only see them through digital photography (not sure i wanna do video or just leave it as photos, since video might make it too easy??) 

There will also be entities in the location that will follow you and try to interact with you. If they get too close for too long, you’ll black out and lose some saved photos. But you can disperse them if you can find them. (but they’ll come back later). This was where the main idea for this game really came from, cause I thought it would be creepy if you had to take photos of something that you couldn’t see, and could see it getting closer to you through the camera. 

You’ll get points at the end when you submit your photos to whoever wants to look at them. You’ll get points for every photo you take that contains an aberration (subtracting any submitted photos that do not contain an aberration). 

Things I know I need: 

    A viewport camera on the camera 

    This will take a snapshot and display it on the camera’s screen 

    A resource for each photo taken. 

    Will have variables like 

    The image itself 

    # of aberrations in photo 

    Going to do it this way, because I bet there is a way to tell if an object is in frame of a camera or not. (need to make sure that it doesn’t register as being in frame if it’s behind an object. Otherwise you could take a pic of the entire location and get every aberration LOL) 

    Starred boolean 

    I wanna make it so you can star photos at any time, so you can star any that you think have an aberration or whatever 

    Or maybe you have to star the photos you wanna submit 

    An aberration layer. 

    I read that there is a way to make objects appear in one viewport camera, but not another. I’ll just have to put the aberrations on a layer that only the “camera” camera can see, but not the fps camera. Sounds pretty simple, fingers crossed🤞 that it stays that way! 

    Entities 

    Thinking of a couple different kinds 

    One that is slow to come towards you, but is always coming.  

    One that you can only see in the camera flash as a shadow 

    One that moves towards you but only when you take a picture.  

    Location 

    Probably just a house, or a factory or something, idk yet. 

    This one will come later. The gameplay is more important first. 

So I know I want to get the camera working first and foremost. So click -> flash -> photo appears on camera screen. Ezpz. 

Then i want to try out the aberration layer and make sure it only appears in the photos. I’ll probably jsut add a cube or something to the layer just to make sure it works.  

I’ll add more tomorrow! Peace ✌ 

 

Day 3 3/1 

Didn’t get quite as far as I wanted to yesterday, but that’s okay! I’ve got the camera set up to flash when I click, now I’m struggling with getting the image from the camera to save and display on the camera’s screen. I’m sure I can get it eventually, Just hope it doesn’t eat up too much of my time! 

 

PART 2: 

Hey actually got the camera working! Not only that, got it to work so that certain Objects show up only under the camera, and not the player’s view 

A video game of a room with a television and a shadow

Description automatically generated 

Now I just need to get image saving/loading to work properly, so then we can thumb through any images we’ve taken. 

 

Day 3 3/2 

Got quite a bit of work done yesterday! I managed to get images to save to an array in the camera script, and each image is a part of a resource that keeps a sort of double linked list to the other images taken. So you can now flip through the images you’ve taken on the camera screen. I also added in a little star option for later, so you can star any images you want to keep and submit at the end of the game. Now I am working towards generating a list of visible aberrations for each image. So then later when you submit the starred images, we’ll know how many aberrations you found 

 

Day 5 3/4 

Didn’t  really get much work done yesterday, but i got some! So I have it set up to tell when an aberattion is captured in an image. The only issue is, is that it works through walls at the moment. So I can just walk up to a wall and take a pic and get every aberattion. Obviously not something we want 

 
