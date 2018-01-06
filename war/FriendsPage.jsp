<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="/css/format.css">
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

<h3 align="center">These are the Friends using the App and their Tweets.     <img src="/css/fbfriends.jpg" height="75" width="125"></h3>

<%
	DatastoreService ds=DatastoreServiceFactory.getDatastoreService();
	Entity e=new Entity("tweet");
	Query q=new Query("tweet").addSort("visited_count", SortDirection.DESCENDING);
	PreparedQuery pq = ds.prepare(q);
	int count=0;
	for (Entity result : pq.asIterable()) {
		if(count<5){
			  //out.println(result.getProperty("first_name")+" "+request.getParameter("name"));
			  String first_name = (String) result.getProperty("first_name");
			  String name = (String) result.getProperty("name");
			  String lastName = (String) result.getProperty("last_name");
			  String picture = (String) result.getProperty("picture");
			  String status = (String) result.getProperty("status");
			  Long id = (Long) result.getKey().getId();
			  String time = (String) result.getProperty("timestamp");
			  Long visited_count = (Long)((result.getProperty("visited_count")));
%>
				
			  
			  <br><br>
			  <table frame=box align="center">
			  <tr><td><div style="height: 50px; width:50px; position: relative"> <%= picture %></div><td>
			  </table>
			  <br><br>
			  <table border="2" align="left">
			  <tr><td>User: <%= first_name+" "+lastName %> </td></tr>
			  <tr><td>Tweet: <%= status %></td></tr>
			  <tr><td>Tweeted at: <%= time %></td></tr>
			  <tr><td>Visit Count: <%= visited_count %></td></tr>
			  </table>
			  <br><br>
			 
		<%}
	}
%>
</body>
</html>