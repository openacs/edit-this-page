<master src="etp-master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<form method="post" action="etp-create-2">
<table width="100%" cellspacing="0" cellpadding="6">
<tr>
<td valign="top">
<b>Page&nbsp;name</b>
<td valign="top">
<input name="name" value="@new_page_name@">
<td valign="top" width="50%">
This must be a short identifier containing 
no spaces.  It will be the final name in the URL that identifies this page.
Depending on the <code>auto_page_name</code> parameter, the page name be
be pre-filled with a unique number or with a number representing today's date.
</tr><tr>
<td valign="top">
<b>Page&nbsp;title</b>
<td valign="top">
<input name="title">
<td valign="top" width="50%">
You may change the title later if you like.
</tr>
<tr>
<td colspan="3" align="center">
<input type="submit" value="Submit">
</tr>
</table>
<p>
