<master src="etp-master">
<property name="title">Confirm delete operation for @name;noquote@</property>
Are you sure you want to delete the page "@title@" at @page_url@ ?
This operation cannot be undone.
<p>
<form method="post" action="etp-delete">
@form_vars;noquote@
<input type="submit" value="Yes, I'm sure">
</form>

