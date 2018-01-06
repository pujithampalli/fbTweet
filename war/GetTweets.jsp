<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="/css/format.css">
<script type="text/javascript" src="/js/tweet.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div class="topnav">
  <a href="TweetPage.jsp"><b>Tweet</b></a>
  <a href="FriendsPage.jsp"><b>Friends</b></a>
  <a  id=toptweet href=TopTweetPage.jsp><b>Top Tweet</b></a>
  <div id="fb-root"></div>
</div><br>
<fb:login-button scope="public_profile,email" onlogin="checkLoginState();">
</fb:login-button>
<h3 id="fb-welcome"></h3>
<h3>Here are your tweets!</h3>
<h3>You can share them or delete them if you want.</h3>
<img src="/css/fbhome.png" align="right" height="250" width="300">



<%
	DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	Entity e = new Entity("tweet");
	Query q = new Query("tweet");
	PreparedQuery pq = ds.prepare(q);
	int count = 0;
	for (Entity result : pq.asIterable()) {
		if (result.getProperty("user_id") != null
				&& ((result.getProperty("user_id")).equals(request.getParameter("user_ids")))) {
			//out.println(result.getProperty("first_name")+" "+request.getParameter("name"));
			String first_name = (String) result.getProperty("first_name");
			count++;
			String lastName = (String) result.getProperty("last_name");
			String user_id = (String) result.getProperty("user_id");
			String picture = (String) result.getProperty("picture");
			String status = (String) result.getProperty("status");
			Long id = (Long) result.getKey().getId();
			String time = (String) result.getProperty("timestamp");
			Long visited_count = (Long) ((result.getProperty("visited_count")));
			StringBuffer sb = new StringBuffer();
			String url = request.getRequestURL().toString();
			String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
					+ request.getContextPath() + "/";
			sb.append(baseURL + "TimelineTweet.jsp?id=" + id);
%>

<table>
	<div>
		<tr>
			<td><br>
			<br>Tweet: <%=status%></td>
		</tr>
	<tr>
		<td>Posted at: <%=time%></td>
	</tr>
	<tr>
		<td>#Visited: <%=visited_count%></td>
	</tr>
	<tr>
		<form action="GetTweets.jsp" action="GET">
			<input type=hidden name=user_id id=user_id value=<%=user_id%> /> <input
				type=hidden name=u_id id=u_id value=<%=id%> />
			<td><button name="Delete" type="submit" class="button"
					value=Delete />Delete</button></td>
		</form>
		<div align="center">
			<div id="mypopup" class="popup">
				<div class="popup-content">
					<span class="close">&times;</span> 
					<script type="text/javascript">message="<%= sb  %>"</script>
					<button type="button"
						class="button" 
						onclick=shareMyTweet(message) > Share Tweet</button> 
					<button type="button" class="button"
						 name="send_direct_msg"
						onclick=sendmyDirectTweet(message) >Send as Message</button>
				</div>
			</div>
		</div>
		<td><button name="Share" type="button" class="button" id=share value=<%=sb%>  onclick=modalOpen(this) />share</td>
	</tr>
	<script type="text/javascript">
	function modalOpen(obj){
		console.log("inside"+obj.value);
	var modal = document.getElementById('mypopup');
	var btn = obj;
	var span = document.getElementsByClassName("close")[0];
	modal.style.display = "block";
	span.onclick = function() {
		modal.style.display = "none";
	};
	window.onclick = function(event) {
		if (event.target == modal) {
			modal.style.display = "none";
		}
	};
	}
	</script>
	</div>
</table>
<script type="text/javascript">

function shareMyTweet( message){
	FB.ui({method: 'share',
		href: message,
		//quote: document.getElementById('text_content').value,
		},function(response){
		if (!response || response.error)
		{
			console.log(response.error);
			alert('Posting error occured');
		}
	});
}

function sendmyDirectTweet(message){
	FB.ui({method:  'send',
		  link: message,});
	console.log(document.getElementById("status"));
}
</script>
<%
	Entity s = ds.get(KeyFactory.createKey("tweet", id));
			s.setProperty("visited_count", visited_count + 1);
			ds.put(s);
			//  count++;
		}
	}
	if (request.getParameter("u_id") != null) {
		Entity s = ds.get(KeyFactory.createKey("tweet", Long.parseLong(request.getParameter("u_id"))));
		//s.getKey();
		ds.delete(s.getKey());
		out.println("Tweet is deleted as per the request!");
	}
%>
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