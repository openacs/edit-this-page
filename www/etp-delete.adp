<master src="etp-master">
<property name="title">Confirm delete operation for @name@</property>
Are you sure you want to delete the page "@title@" at @page_url@ ?
This operation cannot be undone.
<p>
<form method="post" action="etp-delete">
@form_vars@
<input type="submit" value="Yes, I'm sure">
</form>

