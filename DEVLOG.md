# Acerola Game Jam 

## Day 1 2/28 

First day, not so bad!  

I plotted out the broad idea for the game – some kinda of phasmaphobia like game. You gotta go into a place with a camera and take pics of things you can’t see with the naked eye. 

So, I started off on the project. I grabbed an addon to just get some basic movement down. Something that I can add more to later on. I whipped together a quick little test environment to run around in. Movement seems smooth enough, so I continued on and made a crappy little camera model I can use. I added a light that I can use as a flash later. And that’s the end of day one! 

 

## Day 2 2/29 

I started plotting out some more details for the actual gameplay. (while I was at work LOL) So the gist of it is, you need to enter some location and search through it for aberrations. But you can’t see them with the naked eye, you can only see them through digital photography (not sure i wanna do video or just leave it as photos, since video might make it too easy??) 

There will also be entities in the location that will follow you and try to interact with you. If they get too close for too long, you’ll black out and lose some saved photos. But you can disperse them if you can find them. (but they’ll come back later). This was where the main idea for this game really came from, cause I thought it would be creepy if you had to take photos of something that you couldn’t see, and could see it getting closer to you through the camera. 

You’ll get points at the end when you submit your photos to whoever wants to look at them. You’ll get points for every photo you take that contains an aberration (subtracting any submitted photos that do not contain an aberration). 

Things I know I need: 
<ol>
 <li> 
  A viewport camera on the camera 
   <ol>
	<li>This will take a snapshot and display it on the camera’s screen </li>
   </ol>
 </li>
 <li>
  A resource for each photo taken. 
  <ol>
	<li>
	   Will have variables like 
	   <ol>
		 <li>
			The image itself 
		 </li>
		<li>
		  # of aberrations in photo 
		   <ol>
			<li>
			   Going to do it this way, because I bet there is a way to tell if an object is in frame of a camera or not. (need to make sure that it doesn’t register as being in frame if it’s behind an object. Otherwise you could take a pic of the entire location and get every aberration LOL) 
			</li>
		  </ol>
		</li>
		<li>
			 Starred boolean 
		   <ol>
			<li>
	I wanna make it so you can star photos at any time, so you can star any that you think have an aberration or whatever 
			</li>
			<li>
	Or maybe you have to star the photos you wanna submit 
			</li>
		  </ol>
		</li>
	   </ol>
	</li>
  </ol>
 </li>
 <li>
	  An aberration layer. 
	<ol>
	<li>
	I read that there is a way to make objects appear in one viewport camera, but not another. I’ll just have to put the aberrations on a layer that only the “camera” camera can see, but not the fps camera. Sounds pretty simple, fingers crossed🤞 that it stays that way! 
	</li>
  </ol>
 </li>
 <li>    Entities 
   <ol>
	<li>
	Thinking of a couple different kinds 
	   <ol>
		<li>
	One that is slow to come towards you, but is always coming.  
		</li>
		<li> One that you can only see in the camera flash as a shadow </li>
		<li> One that moves towards you but only when you take a picture. </li>
	  </ol>
	</li>
  </ol>
 </li>
 <li>
	Location 
	<ol>
	<li>
	   Probably just a house, or a factory or something, idk yet. 
	</li>
	<li>
		   This one will come later. The gameplay is more important first. 
	</li>
  </ol>
 </li>
</ol>







 






So I know I want to get the camera working first and foremost. So click -> flash -> photo appears on camera screen. Ezpz. 

Then i want to try out the aberration layer and make sure it only appears in the photos. I’ll probably jsut add a cube or something to the layer just to make sure it works.  

I’ll add more tomorrow! Peace ✌ 

 

## Day 3 3/1 

Didn’t get quite as far as I wanted to yesterday, but that’s okay! I’ve got the camera set up to flash when I click, now I’m struggling with getting the image from the camera to save and display on the camera’s screen. I’m sure I can get it eventually, Just hope it doesn’t eat up too much of my time! 

 

## PART 2: 

Hey actually got the camera working! Not only that, got it to work so that certain Objects show up only under the camera, and not the player’s view 

A video game of a room with a television and a shadow

Description automatically generated 

Now I just need to get image saving/loading to work properly, so then we can thumb through any images we’ve taken. 

 

## Day 3 3/2 

Got quite a bit of work done yesterday! I managed to get images to save to an array in the camera script, and each image is a part of a resource that keeps a sort of double linked list to the other images taken. So you can now flip through the images you’ve taken on the camera screen. I also added in a little star option for later, so you can star any images you want to keep and submit at the end of the game. Now I am working towards generating a list of visible aberrations for each image. So then later when you submit the starred images, we’ll know how many aberrations you found 

 

## Day 5 3/4 

Didn’t  really get much work done yesterday, but i got some! So I have it set up to tell when an aberattion is captured in an image. The only issue is, is that it works through walls at the moment. So I can just walk up to a wall and take a pic and get every aberattion. Obviously not something we want 

## Day 6 3/5

Not so much forward movement yeserday either. I somewhat got occular culling working so that anything behind a wall would not get seen by the camera, yadda yadda yadda. But occular culling doesn't work great for moving nodes, and I wanted some aberrations to move, so that option might be out.
BUT I am looking into using raycasting to tell what is in front of the camera. I'm hoping to be able to cast a few rays out from the camera, and a few at an angle to match the cameras fov. And since rays get stopped by walls and stuff, I think it aught to work. 


## Day 7 3/6
I stayed up a bit too late last night, but I got some good work done! I got raytracing more or less completed. It's a bit janky, I added like 100 ray tracing nodes on to the front of the camera in a camera shape, and had them all shoot off at the same time, tell me how many of them hit an aberration, and then return if 5 or more hit one. Thinking about it right now, I never checked if it could hit more than one at a time 😅, but that's something for me to check later!
Right now I'm working on an improved method for casting these rays. I'm hoping I can just make a method that loops a bunch, and will update a single ray's rotation, and just shoot a bunch within the viewport. Might be a little cleaner and more manageable.
After this is working, I'll be moving on to game finish logic. Right now i'lll just have an area you walk into that will submit your favorited pics and calculate your total payday.
After that, I'll try to get a basic enemy AI working to act as the agressive aberrations. Something that follows you slowly, and if the player comes within it's area node, it'll start a timer (will need to make some sort of visual effect) and when the timer runs out, you'll black out, lose a percentage of pics, and get put out to the front of the area.
Then when that's done, I'll make a bit of a larger test area, and try my hand at dynamically adding aberrations to the scene. So that everything is not in the same position every time you play, and that different types of aberrations will appear.

## Day 8 3/7
Spent a liiiitle too much time yesterday trying to get fancy with the raycasting. It didn't quite pan out, but I have a few ideas of how to improve it if I have more time later on, or if I wanna keep working on this after the jam.
Besides that, got it set up to have a scoring system in place! so at the end of the game -- which is whenever you think you've gotten all abberations, or just want to leave -- Your score will get added up and you'll get a certain amount of money! So far, the score is determined by
<ul>
 <li>Number of aberrations captured in pictures</li>
 <li>minus the number of aberrations not captured</li>
 <li>minus the number of images submitted that do not contain aberrations</li>
 <li>A bonus amount based on the time it took to complete the level</li>
</ul>

I think im going to start working a bit on enemy AI today. Since the agressive AI are aberrations, it might be okay for them to just move through walls. Well, maybe not all of them, but at least the slow one. I think the one that moves whenever you take a pic should move pretty fast. Like that mofo scp-173.
I think it's gonna work something like this: You start the level, and go into the location and start lookin for aberrations. If you either: take a pic of a certain percentage of the aberrations OR are inside for ~2 minutes, then the aggressive aberrations will spawn.
I think I want the slow aberration to have three areas attached to it. One that is pretty large, that will start some kind of creepy ambiance noise. Another one that will blink out your flashlight. maybe some other noises. And one that is the closest to it's body, that will just mess you up if you're in it for a more than a second or two maybe.
I'll get this one working, then will move on to other aspects of the game until later on. Don't wanna run out of time making to many enemies just yet!

OH! One thing I do need to work on is some freakin UI. Other UI elements can come around later, but the important one is UI that list out the buttons you can press. So if you have the cam up to your face, you know how to navigate through. 

## Day 9 3/8
Did get some decent work done yesterday! Fixed the delete option, so you can actually delete images you dont want now (excluding any starred pics). I got some basic Enemy AI working! At the very least, it moves towards you! I'm gonna work on getting noises/attacks working tomorrow. 
I tried my hand at whipping up some models for levels, but I'm thinking I might go with some free asset packs, since making models takes up a lot of time that I could use for level/game design. At the very least, ill try to design the aberrations.
My goal for today is to work on enemy attacks, and what happens when you die. I'm thinking you have 3 lives before you actually die. something like that! 

## Day 10 3/9
Coming up towards the end of the jam so this weekend will be a bit of crunch time for me. I'm also kinda sick so it's not a good combo. Since I'm sick i dont really remember what I finished last night. I know I put in some footsteps and started making the final environment for the level. And right now I'm working on making interactable objects, so you can open doors, and interact with the car when you want to leave. At the end I want to come up with a kind of leaderboard for the amount of cash you're able to rake in. but that might have to come later.

## Day 12 3/11
I spent most of yesterday finishing up the environment. Only one level, but thats okay to start! I think if I had more time, I would've played around with textures a little more, found something that I really liked, but what I have set up is okay! 
Now I'm working on getting aberrations set up, and getting them to spawn in a random number in the house. then once that's good, I'll also need to finish up the enemy aberration and make sure he works correctly in the level. I think he'll be able to get upstairs and everything, so that's cool. Once he sarts working, just gotta add a death/passout mechanic. I have a fadetoblack animation already, probably wouldn't be hugely difficult to make a pass out animation! just float the character up a little in the air with some choking noises and then fade to black, then put outside after deleting a random num of images.

