<master src="etp-master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<form method="post" action="etp-extlink">
@form_vars;noquote@
<table width="100%" cellspacing="0" cellpadding="6">
<tr>
<td valign="top">
<b>External URL</b>
<td valign="top">
<input name="url" value="@url@" size="35">
<td valign="top" width="50%">
This is the url of the link destination.  If the link is to another site,
it must be fully qualified beginning with <code>http://</code>.
</tr><tr>
<td valign="top">
<b>Title</b>
<td valign="top">
<input name="label" value="@label@" size="35">
<td valign="top" width="50%">
This is the text of the link that will be generated.
</tr><tr>
<td valign="top">
<b>Description</b>
<td valign="top" colspan="2">
<textarea name="description" rows="4" cols="60">
@description@
</textarea>
</tr>
<tr>
<td colspan="3" align="center">
<input type="submit" value="Submit">
</tr>
</table>
<p>
