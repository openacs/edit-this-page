<master src="etp-master">
<property name="title">@page_title@</property>
<property name="context">@context@</property>

The ETP application in use for a content section determines the
appearance and content of its pages.  You may also specify the
application that should be used when a subtopic is created within
this content section.

<p>
<center>
<form action="etp-setup" method=post>
<input type="hidden" name="confirmed" value="t">
<table width="90%">
<tr>
<th valign="top">Application:</th>
<td>
<select name="app">@app_options@</select>
</td></tr>
<tr>
<th valign="top">Subtopic Application:</th>
<td>
<select name="subtopic_app">@subtopic_app_options@</select>
<p>
</td></tr>
<tr>
<td colspan="2" align="center">
<input type="submit" value="Save changes">
</td></tr>
</table>
</form>
</center>
<p>


