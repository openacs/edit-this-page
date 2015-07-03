<master src="etp-master">
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

#edit-this-page.lt_The_ETP_application#

<p>
<center>
<form action="etp-setup" method=post>
<input type="hidden" name="confirmed" value="t">
<table width="90%">
<tr>
<th valign="top">#edit-this-page.Application#</th>
<td>
<select name="app">@app_options;noquote@</select>
</td></tr>
<tr>
<th valign="top">#edit-this-page.Subtopic_Application#</th>
<td>
<select name="subtopic_app">@subtopic_app_options;noquote@</select>
<p>
</td></tr>
<tr>
<td colspan="2" align="center">
<input type="submit" value="#edit-this-page.save_changes#">
</td></tr>
</table>
</form>
</center>
<p>



