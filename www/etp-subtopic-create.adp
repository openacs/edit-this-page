<master src="etp-master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<form method="post" action="etp-subtopic-create">
@form_vars;noquote@
<table width="100%" cellspacing="0" cellpadding="6">
<tr>
<td valign="top">
<b>Subtopic&nbsp;name</b>
<td valign="top">
<input name="subtopic_name">
<td valign="top" width="50%">
This must be a short identifier containing no spaces.  It will be the 
final part of the URL that identifies this subtopic.
</tr><tr>
<td valign="top">
<b>Subtopic&nbsp;title</b>
<td valign="top">
<input name="subtopic_title">
<td valign="top" width="50%">
This will be the title of the top-level page in this subtopic.  You
may change it later if you like.
</tr>
<tr>
<td colspan="3" align="center">
<input type="submit" value="Submit">
</tr>
</table>
<p>
