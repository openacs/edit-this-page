<master src="etp-master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<form method="post" action="etp-edit-2">
@form_vars;noquote@
<table>
<tr><td>
@notification_chunk;noquote@
</td></tr>
<tr><td align=center>
<input type="submit" value="Submit">
</td></tr>
</table>
</form>