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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="/css/format.css">
<title>Top Tweets</title>
</head>
<body>
 <script type="text/javascript" src="/js/tweet.js"></script>
 <script> callme();</script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
<div class="topnav">
  <a href="TweetPage.jsp"><b>Tweet</b></a>
  <a href="FriendsPage.jsp"><b>Friends</b></a>
  <a  id=toptweet href=TopTweetPage.jsp><b>Top Tweet</b></a>
  <div id="fb-root"></div>
</div><br>
<fb:login-button scope="public_profile,email" onlogin="checkLoginState();">
</fb:login-button>
<h3>The Popular Tweets of my App!</h3>
<img src="/css/Twitter.jpg" align="right">

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
				
			  <table border="4">
			  <tr><td>User Name: <%= first_name+" "+lastName %> </td></tr>
			  <tr><td>Tweet: <%= status %></td></tr>
			  <tr><td>Tweeted at: <%= time %></td></tr>
			  <tr><td>Visit Count: <%= visited_count %></td></tr>
			  </table>
			  <br><br>
			  <%  Entity s=ds.get(KeyFactory.createKey("tweet", id));
			  s.setProperty("visited_count", visited_count+1);
			  ds.put(s);
			  count++;
			 
		}
	}
%>
</body>
</html>