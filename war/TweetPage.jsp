<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="/css/format.css">
</head>
<body>
 <script type="text/javascript" src="/js/tweet.js"></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.7.1.min.js"></script>
<div class="topnav">
  <a href="TweetPage.jsp"><b>Tweet</b></a>
  <a href="FriendsPage.jsp"><b>Friends</b></a>
  <a  id=toptweet href=TopTweetPage.jsp><b>Top Tweet</b></a>
  <div id="fb-root"></div>
</div><br>
<fb:login-button scope="public_profile,email" onlogin="checkLoginState();">
</fb:login-button>
<h3 id="fb-welcome"></h3>
<h3>Check out Tweet App on Facebook!</h3>
<img src="/css/fbhome.png" align="right" height="250" width="300">
<script type="text/javascript">callme()</script>
<%
if(null != request.getParameter("status")){
	request.setAttribute("status",request.getAttribute("status"));
}
%>
${status}
<input type=hidden id=status value="${status}">
<br><div align="left">
<table>
<tr>
<form id="storegae" action="GaeDataStore" method="get" name="storegae"  >
<td><textarea id="text_content" name="text_content" class="textarea"
							placeholder="What's on your mind?"></textarea></td>
<input type=hidden id=user_id name= user_id />
<input type=hidden id=first_name name=first_name  />
<input type=hidden id=last_name name=last_name  />
<input type=hidden id=picture name=picture  />
<script>

console.log(document.getElementById("first_name")+" "+document.getElementById("last_name")+" "+document.getElementById("picture"));
</script>
<td><input type="submit" id=submit name=save class="button" value="Tweet"/>
</form>
<br><input type="button"  id="create_tweet" class="button" value="Post Tweet" />
</tr>
</table>
</div>

<div align="center">

<div id="mypopup" class="popup">
<div  class="popup-content">
<span class="close">&times;</span>
<input type="button"  class="button" value="Share Tweet" name="share_tweet" onclick=shareTweet() />
<input type="button"  class="button" value="Send as Message" name="send_direct_msg" onclick=sendDirectMsg() />
</div>
</div>

</div>
<br><br><br><h3>You can view all the Tweets you posted and can share or delete them.</h3>
<form action="GetTweets.jsp" method="GET">
<input type=hidden id=user_ids name=user_ids  />
<br><input type="submit"  class="button" value="Show my Tweets" name="view_tweet" />
</form>

<script>

var modal = document.getElementById('mypopup');
var btn = document.getElementById("create_tweet");
var span = document.getElementsByClassName("close")[0];
btn.onclick = function() {
    modal.style.display = "block";
};
span.onclick = function() {
    modal.style.display = "none";
};
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
};
document.getElementById("user_ids").value       = getCookie('user_id');
document.getElementById("user_id").value       = getCookie('user_id');
document.getElementById("first_name").value = getCookie('first_name');
document.getElementById("first_names").value = getCookie('first_name');
document.getElementById("last_name").value  = getCookie('last_name');
document.getElementById("picture").value    = getCookie('picture');
document.getElementById("toptweet").href="TopTweetPage.jsp?name="+getCookie("first_name");

</script>
<script>
function statusChangeCallback(response) {
    console.log('statusChangeCallback');
    console.log(response);
    // The response object is returned with a status field that lets the
    // app know the current login status of the person.
    // Full docs on the response object can be found in the documentation
    // for FB.getLoginStatus().
    if (response.status === 'connected') {
      // Logged into your app and Facebook.
      testAPI();
    } else {
      // The person is not logged into your app or we are unable to tell.
      document.getElementById('status').innerHTML = 'Please log ' +
        'into this app.';
      
    }
  }

  // This function is called when someone finishes with the Login
  // Button.  See the onlogin handler attached to it in the sample
  // code below.
  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }
window.fbAsyncInit = function() {
FB.init({
       appId : '126714754661718',
       xfbml : true,
       version : 'v2.1'
    }); 
function onLogin(response) {
    if (response.status == 'connected') {
           FB.api('/me?fields= first_name, picture, last_name', function(data) {
                  var welcomeBlock = document.getElementById('fb-welcome');
                  welcomeBlock.innerHTML = '<img src="' + data.picture.data.url + '"/>' + ' Hello ' + data.first_name + ' ' + data.last_name + '!';
           });
    }
    else {
            var welcomeBlock = document.getElementById('fb-welcome');
           welcomeBlock.innerHTML = 'Cant get data ' + response.status + '!';}
}

FB.getLoginStatus(function(response) {
  // Check login status on load, and if the user is
  // already logged in, go directly to the welcome message.
  if (response.status == 'connected') {
           onLogin(response);
  } else {
       // Otherwise, show Login dialog first.
       FB.login(function(response) {   onLogin(response);} , {scope: 'user_friends, email'}   );
  }
});        // ADD ADDITIONAL FACEBOOK CODE HERE AS YOU DESIRE
};

(function(d, s, id){
       var js, fjs = d.getElementsByTagName(s)[0];
       if (d.getElementById(id)) {return;}
       js = d.createElement(s); js.id = id;
       js.src = "//connect.facebook.net/en_US/sdk.js";
       fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));

// Place following code after FB.init call.
function testMessageCreate() {
 console.log('Posting a message to user feed.... '); 
 //first must ask for permission to post and then will have call back function defined right inline code
 // to post the message.
 FB.login(function(){
       var typed_text = document.getElementById("message_text").value;
        FB.api('/me/feed', 'post', {message: typed_text});
        document.getElementById('theText').innerHTML = 'Thanks for posting the message. Please check your timeline. ';
   }, {scope: 'publish_actions'});
}
                        
</script>
</body>
</html>

