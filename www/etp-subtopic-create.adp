<master src="etp-master">
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<form method="post" action="etp-subtopic-create">
@form_vars;noquote@
<table width="100%" cellspacing="0" cellpadding="6">
<tr>
<td valign="top">
<b>#edit-this-page.Subtopic_name#</b>
<td valign="top">
<input name="subtopic_name">
<td valign="top" width="50%">
#edit-this-page.lt_This_must_be_a_short_identifier#
</tr><tr>
<td valign="top">
<b>#edit-this-page.Subtopic_title#</b>
<td valign="top">
<input name="subtopic_title">
<td valign="top" width="50%">
#edit-this-page.lt_This_will_be_the_title#
</tr>
<tr>
<td colspan="3" align="center">
<input type="submit" value="#acs-kernel.common_Submit#">
</tr>
</table>
<p>

