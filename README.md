# TwitterClient
<h1>Screenshots</h1>
  <img src="https://i.imgsafe.org/00863198ca.png" width="263" height="467"/>
  <img src="https://i.imgsafe.org/008646a514.png" width="263" height="467"/>
  <img src="https://i.imgsafe.org/00866424ef.png" width="263" height="467"/>
 </br>
<h1>The client is using <a href="https://docs.fabric.io/apple/twitter/overview.html">Fabric Twitter-Kit</a></h1>
<h2>1. Implements login with Twitter</h2>
<ul>
  <li>Displays a list of twitter accounts found on the device.</li>
  <li>if no accounts found it launches web twitter login</li>
</ul>
<h2>2. Displays list of followers for the logged-in user</h2>
<ul>
  <li>Profile image, handle, bio for each follower</li>
  <li>Follower cell height is dynamically sized based on the his bio</li>
  <li>Uses <a href="https://dev.twitter.com/overview/api/cursoring">cursors</a> for loading followers by pages as the user scroll (infinite scrolling)</li>
  <li>Pull to refresh</li>
  <li>Offline Caching</li>
</ul>
<h2>2. Follower Information</h2>
<ul>
  <li>Tapping a follower will show the Follower Information screen</li>
  <li>Displays the user profile image and background image as a header</li>
  <li>Parallex header</li>
  <li>Tapping on any of the images will show overlay view to dispaly the full image</li>
  <li>Follower Timeline (List of tweets) using <a href="https://docs.fabric.io/apple/twitter/show-timelines.html">Fabric Timelines</a> </li>
  <li>Pull to refresh</li>
</ul>
