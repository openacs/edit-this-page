<master src="etp-master">
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<form method="post" action="etp-extlink">
@form_vars;noquote@
<table width="100%" cellspacing="0" cellpadding="6">
<tr>
<td valign="top">
<b>#edit-this-page.External_URL#</b>
<td valign="top">
<input name="url" value="@url@" size="35">
<td valign="top" width="50%">
#edit-this-page.lt_This_is_the_url_of_th# <code>http://</code>.
</tr><tr>
<td valign="top">
<b>#edit-this-page.Title#</b>
<td valign="top">
<input name="label" value="@label@" size="35">
<td valign="top" width="50%">
#edit-this-page.lt_This_is_the_text_of_t#
</tr><tr>
<td valign="top">
<b>#edit-this-page.Description#</b>
<td valign="top" colspan="2">
<textarea name="description" rows="4" cols="60">
@description@
</textarea>
</tr>
<tr>
<td colspan="3" align="center">
<input type="submit" value="#acs-kernel.common_Submit#">
</tr>
</table>
<p>


