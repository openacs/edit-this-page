<master src="etp-master">
<property name="doc(title)">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<form method="post" action="etp-create-2">
<table width="100%" cellspacing="0" cellpadding="6">
<tr>
<td valign="top">
<b>#edit-this-page.Page_name#</b>
<td valign="top">
<input name="name" value="@new_page_name@">
<td valign="top" width="50%">
#edit-this-page.lt_This_must_be_a_short_# <code>#edit-this-page.auto_page_name#</code> #edit-this-page.lt_parameter_the_page_name#
</tr><tr>
<td valign="top">
<b>#edit-this-page.Page_title#</b>
<td valign="top">
<input name="title">
<td valign="top" width="50%">
#edit-this-page.lt_You_may_change_the_ti#
</tr>
<tr>
<td colspan="3" align="center">
<input type="submit" value="#acs-kernel.common_Submit#">
</tr>
</table>
<p>

